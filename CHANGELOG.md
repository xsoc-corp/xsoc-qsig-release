# Changelog

## v1.1.0 — 2026-05-13

### Added
- Production mainnet deployment on Ethereum Mainnet (Chain ID 1) and Arbitrum One (Chain ID 42161).
- `deployments.json` — machine-readable deployment manifest for integrators (mainnet + testnet contract addresses, transaction hashes, compiler settings, references).
- `README.md` — `Production Deployments` section documenting all four mainnet contracts with Etherscan and Arbiscan links.

### Mainnet contract addresses

| Network | Contract | Address |
|---|---|---|
| Ethereum Mainnet | HonkVerifier | `0x0B7dDF8AE4B403Cc737C4843E0C567C91976fa66` |
| Ethereum Mainnet | XSOCZKVerifier | `0xE405a52fcecB82085FEC04F40834237C0741b3B4` |
| Arbitrum One | HonkVerifier | `0x0B7dDF8AE4B403Cc737C4843E0C567C91976fa66` |
| Arbitrum One | XSOCZKVerifier | `0xE405a52fcecB82085FEC04F40834237C0741b3B4` |

Compiler: Solc 0.8.27, optimizer enabled at runs=1, EVM version `cancun`.
Deployer: `0x101eF283CAb956EDEf54745b89272E1B8f2B7EA6` (deterministic across chains via matched nonce).
All four contracts are source-verified on Etherscan and Arbiscan.

### Notes

- No changes to the protocol crate, Noir circuits, or verifier source. Existing integrators continue to work without modification.
- Testnet deployments on Ethereum Sepolia and Arbitrum Sepolia remain operational for development and integration testing.
- Both `submitProof()` and `isProven()` on mainnet are permissionlessly callable by any address; the UltraHonk proof is the sole authorization.
- See `deployments.json` for the canonical machine-readable manifest including deployment transaction hashes and explorer URLs.

---

## v1.0.1 — 2026-04-02

Initial public release. Pre-compiled artifacts, Solidity verifier source, UltraHonk verifying key, and Noir circuit source.
