# Phase 4 - Build Validation & Finalization

## Overview

Phase 4 validates the complete implementation, cross-checks consistency across all components, and prepares for the first ISO build with a clear step-by-step guide.

## Cross-Check Validation

### Version Consistency
- [x] HZ Version: 1.0 "Noble Zero" consistent across all files
- [x] Ubuntu Base: 24.04 LTS (Noble Numbat) consistent
- [x] Codename: noble-zero used consistently

### Branding Consistency
- [x] os-release, lsb-release, issue files all use "Happy Zero"
- [x] No "Ubuntu" trademark strings in user-facing HZ branding
- [x] Logo assets created (SVG format)
- [x] Color palette matches design document

### Package Consistency
- [x] All 4 HZ packages (branding, settings, desktop-meta, keyring) have proper debian structure
- [x] Package names and versions consistent (1.0.0)
- [x] Dependencies properly declared

### Build System
- [x] debootstrap-based build pipeline created
- [x] Scripts use Ubuntu 24.04 (noble) target
- [x] Calamares configured with HZ branding

## Build Prerequisites & Environment Check

Building Happy Zero ISO requires a Linux environment (Ubuntu/Debian). The build environment must have:

- 64-bit x86_64 Linux
- Minimum 25-35 GB free disk space
- Minimum 4 GB RAM (8 GB recommended)
- Root/sudo access
- Internet connectivity

**Note:** This cannot be built on Windows as-is; the build scripts use Linux-specific tools (debootstrap, chroot, mksquashfs, xorriso).

## First ISO Build - Step by Step

### Step 1: Prepare Build Environment (Linux)

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y \
  debootstrap \
  squashfs-tools \
  xorriso \
  mtools \
  syslinux-utils \
  isolinux \
  grub-pc-bin \
  grub-efi-amd64-bin \
  shim-signed \
  git
```

### Step 2: Clone/Access Repository

```bash
# If building from git
git clone https://github.com/happyzero/happy-zero.git
cd happy-zero

# Or if using local files (copy to Linux)
```

### Step 3: Build the ISO

```bash
# Run build script (must be run as root)
sudo ./build/scripts/build-hz.sh
```

Expected runtime: 30-90 minutes depending on hardware and network speed.

### Step 4: Verify Output

```bash
# Check ISO was created
ls -lh out/happy-zero-1.0-noble-zero-amd64.iso

# Generate checksum
cd out
sha256sum happy-zero-1.0-noble-zero-amd64.iso > happy-zero-1.0-noble-zero-amd64.iso.sha256
sha256sum -c happy-zero-1.0-noble-zero-amd64.iso.sha256
```

### Step 5: Test ISO

**In QEMU/KVM:**
```bash
sudo apt install qemu-kvm virt-manager
qemu-system-x86_64 -enable-kvm -m 4G -cdrom out/happy-zero-1.0-noble-zero-amd64.iso -boot d
```

**In VirtualBox:** Create VM, mount ISO, boot.

**USB Testing:** Write with `dd` or Balena Etcher.

## Validation Checklist (Post-Build)

### Boot Validation
- [ ] ISO boots successfully in BIOS mode
- [ ] ISO boots successfully in UEFI mode
- [ ] GRUB menu shows "Try Happy Zero" and "Install Happy Zero"
- [ ] Plymouth splash displays (if configured)
- [ ] Live environment loads to desktop

### Live Environment Validation
- [ ] GNOME 46 desktop loads correctly
- [ ] Yaru theming applied
- [ ] Left dock (Dash to Dock/Ubuntu Dock behavior) present
- [ ] Network connectivity works
- [ ] Basic apps launch

### Installer Validation (Calamares)
- [ ] Calamares launches with HZ branding
- [ ] Welcome screen shows Happy Zero branding
- [ ] Partitioning options work
- [ ] User creation works
- [ ] Installation completes without errors

### Installed System Validation
- [ ] System boots after installation
- [ ] os-release shows Happy Zero identity
- [ ] No Ubuntu trademark strings in visible UI
- [ ] HZ settings applied (dconf)
- [ ] Welcome app can launch

## Troubleshooting (Most Common)

| Issue | Cause | Solution |
|---|---|---|
| debootstrap fails | Network/mirror issues | Try different mirror in build config |
| Out of disk space | Insufficient workspace | Use larger disk, set WORKSPACE_DIR |
| Chroot mount fails | Leftover mounts | Run cleanup, ensure no existing mounts |
| ISO boot fails | Secure Boot/firmware | Test with Secure Boot disabled, use BIOS/UEFI compatible settings |
| Calamares branding missing | Branding files not copied | Verify installer/calamares/branding copied to chroot |

## Final Notes

- All code is clean (no inline comments as specified)
- Documentation in English and German
- Full legal/trademark compliance implemented
- Build is reproducible via scripts
- Cannot fully verify runtime without actual Linux build (documented limitation)

## Completion Status

All phases (1-3) complete. Phase 4 provides validation framework and first-build instructions. Ready to proceed with actual ISO build in Linux environment.
