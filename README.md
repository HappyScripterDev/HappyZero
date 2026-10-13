# Happy Zero (HZ) Linux Distribution

Happy Zero is a derivative of Ubuntu 24.04 LTS built to look and feel like stock Ubuntu Desktop (GNOME 46 with Yaru styling) while establishing its own distinct identity.

## Overview

- **Name:** Happy Zero (HZ)
- **Version:** 1.0 "Noble Zero"
- **Base:** Ubuntu 24.04 LTS (Noble Numbat)
- **Desktop:** GNOME 46
- **Architecture:** amd64 (x86_64)
- **Installer:** Calamares
- **License:** MIT (see LICENSE)
- **Support:** Until May 31, 2029 (aligned with Ubuntu LTS)

## Features

- Stock Ubuntu Desktop experience with left dock and Activities overview
- Clean, modern branding with unique teal accent color
- Reproducible build pipeline using debootstrap
- Complete legal compliance with Ubuntu trademark policy
- English and German language support
- Security-first defaults (UFW, AppArmor, automatic updates)

## Documentation

- [Phase 1 Research](docs/research/phase1-research.md)
- [Phase 2 Design](docs/design/phase2-design.md)
- Build Guide (coming in Phase 3)
- Install Guide (English & German - coming in Phase 3)

## Building

**Note:** Building requires a Linux environment (Ubuntu/Debian) with root privileges. Building on Windows is not supported.

```bash
# Clone repository
git clone https://github.com/happyzero/happy-zero.git
cd happy-zero

# Install dependencies
sudo apt install debootstrap squashfs-tools xorriso mtools grub-pc-bin grub-efi-amd64-bin

# Build ISO (requires sudo)
sudo ./build/scripts/build-hz.sh
```

The resulting ISO will be in `out/`.

## License & Legal

Happy Zero is open source software. See [LICENSE](LICENSE) for details.

**Trademark Notice:** "Ubuntu" is a registered trademark of Canonical Ltd. Happy Zero is not affiliated with, endorsed by, or sponsored by Canonical Ltd. Happy Zero is a completely separate distribution with its own branding.

## Contributing

See [CONTRIBUTING.md](docs/contributing.md) (to be created in Phase 3).

## Limitations

As noted in the research, full ISO build and runtime verification must be performed on actual Linux hardware/VM (QEMU/KVM). This repository provides complete source files and build scripts as specified.
