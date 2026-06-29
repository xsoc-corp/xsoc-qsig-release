# XSOC-QSIG Cryptanalytic Challenge and Security Program

**Total Prize Pool: 0.05 BTC (~$5,000 USD)**

XSOC Corp actively invites cryptanalytic scrutiny of the DSKAG-IT-SIG construction.
We believe security is proven through adversarial review, not obscurity.

## Published Research

**Paper:** DSKAG-IT-SIG v2.3 (April 2026)
**DOI:** https://doi.org/10.5281/zenodo.19639165
**17 pages. Complete game-based security proofs. CC BY-NC-ND 4.0.**

## Scope

### In Scope: Cryptographic Construction

| Target | Description |
|--------|-------------|
| Theorem 1 (IT-EUF) | Any attack producing a forgery with probability exceeding q * 2^-128 |
| Theorem 2 (IT-XUF) | Any attack violating cross-domain unforgeability |
| Property 1 | Any distinguisher contradicting Key Uniformity using the published interface |
| Property 2 | Any distinguisher contradicting Statistical Key Isolation using the published interface |
| NexusKey Policy Digest | Any collision, cross-field correlation, or policy bypass (Section 5) |
| ZK Proof System | Any attack producing a valid proof for an invalid statement |

### In Scope: Smart Contracts

Production stack, deployed on Ethereum Mainnet and Arbitrum One at identical
addresses (deterministic CREATE2):

| Contract | Address |
|----------|---------|
| XSOCSignerRegistry | `0xDA72bE646e2Ae09f45FE6f143Aa723a9eF651821` |
| HonkVerifier | `0xBD8fc43603B382B62FF02BB560f89f83bd54d337` |
| XSOCZKVerifier | `0x008DC9A25E09D18cceeef0ee507DE7419869f041` |

See `deployments.json` for deployment transactions, the linked `RelationsLib`
library, and the prior deprecated stacks.

### Out of Scope

- The internal DSKAG wave engine implementation (proprietary, not published, not accessible)
- SP-VERSA cipher and wave modulation parameters (proprietary trade secrets)
- Social engineering, phishing, or physical attacks
- Denial of service against testnet deployments
- Findings already documented in the paper or in prior academic validations

## Rewards

All rewards paid in Bitcoin to a wallet address provided by the researcher.

### Critical: Construction Break (0.025 BTC / ~$2,500)

A demonstrated forgery, key recovery, or distinguisher that invalidates
Theorem 1 or Theorem 2 as stated in the published paper.

**Bonus:** Named acknowledgment in all future versions of the paper.
Co-authorship invitation on the disclosure publication.

### Significant: Property Violation (0.015 BTC / ~$1,500)

A demonstrated violation of Properties 1-4 using only the published
interface and publicly available artifacts from this repository.

**Bonus:** Named acknowledgment in all future versions of the paper.

### Moderate: Smart Contract or ZK Circuit (0.01 BTC / ~$1,000)

A vulnerability in the deployed Solidity contracts or Noir circuits that
could produce incorrect verification results, bypass policy enforcement,
or enable unauthorized proof acceptance.

**Bonus:** Named acknowledgment.

### Informational: Proof Gaps (No monetary reward)

Logical gaps in the published proofs, missing assumptions, or strengthened
attack models that do not constitute a break but improve the paper.

**Reward:** Named acknowledgment. Letter of recommendation for academic
researchers upon request.

## Rules

1. Report findings to **security@xsoccorp.com**
2. Include a clear, reproducible description with sufficient detail for independent verification
3. One finding per report
4. First reporter of a unique finding receives the reward
5. Allow 90 days for remediation before public disclosure
6. Researchers may publish findings after the 90-day window or upon remediation, whichever is earlier
7. XSOC Corp will not pursue legal action against researchers acting in good faith under this program
8. Findings on the published construction (DOI: 10.5281/zenodo.19457812) and the artifacts in this repository are explicitly authorized for security research under CC BY-NC-ND 4.0

## Prior Validations

Three independent academic institutions have reviewed this construction:

| Institution | Engagement | Result |
|-------------|-----------|--------|
| University of Luxembourg | Cryptanalytic review (Biryukov/Perrin), 2020 | No structural attacks found. Entropy 7.998 bits/byte. |
| Cal Poly San Luis Obispo | Dieharder statistical battery | 440+ tests. 98.4% pass rate. NIST SP 800-22 and AIS-31. |
| George Mason University SENTINEL | Security audit FP5223, Dec 2025 | Two findings remediated. Audit signed off. |

## Resolved Findings

Construction-tier theorems and properties remain unbroken. The findings processed
under the program are smart-contract and reference-crate hardening. The most recent
batch, fixed and live in the production stack above:

| Finding | Component | Status |
|---------|-----------|--------|
| SMT20 | Registry root rotation | Fixed. Rotation is append-only; a prior root cannot be reinstated, so revocation by rotation is irreversible. |
| SMT21 | Registry ownership | Fixed. Two-step ownership; the recipient must accept before it takes effect. |
| SMT22 | Wrapper proof identity | Fixed. proofId binds the registry root and hardware tier; root-aware isProvenAt and isProvenUnderCurrentRoot added. |
| SMT23 | xsoc-tss-core commitment | Fixed in v0.1.1. Malformed opening bytes return a typed error instead of panicking. |

Earlier findings were triaged and closed prior to this batch.

## Contact

- **Security reports:** security@xsoccorp.com
- **General inquiries:** rblech@xsoccorp.com
- **Web:** www.xsoccorp.com

CAGE Code 8ZXJ8 | UEI G1R1NKS81NF5 | ECCN 5D002.C1
