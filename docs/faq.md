# Frequently Asked Questions (FAQ)

## General

### What is Happy Zero?
Happy Zero is a Linux distribution based on Ubuntu 24.04 LTS, designed to look and feel like stock Ubuntu Desktop while having its own distinct branding.

### Is Happy Zero affiliated with Canonical?
No. Happy Zero is not affiliated with, endorsed by, or sponsored by Canonical Ltd. It is an independent, community-driven project.

### Why create Happy Zero?
To provide a clean Ubuntu-like experience with full control over branding and identity, while maintaining legal compliance with trademark policies.

### What base does it use?
Ubuntu 24.04 LTS "Noble Numbat".

### Which desktop environment?
GNOME 46 with Yaru theming.

### How long is support?
Until May 31, 2029, aligned with Ubuntu 24.04 LTS free support period.

## Installation

### What are the system requirements?
See [Install Guide (EN)](install-guide-en.md) for details. Minimum 4GB RAM, 25GB disk space.

### Can I dual-boot with Windows?
Yes, Calamares supports dual-boot installation alongside existing operating systems.

### Does it support Secure Boot?
Yes, it uses standard Ubuntu shim and signed kernels from Ubuntu repositories.

### Can I try it without installing?
Yes, boot the ISO in "Try Happy Zero without installing" mode (live environment).

## Technical

### Which installer does it use?
Calamares - a flexible, themable installer framework.

### How is it built?
Using debootstrap to bootstrap Ubuntu base, then customizing with HZ branding, packages, and Calamares configuration. Squashfs for live filesystem, xorriso for hybrid ISO.

### Can I build it myself?
Yes. See [Build Guide](build-guide.md) for instructions. Requires Linux environment.

### Does it include proprietary drivers?
The standard ISO includes `ubuntu-restricted-extras` and `ubuntu-drivers-common`. Proprietary GPU drivers (NVIDIA) can be installed via Welcome app or Additional Drivers.

### Does it use Snap or Flatpak?
Both are available. Firefox comes as Snap by default (matching Ubuntu). Flatpak is also installed and Flathub can be enabled via Welcome app.

## Legal

### Is this legally compliant?
Yes. Happy Zero removes all Ubuntu trademarks from branding and uses original assets. We follow Ubuntu's open source model while respecting trademark policy.

### Can I redistribute it?
Yes, under MIT license for code and respecting trademark guidelines. See [Trademark & License Notes](trademark-license.md).

### Can I use Happy Zero name/logo?
See trademark/license notes. Happy Zero name/logo are part of this project's identity.
