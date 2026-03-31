# Security Policy

## Reporting a Vulnerability

XSOC Corp takes security disclosures seriously. If you believe you have
found a security vulnerability in XSOC-QSIG, the deployed smart
contracts, or any associated cryptographic construction, please report
it responsibly.

**Do not open a public GitHub issue for security vulnerabilities.**

Contact: security@xsoccorp.com

Please include:
- Description of the vulnerability
- Steps to reproduce or proof of concept
- Affected components and versions
- Your assessment of the severity

We will acknowledge receipt within 48 hours and provide a timeline for
remediation. We do not currently operate a public bug bounty program,
but we will acknowledge researchers in any public disclosure with their
consent.

## Scope

In scope:
- XSOCPolicyOracle.sol (deployed: 0xAe3c62aE19b8406468b80cb9353046eE5f536c44)
- XSOCZKVerifier.sol
- HonkVerifier.sol
- Published binary artifacts in this repository
- The DSKAG-IT-SIG cryptographic construction as described in
  associated publications

Out of scope:
- DSKAG internal implementation (source not published)
- SP-VERSA cipher internals (source not published)
- Wave modulation parameters (not published)

## Cryptographic Claims

The 2⁻¹²⁸ unconditional forgery bound for DSKAG-IT-SIG is a
mathematical claim, not a software security claim. Vulnerabilities in
the mathematical construction should be reported to
security@xsoccorp.com with full technical detail and will be reviewed
by our cryptographic team and submitted to independent academic review.

Three institutions have independently reviewed the DSKAG construction:
University of Luxembourg, Cal Poly Pomona (Dieharder), and George Mason
University SENTINEL (FP5223). No structural attacks have been found.
