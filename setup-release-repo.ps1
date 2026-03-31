# Setup script for xsoc-corp/xsoc-qsig-release public repo
# Run from C:\Projects\xsoc-sig
# Requires: gh CLI authenticated, contracts already in xsoc-sig-zkp\contracts

Set-Location "C:\Projects"

# 1. Create the public release repo
Write-Host "Creating public release repository..." -ForegroundColor Yellow
gh repo create xsoc-corp/xsoc-qsig-release `
    --public `
    --description "XSOC-QSIG (DSKAG-IT-SIG) Transaction Signature SDK — Pre-compiled artifacts and on-chain verifier contracts" `
    --homepage "https://www.xsoccorp.com"

# 2. Clone it locally
git clone https://github.com/xsoc-corp/xsoc-qsig-release
Set-Location "C:\Projects\xsoc-qsig-release"

# 3. Create directory structure
New-Item -ItemType Directory -Force -Path contracts
New-Item -ItemType Directory -Force -Path circuits
New-Item -ItemType Directory -Force -Path licenses
New-Item -ItemType Directory -Force -Path docs

# 4. Copy contracts (already public on Sepolia)
Copy-Item "C:\Projects\xsoc-sig\xsoc-sig-zkp\contracts\HonkVerifier.sol" contracts\
Copy-Item "C:\Projects\xsoc-sig\xsoc-sig-zkp\contracts\XSOCZKVerifier.sol" contracts\

# 5. Copy verifying key
Copy-Item "C:\Projects\xsoc-sig\xsoc-sig-zkp\circuits\target\vk.bin" circuits\ -ErrorAction SilentlyContinue
if (-not (Test-Path "circuits\vk.bin")) {
    Write-Host "vk.bin not found -- run 'bb write_vk' in WSL first" -ForegroundColor Yellow
    # Create placeholder
    "Verifying key generated from XSOC-QSIG UltraHonk circuit. Contact licensing@xsoccorp.com for full artifact package." | Set-Content "circuits\vk.README"
}

# 6. Copy README, LICENSE, SECURITY from the release package
# (these are the files prepared by XSOC -- paste them in manually or copy from outputs)
Write-Host "Place README.md, licenses\LICENSE.txt, and SECURITY.md in C:\Projects\xsoc-qsig-release" -ForegroundColor Yellow
Write-Host "Then run the git commands below" -ForegroundColor Yellow

# 7. Create .gitignore -- ensure nothing proprietary can accidentally be committed
@'
# Never commit source code to this repo
*.rs
Cargo.toml
Cargo.lock
*.toml
src/
target/
.env
*.key
*.pem
# Build artifacts that are not release artifacts
*.d
*.rlib
*.rmeta
'@ | Set-Content .gitignore

Write-Host ""
Write-Host "Once files are in place, run:" -ForegroundColor Cyan
Write-Host "  git add ." -ForegroundColor White
Write-Host "  git commit -m 'Initial public release: XSOC-QSIG v1.0.0'" -ForegroundColor White
Write-Host "  git tag v1.0.0" -ForegroundColor White
Write-Host "  git push origin main --tags" -ForegroundColor White
Write-Host ""
Write-Host "Then create the GitHub Release:" -ForegroundColor Cyan
Write-Host "  gh release create v1.0.0 --title 'XSOC-QSIG v1.0.0' --notes-file RELEASE_NOTES.md" -ForegroundColor White
