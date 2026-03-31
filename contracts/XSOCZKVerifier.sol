// SPDX-License-Identifier: LicenseRef-XSOC-Proprietary
pragma solidity ^0.8.24;

import "./HonkVerifier.sol";

/// @title  XSOCZKVerifier
/// @notice Fully permissionless on-chain verifier for DSKAG-IT-SIG ZK proofs.
///
/// Any party on Ethereum can independently verify that a transaction was signed
/// by a specific compliance posture on specific hardware -- without trusting
/// XSOC Corp, without an oracle, and without any authorized submitter.
/// The UltraHonk proof is the only authorization.
///
/// @author XSOC Corp | CAGE Code 8ZXJ8 | UEI G1R1NKS81NF5

contract XSOCZKVerifier {

    // ── Events ───────────────────────────────────────────────────────────────

    event PolicyProven(
        bytes32 indexed proofId,
        bytes32 indexed txHash,
        bytes8  indexed policyTag,
        uint8   hardwareTier,
        uint32  txSeq,
        uint16  epoch,
        address submitter,
        uint256 timestamp
    );

    event ProofRejected(
        bytes32 indexed txHash,
        address submitter,
        string  reason,
        uint256 timestamp
    );

    // ── Storage ───────────────────────────────────────────────────────────────

    address public immutable owner;
    uint8   public circuitVersion;
    mapping(bytes32 => bool) public provenProofs;
    uint256 public totalProven;

    // ── Constructor ───────────────────────────────────────────────────────────

    constructor(uint8 _circuitVersion) {
        owner          = msg.sender;
        circuitVersion = _circuitVersion;
    }

    // ── Permissionless Verification ───────────────────────────────────────────

    /// @notice Submit a DSKAG-IT-SIG UltraHonk ZK proof for on-chain recording.
    /// PERMISSIONLESS: anyone can call this. The proof is the authorization.
    ///
    /// @param proofBytes  UltraHonk proof bytes from xsoc-sig-zkp prover
    /// @param publicInputs ABI-encoded public inputs (59 field elements)
    function submitProof(
        bytes calldata proofBytes,
        bytes32[] calldata publicInputs
    ) external returns (bytes32 proofId) {
        require(publicInputs.length == 59, "XSOCZKVerifier: expected 59 public inputs");

        // Verify the UltraHonk proof using the nargo-generated verifier
        bool valid = HonkVerifier.verify(proofBytes, publicInputs);
        if (!valid) {
            emit ProofRejected(bytes32(publicInputs[0]), msg.sender,
                "UltraHonk proof verification failed", block.timestamp);
            revert("XSOCZKVerifier: proof verification failed");
        }

        // Decode public inputs from field elements
        // Layout matches ZkPublicInputs::to_abi_bytes() in inputs.rs
        // tx_hash: fields[0..32], mac: fields[32..48], policy_tag: fields[48..56]
        // hardware_tier: fields[56], epoch: fields[57..59], tx_seq: fields[59..63]
        bytes32 txHash     = _decodeBytes32(publicInputs, 0);
        bytes8  policyTag  = _decodeBytes8(publicInputs, 48);
        uint8   hwTier     = uint8(uint256(publicInputs[56]));
        uint16  epoch      = uint16((uint256(publicInputs[57]) << 8) | uint256(publicInputs[58]));
        uint32  txSeq      = uint32(
            (uint256(publicInputs[59]) << 24) |
            (uint256(publicInputs[60]) << 16) |
            (uint256(publicInputs[61]) <<  8) |
             uint256(publicInputs[62])
        );

        // Validate public inputs
        require(epoch != 0,          "XSOCZKVerifier: epoch must be >= 1");
        require(hwTier >= 1 && hwTier <= 3, "XSOCZKVerifier: invalid hardware tier");
        require(policyTag != bytes8(0), "XSOCZKVerifier: policy tag must be non-zero");

        // Record proof
        proofId = keccak256(abi.encodePacked(txHash, policyTag, txSeq, epoch));
        require(!provenProofs[proofId], "XSOCZKVerifier: proof already recorded");

        provenProofs[proofId] = true;
        totalProven++;

        emit PolicyProven(proofId, txHash, policyTag, hwTier, txSeq, epoch,
            msg.sender, block.timestamp);
    }

    /// @notice Check whether a transaction has a verified ZK proof on-chain.
    function isProven(
        bytes32 txHash, bytes8 policyTag, uint32 txSeq, uint16 epoch
    ) external view returns (bool) {
        return provenProofs[keccak256(abi.encodePacked(txHash, policyTag, txSeq, epoch))];
    }

    // ── Internal ──────────────────────────────────────────────────────────────

    function _decodeBytes32(bytes32[] calldata fields, uint256 offset)
        internal pure returns (bytes32 result) {
        for (uint256 i = 0; i < 32; i++) {
            result |= bytes32(uint256(fields[offset + i]) << (248 - i * 8));
        }
    }

    function _decodeBytes8(bytes32[] calldata fields, uint256 offset)
        internal pure returns (bytes8 result) {
        for (uint256 i = 0; i < 8; i++) {
            result |= bytes8(uint64(uint256(fields[offset + i])) << (56 - i * 8));
        }
    }
}
