#!/usr/bin/env bash
set -euo pipefail

# Happy Zero Chroot Setup Script
# Runs inside chroot environment

export DEBIAN_FRONTEND=noninteractive

log() {
    echo "[HZ-CHROOT] $1"
}

# Configure APT sources
log "Configuring APT sources..."
cat > /etc/apt/sources.list << 'EOF'
deb http://archive.ubuntu.com/ubuntu noble main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu noble-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu noble-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu noble-backports main restricted universe multiverse
EOF

# Update package lists
log "Updating APT..."
apt-get update

# Install base system packages
log "Installing base packages..."
apt-get install -y \
    ubuntu-minimal \
    ubuntu-standard \
    casper \
    lupin-casper \
    discover \
    laptop-detect \
    os-prober \
    network-manager \
    net-tools \
    wireless-tools \
    wpagui \
    locales \
    binutils \
    curl \
    wget

# Install kernel
log "Installing kernel..."
apt-get install -y --no-install-recommends linux-generic

# Install GNOME desktop (minimal core)
log "Installing GNOME desktop..."
apt-get install -y \
    plymouth \
    plymouth-themes \
    ubuntu-desktop-minimal \
    gdm3

# Install Calamares installer
log "Installing Calamares..."
apt-get install -y calamares calamares-settings-debian

# Clean up
log "Cleaning up..."
apt-get autoremove -y
apt-get clean -y

log "Chroot setup complete."
