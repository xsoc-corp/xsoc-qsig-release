# XSOC-QSIG: Transaction Signature SDK

**Post-Quantum. Policy-Fused. Hardware-Bound. 30 Bytes.**

XSOC-QSIG (DSKAG-IT-SIG) is the only production-deployed transaction
signature scheme that simultaneously achieves:

- **Post-quantum signatures**, 2^-128 forgery bound in standard mode, with
  no elliptic-curve, lattice, or isogeny dependency and therefore no Shor
  target
- **30-byte wire format**, fits every existing ISO 20022 SWIFT field today
  without re-engineering the message layer
- **NexusKey policy fusion**, compliance domain (asset class, jurisdiction,
  KYC level, transaction type) is fused into the signing key at the
  derivation layer, not the application layer
- **Hardware binding**, three tiers (TPM, Platform, Identity); keys are
  never stored or transmitted
- **Permissionless ZK verification**, any party on any EVM-compatible chain
  can verify all four compliance properties of a signature with no oracle
  and no XSOC Corp involvement in the verification path

## Security

XSOC-QSIG is a post-quantum symmetric transaction signature primitive.

- Post-quantum: the signing path contains no asymmetric primitive (no
  elliptic curve, no lattice, no isogeny, no multivariate system), and
  therefore has no Shor exposure.
- Forgery bound: EUF-CMA, 2^-128 in standard mode and 2^-256 in extended
  mode.
- Designated-verifier: verification is performed by a party holding the
  pairwise key, not a published public key. QSIG is not a public-key
  digital signature and does not provide non-repudiation against arbitrary
  third parties.
- Policy-fused and hardware-bound: the compliance domain is fused into key
  derivation, and keys are derived inside a hardware-bound context (TPM,
  Platform, or Identity) and are never transmitted in exportable form.

The full security model, reductions, and assumptions are in the
DSKAG-IT-SIG specification: https://doi.org/10.5281/zenodo.19639166

Note on terminology: earlier versions of this README described the
construction as "information-theoretic" or "unconditionally secure." That
language is superseded. XSOC-QSIG is computationally secure: the forgery
bound holds under the pseudorandom-function assumption on HMAC-SHA256 in
the standard model. The DSKAG key-derivation layer carries independently
measured statistical-uniformity properties, but the construction as a whole
is computationally secure, not information-theoretically secure.

## What is public and what is proprietary

This repository is the public, Apache-2.0 release: pre-compiled artifacts,
the Solidity verifier source, the UltraHonk verifying key, the deployment
manifest, and the on-chain verifier contracts.

| Component | Status |
|---|---|
| Solidity verifier contracts (HonkVerifier, XSOCZKVerifier), deployed and source-verified on Ethereum mainnet and Arbitrum One | Public, in this repository and on-chain |
| UltraHonk verifying key and pre-compiled artifacts | Public, in this repository |
| Deployment manifest (deployments.json) | Public, in this repository |
| DSKAG wave engine, key-derivation construction, and the production signing and MAC primitives | Proprietary trade secret. Not in this repository. Subject to export control (ECCN 5D002.C1). Available under license from XSOC. |

The on-chain verifier in this repository verifies zero-knowledge proofs
that a valid QSIG signature exists under a stated policy and hardware tier.
It does not contain and does not expose the DSKAG construction. The full
production QSIG capability, including the DSKAG-rooted signing and
wave-engine MAC, is implemented, tested, and available under license from
XSOC. Contact licensing@xsoccorp.com.

---

## Production Deployments

The XSOC-QSIG / DSKAG-IT-SIG ZK verifier infrastructure is deployed to public mainnets. Source verified on Etherscan and Arbiscan; bytecode reproducible from this repository.

### Ethereum Mainnet (Chain ID 1)

| Contract | Address | Etherscan |
|---|---|---|
| `HonkVerifier` | `0x0B7dDF8AE4B403Cc737C4843E0C567C91976fa66` | [view](https://etherscan.io/address/0x0B7dDF8AE4B403Cc737C4843E0C567C91976fa66) |
| `XSOCZKVerifier` | `0x85D7ba03019941ED6d3E83D1CA72C844fC14458d` | [view](https://etherscan.io/address/0x85D7ba03019941ED6d3E83D1CA72C844fC14458d) |

### Arbitrum One (Chain ID 42161)

| Contract | Address | Arbiscan |
|---|---|---|
| `HonkVerifier` | `0x0B7dDF8AE4B403Cc737C4843E0C567C91976fa66` | [view](https://arbiscan.io/address/0x0B7dDF8AE4B403Cc737C4843E0C567C91976fa66) |
| `XSOCZKVerifier` | `0x85D7ba03019941ED6d3E83D1CA72C844fC14458d` | [view](https://arbiscan.io/address/0x85D7ba03019941ED6d3E83D1CA72C844fC14458d) |

**Deployed:** May 13, 2026
**Deployer:** `0x101eF283CAb956EDEf54745b89272E1B8f2B7EA6` (deterministic across chains via matched nonce)
**Compiler:** Solc 0.8.27, optimizer enabled at runs=1, EVM version `cancun`
**Constructor args for `XSOCZKVerifier`:** `circuitVersion=1`, `honkVerifier=<HonkVerifier address above>`

All contracts are immutable post-deployment. The XSOC corporate identity has no privileged role in either verifier. Anyone may call `submitProof()` or `isProven()` without authorization; the UltraHonk proof is the sole authorization.

For machine-readable deployment metadata, see [`deployments.json`](./deployments.json).

### Test Deployments

| Network | Contract | Address |
|---|---|---|
| Ethereum Sepolia | `XSOCPolicyOracle` | `0xAe3c62aE19b8406468b80cb9353046eE5f536c44` |
| Arbitrum Sepolia | `HonkVerifier` | `0xAe3c62aE19b8406468b80cb9353046eE5f536c44` |
| Arbitrum Sepolia | `XSOCZKVerifier` | `0xD6D139fF694C178a9b641B280bbDBaF23b350A14` |

Testnet deployments remain operational for development and integration testing.

## Live On-Chain Deployment

**XSOCPolicyOracle, Ethereum Sepolia**
```
0xAe3c62aE19b8406468b80cb9353046eE5f536c44
```
https://sepolia.etherscan.io/address/0xAe3c62aE19b8406468b80cb9353046eE5f536c44#events

The contract has been live since block **10,531,115** (March 26, 2026).
`PolicyVerified` events are permanently recorded on-chain. The
`isProven()` function is callable by any address with no authorization.

> **Access model.** XSOCPolicyOracle is an owner-operated reference oracle, not a permissionless production contract. The `isProven()` read above is callable by anyone, but recording is gated to a single hardcoded owner, the operator allowlist is unused, and the asset registry is sealed at construction. It demonstrates the recording flow and does not accept third-party submissions. To query recorded state, call `isProven(bytes32 proofId, bytes32 txHash, uint32 txSeq)` at selector `0x8ce18c3f`. Do not call the auto-generated `provenProofs(bytes32)` getter with the bare proofId; that mapping is keyed by `keccak256(proofId, txHash, uint32 txSeq)`, so a raw proofId query returns false for proofs that are in fact recorded.

---

## Why This Matters for SWIFT, Blockchain, and RWA

| Scheme | Size | Security | SWIFT ISO 20022 |
|---|---|---|---|
| **XSOC-QSIG** | **30 B** | **Post-quantum, computational (HMAC-SHA256 PRF)** | **Fits today** |
| ECDSA | 64 B | Shor-broken (1,098 qubits, EUROCRYPT 2026) | Fits, but broken |
| Falcon-512 | 666 B | Computational PQ (NTRU) | Does not fit |
| Dilithium2 | 2,420 B | Computational PQ (M-LWE) | Does not fit |

EUROCRYPT 2026 (Chevignard, Fouque, Schrottenloher, March 15, 2026,
ePrint 2026/280): P-256 now breakable at 1,098 logical qubits, down
48% from prior estimate. XSOC-QSIG has zero ECC dependency.

---

## NIE Integration (v1.0.1)

XSOC-QSIG now integrates natively with the **Nexus Identity Engine
(NIE)**, XSOC's hardware-bound zero-install identity layer. When the
`nie` feature is enabled, a `NieSessionCtx` bridges a live NIE session
handle (from `POST /nie/v1/attest`) directly into the DSKAG-IT-SIG
signing context.

**What NIE adds to XSOC-QSIG:**

Standalone DSKAG-IT-SIG proves that a valid key was used to sign a
transaction under a specific compliance policy on specific hardware.
The NIE integration extends this to prove a strictly stronger set of
properties simultaneously:

- **Enrolled identity**, the signing device was enrolled by an
  authorized administrator through one of three hardware-ceremony
  paths (TPM co-sign, admin binary token, or FIDO2 offline ceremony).
  Ad-hoc key generation is architecturally impossible.
- **Live authenticated session**, the user presented a hardware-bound
  credential (biometric or PIN via Argon2id) at the time of signing,
  not at some prior point. The NIE attestation floor enforces minimum
  hardware tier per role.
- **Non-revoked at signing time**, NIE's three-channel revocation
  (in-process cache, Redis, Event Hubs) propagates globally in under
  30 seconds. A device revoked between enrollment and signing cannot
  produce a valid QSIG signature because the NIE session handle, which
  is the upstream input to the DSKAG key derivation, is invalidated.
- **ZK-provable attestation tier**, the NIE device fingerprint flows
  directly into the ZK Layer 3 `device_hash` private input. The
  UltraHonk proof therefore attests not just that hardware was present,
  but that it was a specific NIE-enrolled device at the claimed
  attestation tier (TPM, Platform, or Identity).
- **License binding through identity**, the NIE attestation floor
  maps to a `LicenseContribution` mixed into the FrameKey derivation.
  An invalid, expired, or revoked NIE session produces a zero
  LicenseContribution (the poison path), causing the ZK Layer 4
  assertion to fail on-chain, making unauthorized signing detectable
  without any XSOC infrastructure in the verification path.

The combined XSOC-QSIG + NIE system closes the gap between "a valid
cryptographic key was used" and "a valid, enrolled, authenticated,
non-revoked identity on a specific hardware tier signed this
transaction at this moment", all verifiable permissionlessly
on-chain through the existing ZK proof system with no changes to the
deployed Solidity contracts.

NIE requires a valid NIE deployment and XSOC commercial license.
Contact: licensing@xsoccorp.com

---

## This Release

This repository contains pre-compiled binary artifacts for production
deployment. **Source code is not included.** All DSKAG derivation
internals, wave modulation parameters, and circuit source are
proprietary trade secrets of XSOC Corp.

The XSOC-QSIG signer and verifier are delivered as native libraries for Linux, Windows, and macOS and as WASM bindings for browser and Node, exposing a stable API to produce and verify XSOC-QSIG signatures from an application. These bindings are available under commercial license and are not attached to public releases; contact XSOC Corp for access.

### Artifacts

| File | Description |
|---|---|
| `contracts/HonkVerifier.sol` | nargo-generated UltraHonk Solidity verifier |
| `contracts/XSOCZKVerifier.sol` | Permissionless ZK compliance verifier |
| `circuits/vk.bin` | UltraHonk verifying key (1.8 KB) |
| `docs/api/` | Rustdoc API reference |

### ZK Proof System

The four-layer UltraHonk circuit (no trusted setup) simultaneously proves:

1. **MAC validity**, HMAC-SHA256(K\_compliance, B) equals the claimed MAC
2. **Policy binding**, K\_compliance was derived from the claimed compliance domain
3. **Hardware binding**, signing occurred on hardware of the claimed tier
   (with NIE: the specific NIE-enrolled device at the claimed attestation tier)
4. **License binding**, a valid XSOC license token was active at signing time
   (with NIE: also that the NIE session was non-revoked and above the role floor)

Circuit stats: 143,802 gates · 16 KB proof · 77 KB Solidity verifier
Toolchain: Nargo 1.0.0-beta.3 · Barretenberg 0.82.2

---

## Platform Support

| Target | Status |
|---|---|
| Linux x86-64 | Production |
| Windows x86-64 (MSVC) | Production |
| macOS aarch64 (Apple Silicon) | Production |
| `thumbv7m-none-eabi` (ARM Cortex-M) | Build verified |
| `wasm32-unknown-unknown` | Build + wasm-pack verified |

---

## Independent Validation

| Institution | Scope | Result |
|---|---|---|
| University of Luxembourg | Full cryptanalysis | No attacks found. Entropy 7.998 bits/byte |
| Cal Poly San Luis Obispo | Dieharder statistical battery | 98.4% pass rate |
| George Mason University SENTINEL | Security audit FP5223 | All findings remediated |

---

## Licensing

**All use requires a valid written commercial license from XSOC Corp.**
Publication of this repository does not grant any license. See
[licenses/LICENSE.txt](licenses/LICENSE.txt) for full terms.

Evaluation licenses are available for qualified institutions.

**Contact:** licensing@xsoccorp.com
**Web:** https://www.xsoccorp.com
**CAGE Code:** 8ZXJ8 | **UEI:** G1R1NKS81NF5 | **ECCN:** 5D002.C1

---

## Export Control

ECCN 5D002.C1, License Exception ENC §740.17(a)(b)(2).
BIS export classification case number Z1691431.
Diversion contrary to U.S. law is prohibited.

---

*XSOC, DSKAG, DSKAG-IT-SIG, XSOC-QSIG, NexusKey, SP-VERSA, TrustLayer,
NIE, Nexus Identity Engine, and VoiceShield are trademarks of XSOC Corp.
All rights reserved.*

*© 2026 XSOC Corp. All Rights Reserved.*
