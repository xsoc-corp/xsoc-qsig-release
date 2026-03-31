# XSOC-QSIG — Transaction Signature SDK

**Unconditionally Secure. Policy-Fused. Hardware-Bound. 30 Bytes.**

XSOC-QSIG (DSKAG-IT-SIG) is the only production-deployed transaction
signature scheme that simultaneously achieves:

- **IT-secure signatures** — 2⁻¹²⁸ forgery bound, unconditional, holds
  against any adversary including unbounded quantum computers
- **30-byte wire format** — fits every existing ISO 20022 SWIFT field
  today without re-engineering the message layer
- **NexusKey policy fusion** — compliance domain (asset class,
  jurisdiction, KYC level, transaction type) is fused into the signing
  key at the derivation layer, not asserted in application code
- **Hardware binding** — three tiers (TPM, Platform, Identity); keys
  are never stored or transmitted
- **Permissionless ZK verification** — any party on any EVM-compatible
  chain can verify all four compliance properties of a signature with
  no oracle and no XSOC Corp involvement

---

## Live On-Chain Deployment

**XSOCPolicyOracle — Ethereum Sepolia**
```
0xAe3c62aE19b8406468b80cb9353046eE5f536c44
```
https://sepolia.etherscan.io/address/0xAe3c62aE19b8406468b80cb9353046eE5f536c44#events

The contract has been live since block **10,531,115** (March 26, 2026).
`PolicyVerified` events are permanently recorded on-chain. The
`isProven()` function is callable by any address with no authorization.

---

## Why This Matters for SWIFT, Blockchain, and RWA

| Scheme | Size | Security | SWIFT ISO 20022 |
|---|---|---|---|
| **XSOC-QSIG** | **30 B** | **IT-secure, unconditional** | **Fits today** |
| ECDSA | 64 B | Shor-broken (1,098 qubits, EUROCRYPT 2026) | Fits — but broken |
| Falcon-512 | 666 B | Computational PQ (NTRU) | Does not fit |
| Dilithium2 | 2,420 B | Computational PQ (M-LWE) | Does not fit |

EUROCRYPT 2026 (Chevignard, Fouque, Schrottenloher — March 15, 2026,
ePrint 2026/280): P-256 now breakable at 1,098 logical qubits, down
48% from prior estimate. XSOC-QSIG has zero ECC dependency.
The 2⁻¹²⁸ bound is unaffected.

---

## This Release

This repository contains pre-compiled binary artifacts for production
deployment. **Source code is not included.** All DSKAG derivation
internals, wave modulation parameters, and circuit source are
proprietary trade secrets of XSOC Corp.

### Artifacts

| File | Description |
|---|---|
| `xsoc-sig-*-linux-amd64.tar.gz` | Linux x86-64 static + shared library |
| `xsoc-sig-*-windows-msvc.zip` | Windows x86-64 .lib + .dll |
| `xsoc-sig-*-macos-aarch64.tar.gz` | macOS Apple Silicon .a + .dylib |
| `xsoc-sig-wasm-*.tar.gz` | WASM browser bindings (.wasm, .js, .d.ts) |
| `contracts/HonkVerifier.sol` | nargo-generated UltraHonk Solidity verifier |
| `contracts/XSOCZKVerifier.sol` | Permissionless ZK compliance verifier |
| `circuits/vk.bin` | UltraHonk verifying key (1.8 KB) |
| `docs/api/` | Rustdoc API reference |

### ZK Proof System

The four-layer UltraHonk circuit (no trusted setup) simultaneously proves:

1. **MAC validity** — HMAC-SHA256(K\_compliance, B) equals the claimed MAC
2. **Policy binding** — K\_compliance was derived from the claimed compliance domain
3. **Hardware binding** — signing occurred on hardware of the claimed tier
4. **License binding** — a valid XSOC license token was active at signing time

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
| Cal Poly Pomona | Dieharder statistical battery | 98.4% pass rate |
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
and VoiceShield are trademarks of XSOC Corp. All rights reserved.*

*© 2026 XSOC Corp. All Rights Reserved.*
