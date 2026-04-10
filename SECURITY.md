# XSOC-QSIG Cryptanalytic Challenge and Security Program

**Total Prize Pool: 0.05 BTC (~$5,000 USD)**

XSOC Corp actively invites cryptanalytic scrutiny of the DSKAG-IT-SIG construction.
We believe security is proven through adversarial review, not obscurity.

## Published Research

**Paper:** DSKAG-IT-SIG v2.2 (April 2026)
**DOI:** [10.5281/zenodo.19457812](https://doi.org/10.5281/zenodo.19457812)
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

| Contract | Network | Address |
|----------|---------|---------|
| XSOCPolicyOracle | Ethereum Sepolia | `0xAe3c62aE19b8406468b80cb9353046eE5f536c44` |
| HonkVerifier | Arbitrum Sepolia | `0xAe3c62aE19b8406468b80cb9353046eE5f536c44` |
| XSOCZKVerifier | Arbitrum Sepolia | `0xaAC4c8a563FbD424CF8e1f1F70343833447A45db` |

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

## Contact

- **Security reports:** security@xsoccorp.com
- **General inquiries:** rblech@xsoccorp.com
- **Web:** www.xsoccorp.com

CAGE Code 8ZXJ8 | UEI G1R1NKS81NF5 | ECCN 5D002.C1
