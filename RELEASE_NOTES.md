# XSOC-QSIG v1.0.0

**Release date:** March 2026  
**Contract deployed:** Block 10,531,115, Ethereum Sepolia  
**Contract address:** `0xAe3c62aE19b8406468b80cb9353046eE5f536c44`

## What This Release Establishes

This is the first public release of the XSOC-QSIG (DSKAG-IT-SIG)
transaction signature SDK, establishing the following as prior art
as of March 2026:

- The DSKAG-IT-SIG information-theoretic transaction signature
  construction with 2⁻¹²⁸ unconditional forgery bound
- The 30-byte wire format for IT-secure transaction signatures
- The NexusKey composite policy digest construction for compliance
  domain fusion at the key derivation layer
- The four-layer UltraHonk ZK proof system for permissionless
  on-chain compliance verification (MAC validity, policy binding,
  hardware binding, license binding) — no trusted setup
- Hardware-bound key derivation across three deployment tiers
  (TPM, Platform, Identity)
- Production deployment on Ethereum Sepolia with live
  PolicyVerified events

## Artifacts

- Pre-compiled binaries for Linux x86-64, Windows x86-64,
  macOS aarch64, embedded ARM, and WASM
- `contracts/HonkVerifier.sol` — 77 KB nargo-generated UltraHonk
  Solidity verifier (Barretenberg 0.82.2, Nargo 1.0.0-beta.3)
- `contracts/XSOCZKVerifier.sol` — Permissionless ZK compliance
  verifier with `submitProof()` and `isProven()`
- `circuits/vk.bin` — 1.8 KB UltraHonk verifying key
- `docs/api/` — Rustdoc API reference

## Security Properties

- Forgery bound: 2⁻¹²⁸ (standard mode), unconditional
- Quantum resistance: IT-secure, zero ECC dependency
- EUROCRYPT 2026 (ePrint 2026/280): P-256 now at 1,098 qubits
  (down 48%). XSOC-QSIG unaffected.

## Independent Validation

- University of Luxembourg: no attacks found, entropy 7.998 bits/byte
- Cal Poly Pomona: 98.4% Dieharder pass rate
- George Mason University SENTINEL FP5223: all findings remediated

## Workspace Tests

62 Rust tests + 15 Noir circuit tests — zero failures across
Linux, Windows, macOS, and embedded ARM platforms.

## Licensing

All use requires a valid written commercial license from XSOC Corp.  
Contact: licensing@xsoccorp.com  
ECCN 5D002.C1 | CAGE 8ZXJ8 | UEI G1R1NKS81NF5

© 2026 XSOC Corp. All Rights Reserved.
