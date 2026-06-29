// SPDX-License-Identifier: LicenseRef-XSOC-Proprietary
pragma solidity ^0.8.24;

/// @title  XSOCSignerRegistry
/// @notice Holds the authorized-signer Merkle root published by the XSOC
///         enrollment service. The ZK verifier requires that a proof's
///         registry_root public input equals a root this registry has
///         published. That binding is what makes DSKAG-IT-SIG membership
///         meaningful on-chain: only signers the enrollment service actually
///         registered (in a published tree) can produce a proof the verifier
///         accepts. This closes E-03 on-chain.
///
///         Hardenings: rotation is append-only so a revoked root cannot be
///         rolled back (SMT20), and ownership transfer is two-step so a mistyped
///         or hostile recipient cannot take ownership in one call (SMT21).
///
/// @author XSOC Corp | CAGE Code 8ZXJ8 | UEI G1R1NKS81NF5
contract XSOCSignerRegistry {

    event RootUpdated(bytes32 indexed newRoot, bytes32 indexed previousRoot, uint256 timestamp);
    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    address public owner;
    address public pendingOwner;

    /// The live authorized-signer Merkle root. Poseidon2-BN254 over the
    /// registry leaves, identical to the root the circuit verifies membership
    /// against (registry_leaf.nr / merkle.nr).
    bytes32 public currentRoot;

    /// Every root that has ever been current. updateRoot refuses any root already
    /// in this set, so rotation is append-only: a prior root cannot be reinstated.
    /// This is the SMT20 fix, making revocation by rotation irreversible.
    mapping(bytes32 => bool) public usedRoots;

    modifier onlyOwner() {
        require(msg.sender == owner, "registry: not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    /// @notice Publish a new authorized-signer root. Rotating the root takes
    ///         effect immediately: proofs against the prior root stop being
    ///         accepted, which is how a removed signer is revoked on-chain.
    function updateRoot(bytes32 newRoot) external onlyOwner {
        require(newRoot != bytes32(0), "registry: zero root");
        require(!usedRoots[newRoot], "registry: root reused");
        emit RootUpdated(newRoot, currentRoot, block.timestamp);
        currentRoot = newRoot;
        usedRoots[newRoot] = true;
    }

    /// @notice True iff `root` is the current published root.
    function isValidRoot(bytes32 root) external view returns (bool) {
        return root != bytes32(0) && root == currentRoot;
    }

    /// @notice Begin an ownership transfer. Does not change the owner; the
    ///         recipient must call acceptOwnership from `newOwner` for it to take
    ///         effect. This is the SMT21 fix: a typo'd or hostile recipient
    ///         cannot take ownership in one call.
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "registry: zero owner");
        pendingOwner = newOwner;
        emit OwnershipTransferStarted(owner, newOwner);
    }

    /// @notice Complete a pending ownership transfer. Callable only by the
    ///         pending owner, which catches a mistyped recipient and gives the
    ///         current owner a window to re-issue before it lands.
    function acceptOwnership() external {
        require(msg.sender == pendingOwner, "registry: not pending owner");
        emit OwnershipTransferred(owner, pendingOwner);
        owner = pendingOwner;
        pendingOwner = address(0);
    }
}
