// SPDX-License-Identifier: LicenseRef-XSOC-Proprietary
pragma solidity ^0.8.24;

import "./HonkVerifier.sol";

interface IXSOCSignerRegistry {
    function isValidRoot(bytes32 root) external view returns (bool);
    function currentRoot() external view returns (bytes32);
}

/// @title  XSOCZKVerifier
/// @notice Permissionless on-chain verifier for anchored DSKAG-IT-SIG ZK proofs.
///
/// Any party can verify that a transaction was signed by an enrolled compliance
/// posture on specific hardware, without trusting XSOC Corp and without an
/// oracle. The UltraHonk proof plus a recognized registry root is the only
/// authorization.
///
/// Anchored model (60 public inputs): the circuit proves the signer's
/// compliance key is a member of an authorized-signer Merkle tree whose root is
/// public input [59]. This contract additionally requires that root to be the
/// one the XSOCSignerRegistry has published, so a prover cannot substitute a
/// self-made tree.
///
/// @author XSOC Corp | CAGE Code 8ZXJ8 | UEI G1R1NKS81NF5
contract XSOCZKVerifier {

    event PolicyProven(
        bytes32 indexed proofId,
        bytes32 indexed txHash,
        bytes8  indexed policyTag,
        uint8   hardwareTier,
        uint32  txSeq,
        uint16  epoch,
        bytes32 registryRoot,
        address submitter,
        uint256 timestamp
    );

    event ProofRejected(
        bytes32 indexed txHash,
        address submitter,
        string  reason,
        uint256 timestamp
    );

    address public immutable owner;
    uint8   public circuitVersion;
    HonkVerifier public immutable verifier;
    IXSOCSignerRegistry public immutable registry;
    mapping(bytes32 => bool) public provenProofs;
    uint256 public totalProven;

    constructor(uint8 _circuitVersion, HonkVerifier _verifier, IXSOCSignerRegistry _registry) {
        owner          = msg.sender;
        circuitVersion = _circuitVersion;
        verifier       = _verifier;
        registry       = _registry;
    }

    /// @notice Submit an anchored DSKAG-IT-SIG UltraHonk proof for recording.
    ///         Permissionless: anyone can call. The proof and a recognized
    ///         registry root are the authorization.
    ///
    /// @param proofBytes   UltraHonk proof bytes from the xsoc-sig-zkp prover,
    ///                     with the public-input prefix removed.
    /// @param publicInputs 60 field elements. Noir ABI layout:
    ///                     tx_hash       fields[0..32]
    ///                     mac           fields[32..48]
    ///                     policy_tag    fields[48..56]
    ///                     hardware_tier fields[56]
    ///                     epoch         fields[57]
    ///                     tx_seq        fields[58]
    ///                     registry_root fields[59]
    function submitProof(
        bytes calldata proofBytes,
        bytes32[] calldata publicInputs
    ) external returns (bytes32 proofId) {
        require(publicInputs.length == 60, "XSOCZKVerifier: expected 60 public inputs");

        // The registry root must be one the enrollment service published.
        // Checked before the expensive proof verification.
        bytes32 registryRoot = publicInputs[59];
        if (!registry.isValidRoot(registryRoot)) {
            emit ProofRejected(_decodeBytes32(publicInputs, 0), msg.sender,
                "registry root not recognized", block.timestamp);
            revert("XSOCZKVerifier: unknown registry root");
        }

        // Verify the UltraHonk proof using the nargo-generated verifier.
        bool valid = verifier.verify(proofBytes, publicInputs);
        if (!valid) {
            emit ProofRejected(_decodeBytes32(publicInputs, 0), msg.sender,
                "UltraHonk proof verification failed", block.timestamp);
            revert("XSOCZKVerifier: proof verification failed");
        }

        bytes32 txHash    = _decodeBytes32(publicInputs, 0);
        bytes8  policyTag = _decodeBytes8(publicInputs, 48);
        uint8   hwTier    = uint8(uint256(publicInputs[56]));
        uint16  epoch     = uint16(uint256(publicInputs[57]));
        uint32  txSeq     = uint32(uint256(publicInputs[58]));

        require(epoch != 0,                 "XSOCZKVerifier: epoch must be >= 1");
        require(hwTier >= 1 && hwTier <= 3, "XSOCZKVerifier: invalid hardware tier");
        require(policyTag != bytes8(0),     "XSOCZKVerifier: policy tag must be non-zero");

        // proofId binds the recording-time registry root and the proven hardware
        // tier, so records made under a rotated-away root or at a different tier
        // are distinct. Adding the root is the SMT22 fix; binding hwTier restores
        // the SMT07 binding this wrapper lineage was missing.
        proofId = keccak256(abi.encodePacked(registryRoot, txHash, policyTag, hwTier, txSeq, epoch));
        require(!provenProofs[proofId], "XSOCZKVerifier: proof already recorded");

        provenProofs[proofId] = true;
        totalProven++;

        emit PolicyProven(proofId, txHash, policyTag, hwTier, txSeq, epoch,
            registryRoot, msg.sender, block.timestamp);
    }

    /// @notice True if a proof for this tuple was recorded while `registryRoot`
    ///         was the published root. A relying contract that gates on current
    ///         enrollment passes the registry's current root and gets false once
    ///         the root has rotated away from the recording-time root, so a
    ///         revoked signer's prior record no longer reads as currently proven.
    ///         Replaces the root-blind isProven (SMT22) and binds hwTier (SMT07).
    function isProvenAt(
        bytes32 registryRoot,
        bytes32 txHash, bytes8 policyTag, uint8 hwTier, uint32 txSeq, uint16 epoch
    ) external view returns (bool) {
        return provenProofs[
            keccak256(abi.encodePacked(registryRoot, txHash, policyTag, hwTier, txSeq, epoch))
        ];
    }

    /// @notice Convenience for the common gate: was this tuple proven under the
    ///         registry's current published root.
    function isProvenUnderCurrentRoot(
        bytes32 txHash, bytes8 policyTag, uint8 hwTier, uint32 txSeq, uint16 epoch
    ) external view returns (bool) {
        return provenProofs[
            keccak256(abi.encodePacked(registry.currentRoot(), txHash, policyTag, hwTier, txSeq, epoch))
        ];
    }

    function _decodeBytes32(bytes32[] calldata fields, uint256 offset)
        internal pure returns (bytes32 result) {
        for (uint256 i = 0; i < 32; i++) {
            result |= bytes32(uint256(fields[offset + i]) << (248 - i * 8));
        }
    }

    function _decodeBytes8(bytes32[] calldata fields, uint256 offset)
        internal pure returns (bytes8 result) {
        for (uint256 i = 0; i < 8; i++) {
            result |= bytes8(uint64(uint256(fields[offset + i]) << (56 - i * 8)));
        }
    }
}
