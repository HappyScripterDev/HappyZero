# Happy Zero Build Guide

**Warning:** Building requires a Linux environment (Ubuntu 22.04/24.04 or Debian-based) with root privileges. This guide is written for Linux systems only.

## Prerequisites

- 64-bit Linux system (Ubuntu 24.04 recommended)
- Minimum 25-35 GB free disk space
- Minimum 4 GB RAM (8 GB recommended)
- Stable internet connection for package downloads
- Root/sudo access

## Dependencies

Install required build tools:

```bash
sudo apt update
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

## Building the ISO

### 1. Clone the Repository

```bash
git clone https://github.com/happyzero/happy-zero.git
cd happy-zero
```

### 2. Build the ISO

```bash
sudo ./build/scripts/build-hz.sh
```

The build process will:
1. Bootstrap Ubuntu 24.04 (noble) base using debootstrap
2. Set up chroot environment
3. Install packages, desktop environment, and HZ branding
4. Install and configure Calamares installer with HZ branding
5. Create squashfs filesystem
6. Generate hybrid ISO (BIOS + UEFI)

Build time varies based on internet speed and hardware (typically 30-90 minutes).

### 3. Locate the ISO

When complete, the ISO will be located at:
```bash
out/happy-zero-1.0-noble-zero-amd64.iso
```

## Verification

### Calculate SHA256 Checksum

```bash
sha256sum out/happy-zero-1.0-noble-zero-amd64.iso > out/happy-zero-1.0-noble-zero-amd64.iso.sha256
```

### Verify Checksum

```bash
sha256sum -c out/happy-zero-1.0-noble-zero-amd64.iso.sha256
```

## Testing

### Test in QEMU/KVM (Headless/GUI)

```bash
# GUI testing
qemu-system-x86_64 \
  -enable-kvm \
  -m 4G \
  -cdrom out/happy-zero-1.0-noble-zero-amd64.iso \
  -boot d \
  -vga virtio

# Headless testing with VNC
qemu-system-x86_64 \
  -enable-kvm \
  -m 4G \
  -cdrom out/happy-zero-1.0-noble-zero-amd64.iso \
  -boot d \
  -vnc :0
```

### Test in VirtualBox

1. Create new VM (Linux, Ubuntu 64-bit)
2. Allocate minimum 4GB RAM, 25GB disk
3. Mount ISO as optical disk
4. Boot and test

## Writing to USB

**Warning:** This will erase all data on the target USB drive.

### Using `dd` (Linux/macOS)

```bash
# Find USB device (e.g., /dev/sdX, not /dev/sdX1)
lsblk

# Write ISO
sudo dd if=out/happy-zero-1.0-noble-zero-amd64.iso of=/dev/sdX bs=4M status=progress conv=fsync
sync
```

### Using Balena Etcher (Cross-platform)

1. Download [Balena Etcher](https://etcher.balena.io/)
2. Select ISO
3. Select target USB drive
4. Flash

## Troubleshooting

### Build Issues

| Issue | Solution |
|---|---|
| debootstrap fails | Check internet connection, mirror availability. Try different mirror in config. |
| Out of disk space | Ensure 35+ GB free in workspace location. Set `WORKSPACE_DIR` to larger disk if needed. |
| Permission errors | Ensure script is run with sudo/root. |
| Chroot mount failures | Check for existing mounts, run cleanup, retry. |

### Boot Issues

| Issue | Solution |
|---|---|
| ISO won't boot in VM | Enable virtualization (VT-x/AMD-V), check UEFI/BIOS settings. |
| Secure Boot issues | Disable Secure Boot temporarily or ensure using signed shim (should work with standard systems). |
| Black screen/Plymouth issues | Add `nomodeset` to kernel parameters in GRUB (for testing). |

## Customization

### Change Build Configuration

Edit `build/config/default-config.sh` or copy to `build/config/config.sh`. Key variables:
- `TARGET_NAME` - ISO filename
- `HZ_VERSION`, `HZ_CODENAME` - Version info
- `MIRROR` - Package mirror URL

### Add Custom Packages

Edit `packages/happy-zero-desktop-meta/debian/control` to add/remove dependencies.

### Modify Branding

- Logos: `branding/logos/`
- Wallpapers: `branding/wallpapers/` (add images)
- Settings: `settings/dconf/db/local.d/00-happyzero`

## Notes

- The build script uses a temporary workspace (default `/tmp/hz-workspace`) which is cleaned up on exit
- Building must be done on a native Linux system (not in WSL1; WSL2 may work with limitations)
- All package names are verified for Ubuntu 24.04 (noble) as per Phase 1 research

## Known Limitations

As stated in requirements: Cannot fully verify all runtime behavior without building and testing on actual hardware. The provided files and scripts are complete as specified.
