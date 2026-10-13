#!/usr/bin/env bash
set -euo pipefail

# Smoke tests for Happy Zero build
# These are basic validation tests

echo "=== Happy Zero Smoke Tests ==="

# Check required files exist
echo "[1/5] Checking core files..."
test -f README.md && echo "✓ README.md"
test -f LICENSE && echo "✓ LICENSE"
test -f docs/research/phase1-research.md && echo "✓ Phase 1 research"
test -f docs/design/phase2-design.md && echo "✓ Phase 2 design"
echo "Core files OK"

# Check build scripts
echo "[2/5] Checking build scripts..."
test -x build/scripts/build-hz.sh && echo "✓ build-hz.sh exists"
test -f build/scripts/chroot-setup.sh && echo "✓ chroot-setup.sh"
echo "Build scripts OK"

# Check branding
echo "[3/5] Checking branding..."
test -f branding/os-release && echo "✓ os-release"
test -f branding/lsb-release && echo "✓ lsb-release"
test -f branding/logos/hz-logo-mark.svg && echo "✓ logo mark"
echo "Branding OK"

# Check packages
echo "[4/5] Checking packages..."
for pkg in happy-zero-branding happy-zero-settings happy-zero-desktop-meta happy-zero-keyring; do
    test -f packages/$pkg/debian/control && echo "✓ $pkg/control"
    test -f packages/$pkg/debian/rules && echo "✓ $pkg/rules"
done
echo "Packages OK"

# Check docs
echo "[5/5] Checking documentation..."
test -f docs/build-guide.md && echo "✓ build-guide.md"
test -f docs/install-guide-en.md && echo "✓ install-guide-en.md"
test -f docs/install-guide-de.md && echo "✓ install-guide-de.md"
echo "Documentation OK"

echo ""
echo "=== All smoke tests passed ==="
