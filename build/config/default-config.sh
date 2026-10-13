#!/usr/bin/env bash
# Happy Zero Build Configuration

export CONFIG_FILE_VERSION="1.0"

# Target Ubuntu version
export TARGET_UBUNTU_VERSION="noble"
export TARGET_UBUNTU_MIRROR="http://archive.ubuntu.com/ubuntu/"

# Kernel package
export TARGET_KERNEL_PACKAGE="linux-generic"

# Build naming
export TARGET_NAME="happy-zero-1.0-noble-zero"
export GRUB_LIVEBOOT_LABEL="Try Happy Zero without installing"
export GRUB_INSTALL_LABEL="Install Happy Zero"

# Packages to remove after installation
export TARGET_PACKAGE_REMOVE="
    calamares
    casper
    lupin-casper
    discover
    laptop-detect
    os-prober
"

# HZ-specific packages to install in chroot
export HZ_PACKAGES="
    happy-zero-branding
    happy-zero-settings
    happy-zero-desktop-meta
"
