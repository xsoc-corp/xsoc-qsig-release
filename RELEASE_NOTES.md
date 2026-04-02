# XSOC-QSIG Release Notes

---

## v1.0.1 , April 2026

**NIE Integration: Nexus Identity Engine session bridge**

Commit: `83ba4bc` , xsoc-corp/xsoc-sig

### What is new

Added `xsoc-sig-core::nie` module (feature flag: `nie`), providing
native integration between the Nexus Identity Engine and DSKAG-IT-SIG.

**New types:**
- `NieSessionCtx` , bridges a 32-byte NIE session handle from
  `POST /nie/v1/attest` into an `EnrollmentCtx` for signing
- `NieAttestationFloor` , maps NIE attestation tiers (SoftwareMin,
  TpmHardware, TpmRequired) to `LicenseContribution` values

**New capability:**
The NIE integration extends the security guarantee of a DSKAG-IT-SIG
signature from "a valid key was used" to "a valid, enrolled,
authenticated, non-revoked identity on a specific hardware tier signed
this transaction." The NIE device fingerprint flows directly into the
ZK Layer 3 `device_hash` private input. A revoked or unatteested NIE
session produces a zero LicenseContribution (poison path), causing the
ZK Layer 4 assertion to fail on-chain without any XSOC infrastructure
in the verification path.

**No changes to:**
- Wire format (still 30 bytes standard, 46 bytes extended)
- Deployed Solidity contracts (no redeployment required)
- Verifying key (vk.bin unchanged)
- 2⁻¹²⁸ unconditional forgery bound (unchanged)
- Existing `EnrollmentCtx` API (fully backward compatible)

**Test coverage:**
7 new unit tests in `xsoc-sig-core::nie`:
construction, determinism, floor isolation, device fingerprint
accessor, epoch rotation, and full sign/verify roundtrip.

**Requires:** NIE deployment + XSOC commercial license with `nie`
feature enabled. Standalone XSOC-QSIG use is unaffected.

---

## v1.0.0 , March 2026

**Initial public release**

**Contract deployed:** Block 10,531,115, Ethereum Sepolia, March 26, 2026
**Contract address:** `0xAe3c62aE19b8406468b80cb9353046eE5f536c44`
**GitHub tag:** v1.0.0, March 31, 2026

### What this release establishes

First public release of the XSOC-QSIG (DSKAG-IT-SIG) transaction
signature SDK, establishing the following as prior art as of March 2026:

- The DSKAG-IT-SIG information-theoretic transaction signature
  construction with 2⁻¹²⁸ unconditional forgery bound
- The 30-byte wire format for IT-secure transaction signatures
- The NexusKey composite policy digest construction for compliance
  domain fusion at the key derivation layer
- The four-layer UltraHonk ZK proof system for permissionless
  on-chain compliance verification , no trusted setup
- Hardware-bound key derivation across three deployment tiers
- Production deployment on Ethereum Sepolia with live
  PolicyVerified events

### Artifacts

- Pre-compiled binaries: Linux x86-64, Windows x86-64,
  macOS aarch64, embedded ARM, WASM
- `contracts/HonkVerifier.sol` , 77 KB nargo-generated UltraHonk
  Solidity verifier (Barretenberg 0.82.2, Nargo 1.0.0-beta.3)
- `contracts/XSOCZKVerifier.sol` , Permissionless ZK compliance
  verifier with `submitProof()` and `isProven()`
- `circuits/vk.bin` , 1.8 KB UltraHonk verifying key

### Security properties

- Forgery bound: 2⁻¹²⁸ (standard mode), unconditional
- Quantum resistance: IT-secure, zero ECC dependency
- EUROCRYPT 2026 (ePrint 2026/280): P-256 now at 1,098 qubits
  (down 48%). XSOC-QSIG unaffected.

### Independent validation

- University of Luxembourg: no attacks found, entropy 7.998 bits/byte
- Cal Poly San Luis Obispo: 98.4% Dieharder pass rate
- George Mason University SENTINEL FP5223: all findings remediated

### Workspace tests (v1.0.0)

62 Rust tests + 15 Noir circuit tests , zero failures across
Linux, Windows, macOS, and embedded ARM platforms.

---

## Licensing

All use requires a valid written commercial license from XSOC Corp.
Contact: licensing@xsoccorp.com
ECCN 5D002.C1 | CAGE 8ZXJ8 | UEI G1R1NKS81NF5

© 2026 XSOC Corp. All Rights Reserved.
