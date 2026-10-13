#!/usr/bin/env bash
set -euo pipefail

# Happy Zero (HZ) Build Script
# Based on debootstrap + mksquashfs + xorriso + Calamares
# Target: Ubuntu 24.04 LTS (Noble Numbat)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="${WORKSPACE_DIR:-/tmp/hz-workspace}"
CHROOT_DIR="${WORKSPACE_DIR}/chroot"
IMAGE_DIR="${WORKSPACE_DIR}/image"
ISO_DIR="${WORKSPACE_DIR}/iso"
OUTPUT_DIR="${OUTPUT_DIR:-$(pwd)/out}"

# Configuration
HZ_VERSION="1.0"
HZ_CODENAME="noble-zero"
UBUNTU_CODENAME="noble"
ARCH="amd64"
MIRROR="http://archive.ubuntu.com/ubuntu"
ISO_NAME="happy-zero-${HZ_VERSION}-${HZ_CODENAME}-${ARCH}.iso"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[HZ-BUILD]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[HZ-WARN]${NC} $1"
}

error() {
    echo -e "${RED}[HZ-ERROR]${NC} $1" >&2
    exit 1
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root (sudo)"
    fi
}

check_dependencies() {
    log "Checking build dependencies..."
    local deps=("debootstrap" "squashfs-tools" "xorriso" "mtools" "syslinux-utils" "isolinux" "grub-pc-bin" "grub-efi-amd64-bin" "shim-signed")
    for dep in "${deps[@]}"; do
        if ! dpkg -l | grep -q "^ii\s*$dep"; then
            warn "$dep not installed. Install with: apt install $dep"
        fi
    done
}

setup_workspace() {
    log "Setting up workspace: ${WORKSPACE_DIR}"
    rm -rf "${WORKSPACE_DIR}"
    mkdir -p "${WORKSPACE_DIR}" "${CHROOT_DIR}" "${IMAGE_DIR}" "${ISO_DIR}" "${OUTPUT_DIR}"
}

bootstrap_base() {
    log "Bootstrapping Ubuntu ${UBUNTU_CODENAME} base (${ARCH})..."
    debootstrap --arch="${ARCH}" --variant=minbase "${UBUNTU_CODENAME}" "${CHROOT_DIR}" "${MIRROR}"
}

mount_chroot() {
    log "Mounting chroot filesystems..."
    mount --bind /dev "${CHROOT_DIR}/dev"
    mount --bind /run "${CHROOT_DIR}/run"
    mount -t proc proc "${CHROOT_DIR}/proc"
    mount -t sysfs sysfs "${CHROOT_DIR}/sys"
    mount -t devpts devpts "${CHROOT_DIR}/dev/pts"
}

umount_chroot() {
    log "Unmounting chroot filesystems..."
    umount -l "${CHROOT_DIR}/dev/pts" || true
    umount -l "${CHROOT_DIR}/sys" || true
    umount -l "${CHROOT_DIR}/proc" || true
    umount -l "${CHROOT_DIR}/run" || true
    umount -l "${CHROOT_DIR}/dev" || true
}

cleanup() {
    umount_chroot || true
    rm -rf "${WORKSPACE_DIR}" || true
}

# Trap cleanup on exit
trap cleanup EXIT INT TERM

main() {
    log "Happy Zero Build Script"
    log "Version: ${HZ_VERSION} (${HZ_CODENAME})"
    log "Base: Ubuntu ${UBUNTU_CODENAME} LTS"
    
    check_root
    check_dependencies
    setup_workspace
    bootstrap_base
    mount_chroot
    
    # Copy build configuration into chroot
    cp "${SCRIPT_DIR}/chroot-setup.sh" "${CHROOT_DIR}/tmp/chroot-setup.sh" 2>/dev/null || true
    
    # Execute chroot setup if available
    if [[ -f "${SCRIPT_DIR}/chroot-setup.sh" ]]; then
        chmod +x "${SCRIPT_DIR}/chroot-setup.sh"
        chroot "${CHROOT_DIR}" /tmp/chroot-setup.sh
    fi
    
    umount_chroot
    
    log "Build preparation complete. Further steps to be implemented in Phase 3."
    log "Chroot ready at: ${CHROOT_DIR}"
}

main "$@"
