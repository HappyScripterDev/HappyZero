# Phase 2 - Design Document: Happy Zero (HZ)

**Project:** Happy Zero Linux Distribution  
**Base:** Ubuntu 24.04 LTS (Noble Numbat)  
**Versioning Scheme:** HZ 1.0 "Noble Zero"  
**Target Architecture:** amd64 (x86_64)  
**Build System:** debootstrap + mksquashfs + xorriso + Calamares  
**Date:** Mon Oct 12 2026

---

## 1. Overview

Happy Zero is a derivative of Ubuntu 24.04 LTS designed to look and feel like stock Ubuntu Desktop (GNOME 46 with Yaru styling, left dock, Activities overview) while establishing its own distinct identity through branding, accent colors, and curated defaults. All components are open source and legally redistributable with full trademark compliance.

### Core Principles
- Stock Ubuntu Desktop UX - minimal deviation from familiar workflow
- Complete rebranding with no Ubuntu trademark usage
- Reproducible build pipeline
- Legal compliance with Ubuntu trademark policy
- Accessibility and localization (English, German minimum)
- Security-first defaults

---

## 2. Name, Tagline, Brand Identity

### Name
**Happy Zero** (abbreviated **HZ**)

### Tagline
*"Simple. Secure. Yours."*

### Philosophy
Clean, approachable, professional. Distinct identity while honoring the Ubuntu desktop experience.

---

## 3. Color Palette

Designed to provide a fresh identity while remaining harmonious with GNOME/Yaru design language.

| Purpose | Color Name | HEX Code | RGB | Usage |
|---|---|---|---|---|
| Primary | HZ Teal | `#1A9C89` | 26, 156, 137 | Primary actions, accents, highlights |
| Primary Dark | HZ Teal Dark | `#147A6B` | 20, 122, 107 | Hover/active states |
| Accent | HZ Cyan | `#22D3EE` | 34, 211, 238 | Focus rings, selections |
| Light Background | Surface Light | `#F8F9FA` | 248, 249, 250 | Light theme backgrounds |
| Light Card | Card Light | `#FFFFFF` | 255, 255, 255 | Cards, panels |
| Dark Background | Surface Dark | `#1E1E1E` | 30, 30, 30 | Dark theme backgrounds |
| Dark Card | Card Dark | `#2D2D2D` | 45, 45, 45 | Dark theme cards/panels |
| Text Primary Light | Text Light | `#1F1F1F` | 31, 31, 31 | Text on light |
| Text Secondary Light | Text Light Secondary | `#5F6368` | 95, 99, 104 | Secondary text on light |
| Text Primary Dark | Text Dark | `#F1F3F4` | 241, 243, 244 | Text on dark |
| Text Secondary Dark | Text Dark Secondary | `#9AA0A6` | 154, 160, 166 | Secondary text on dark |
| Success | Green | `#3FB950` | 63, 185, 80 | Success states |
| Warning | Amber | `#D29922` | 210, 153, 34 | Warnings |
| Error | Red | `#F85149` | 248, 81, 73 | Errors |

**Accent Color Rationale:** Teal/cyan provides a distinct identity from Ubuntu's orange/purple Yaru accents while remaining visually harmonious.

---

## 4. Logo Concept & Assets

### Logo Design Principles
- Minimal, geometric mark
- Represents "zero" / clean slate concept
- Works at small sizes (16x16) and large (256x256+)
- SVG format for scalability
- Monochrome variants for flexibility

### Concept Description
The HZ logo combines:
1. A rounded square/block representing stability
2. A "0" or circular element representing "Zero"
3. A subtle upward arrow/peak suggesting positivity/growth ("Happy")
4. Clean geometric forms aligned with modern GNOME aesthetics

### Asset Specifications
| Asset | Format | Sizes | Purpose |
|---|---|---|---|
| Logo Mark | SVG, PNG | 16, 32, 48, 64, 128, 256 | App icons, system tray, branding |
| Wordmark "Happy Zero" | SVG, PNG | Various | Installer, GRUB, About pages |
| Logomark + Wordmark | SVG, PNG | Various | Combined branding |
| Monochrome variants | SVG, PNG | Various | High contrast, inverted use |
| Favicon | PNG | 16, 32, 48 | Web/docs |

All logo assets will be created as clean SVGs in `branding/logos/` with corresponding optimized PNGs.

---

## 5. Visual Assets

### Wallpapers
- **Default Light:** Minimal geometric pattern with subtle teal accent gradients on light background
- **Default Dark:** Subtle geometric pattern with teal accents on dark background
- **Alternative variants:** Clean solid color variants (matching palette)
- Format: 4K (3840x2160), 1440p (2560x1440), 1080p (1920x1080), also 16:10 variants
- Location: `branding/wallpapers/`

### Plymouth Boot Splash
- Minimal boot animation with HZ logo centered
- Subtle loading spinner/progress
- Dark background (#1E1E1E) for clean boot experience
- Theme name: `happy-zero`
- Location: `branding/plymouth/`

### GRUB Theme
- Custom GRUB theme with HZ branding
- Background matching dark palette
- Clean menu styling
- Theme: `happy-zero-grub`
- Location: `branding/grub/`

### GDM Login Screen
- Custom background (dark variant)
- HZ logo centered
- Clean, minimal layout matching GNOME GDM
- Background image + CSS styling via `gdm3.css` overrides
- Location: `branding/gdm/`

### Icons
- Start with Yaru icon theme as base (open source)
- Add HZ-specific folder colors/accent overrides
- Create HZ systray/logos
- Package as `happy-zero-icons`

---

## 6. Release Model & Versioning

### Versioning Scheme
Format: `HZ X.Y "Codename"`

- **X**: Major version (breaking changes, major UI shifts)
- **Y**: Minor version (feature updates, point releases)
- **Codename**: Thematic codename related to Ubuntu base or unique theme

### Initial Release
**HZ 1.0 "Noble Zero"**

Based on Ubuntu 24.04 LTS Noble Numbat.

### Update Policy
- Track Ubuntu 24.04 LTS security updates and critical bug fixes
- Release HZ point releases (1.1, 1.2) as needed for branding/package updates
- Sync with Ubuntu 24.04.x point releases when appropriate
- Support period aligned with Ubuntu LTS base: **May 31, 2029** (free support window)
- Security updates via standard APT from Ubuntu repos + HZ repo

### Release Cadence
- Point releases as needed (branding fixes, meta-package updates)
- Sync with Ubuntu point releases (24.04.1-24.04.5) to incorporate base updates
- No separate kernel/DE versioning - inherit from base

---

## 7. Repository Strategy

### Primary Repositories
1. **Ubuntu Official Repositories** - Used as-is
   - `main`, `restricted`, `universe`, `multiverse`
   - Mirrors: archive.ubuntu.com or regional mirrors
   - GPG keys: Ubuntu archive keys (already trusted)

2. **Happy Zero Repository** - Small custom repo for HZ-specific packages
   - Hosts: `happy-zero-branding`, `happy-zero-settings`, `happy-zero-desktop-meta`, `happy-zero-keyring`, `happy-zero-welcome`
   - Hosted as a simple signed APT repository (local during build; can be published to GitHub Pages/Object Storage later)
   - Packages built as Debian `.deb` files

### APT Sources Configuration
For the built ISO, sources will be:
```plaintext
deb http://archive.ubuntu.com/ubuntu noble main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu noble-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu noble-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu noble-backports main restricted universe multiverse
```

HZ repo (if published): `deb [signed-by=/usr/share/keyrings/happy-zero.gpg] https://repo.happyzero.org noble main`

### Creating & Signing the HZ Repo

**Key Generation (for HZ packages):**
```bash
# Generate GPG key for package signing
gpg --batch --gen-key happy-zero-key.conf
# Export public key
gpg --export --armor > happy-zero-archive-keyring.gpg
```

**Repository Structure:**
```
repo/
├── dists/
│   └── noble/
│       ├── main/
│       │   └── binary-amd64/
│       │       ├── Packages.gz
│       │       └── Release
│       └── Release.gpg
└── pool/
    └── main/
        └── h/
            └── happy-zero-*/
```

**Signing Releases File:**
```bash
gpg --clearsign -o InRelease Release
gpg -abs -o Release.gpg Release
```

**Tools:** `dpkg-scanpackages`, `apt-ftparchive`, `gpg`

---

## 8. Package List by Tiers

### Architecture: amd64 only (initially)

### Tier 1: Minimal
Core system + minimal desktop for light installs.

**Packages:**
- `ubuntu-minimal` (base)
- `ubuntu-desktop-minimal` (core GNOME) - but we'll customize to remove Ubuntu branding
- `gnome-shell`, `gnome-session`, `nautilus`, `gnome-terminal`
- `firefox` (snap)
- `network-manager`, `network-manager-gnome`
- `pulseaudio`/PipeWire components (default in 24.04)
- `happy-zero-branding`, `happy-zero-settings`

**Size goal:** ~1.8-2.2GB ISO

### Tier 2: Standard (Default) - RECOMMENDED
Balanced for most desktop users. This will be the default ISO.

**Includes Minimal +:**
- `ubuntu-restricted-extras` (codecs, fonts)
- `vlc` or `totem` (media)
- `gnome-calculator`, `gnome-calendar`, `gnome-contacts`, `gnome-text-editor`
- `file-roller`, `gnome-disk-utility`, `gnome-system-monitor`, `baobab`
- `gnome-screenshot`, `eog` or `loupe`
- `gparted` (disk partitioning tool)
- `cups`, `system-config-printer`
- `blueman` or `gnome-bluetooth` (default)
- `synaptic` (optional but useful)
- `flatpak`, `gnome-software-plugin-flatpak`
- `ufw` (firewall)
- `unattended-upgrades`
- `fwupd`
- `timeshift`
- `wget`, `curl`, `htop`, `tree`, `neofetch`
- `fonts-ubuntu`, `fonts-cantarell`
- `happy-zero-welcome` (first-run app)

**Size goal:** ~2.5-3.0GB ISO

### Tier 3: Full
Complete desktop with development, gaming, office.

**Includes Standard +:**
- `libreoffice` (full suite) - writer/calc/impress/math/base
- `thunderbird` (snap or deb - follow Ubuntu choice)
- `shotwell`, `simple-scan`, `remmina`
- `transmission-gtk`
- `build-essential`, `git`, `gcc`, `g++`, `cmake`, `make`
- `python3`, `python3-pip`, `python3-venv`
- `nodejs`, `npm`
- `code` (VS Code - via Microsoft repo or snap)
- `steam-installer`, `lutris`, `wine64`
- `virtualbox` or `virt-manager` (optional)
- `docker.io`
- `inkscape`, `gimp` (graphics)
- `vlc` (full codec support)

**Size goal:** ~3.5-4.0GB ISO

**Note:** All package names verified against Ubuntu 24.04 noble repos.

---

## 9. Architecture Diagram (Mermaid)

```mermaid
graph TD
    A[Source Control: GitHub Repo] --> B[Build Environment]
    B --> C{Build Stage}
    
    C --> D[1. debootstrap Noble Base]
    D --> E[2. Chroot Setup & Mounts]
    E --> F[3. Install Base Packages]
    F --> G[4. Install Desktop Environment]
    G --> H[5. Install HZ Branding Packages]
    H --> I[6. Apply HZ Settings (dconf)]
    I --> J[7. Install Calamares Installer]
    J --> K[8. Configure Calamares Branding]
    K --> L[9. Build SquashFS Filesystem]
    L --> M[10. Create Boot Structure]
    M --> N[11. Generate Hybrid ISO]
    
    O[Ubuntu Repos] --> F
    P[HZ Local Repo/Packages] --> H
    
    N --> Q[ISO Output: happy-zero-1.0-noble-zero-amd64.iso]
    Q --> R[Verification: SHA256 + GPG]
    R --> S[Release Artifacts]
    
    T[CI: GitHub Actions] --> B
    T --> N
    T --> R
    T --> S
    
    style A fill:#1A9C89,color:#fff
    style Q fill:#22D3EE,color:#000
    style T fill:#147A6B,color:#fff
```

### Build Pipeline Flow
1. **Bootstrap**: debootstrap Ubuntu 24.04 noble minimal base into chroot
2. **Customize**: Install GNOME, packages, apply HZ branding/settings
3. **Installer**: Install and configure Calamares with HZ branding
4. **Package**: Create squashfs of chroot filesystem
5. **Bootable ISO**: Generate hybrid ISO with GRUB (BIOS/UEFI)
6. **Verify**: Compute checksums and sign
7. **Release**: Publish via CI

---

## 10. Security Model

### Secure Boot
- Use standard Ubuntu shim from `shim-signed` package
- Kernel from official Ubuntu repos (signed by Canonical)
- No custom unsigned kernel modules planned for initial release
- If custom modules needed later, require proper signing
- Verification: ISO should boot with Secure Boot enabled on standard systems

### Full Disk Encryption
- Calamares supports LUKS2 encryption during installation
- Default to encrypting system partitions (root + home as configured)
- Use strong passphrase requirements (documented)
- TPM-backed encryption: Note from Ubuntu 24.04 - experimental; document as optional/advanced
- Recommend LUKS2 with PBKDF2/Argon2

### Firewall
- `ufw` enabled by default with sensible rules:
  - Default deny incoming
  - Default allow outgoing
  - Allow SSH only if explicitly enabled (not default)
  - Common services as needed

### AppArmor
- Enabled by default (inherited from Ubuntu)
- Profiles for common apps (Firefox, etc.)
- Enforce mode for critical services

### Automatic Security Updates
- `unattended-upgrades` configured for security updates only
- Notify users of important updates
- Reboot notifications for kernel updates (configurable)

### Package Integrity
- APT uses Ubuntu GPG keys
- HZ repo signed with our own GPG key
- ISO published with SHA256 checksum and GPG signature

### Privacy Defaults
- Location services: opt-in
- Telemetry: none (no Canonical telemetry in HZ)
- Crash reporting: disabled by default
- Search providers: minimal, user-configurable

---

## 11. Accessibility & Localization

### Minimum Supported Languages
1. **English (en_US)** - Primary
2. **German (de_DE)** - Secondary (fully translated and tested)

### Additional Language Support
Include language packs for major languages via `language-pack-*` packages.

### Accessibility Features
- GNOME Accessibility (screen reader, magnifier, keyboard navigation)
- High contrast themes available
- Font scaling
- Sticky keys, slow keys, bounce keys
- Mouse keys
- Visual alerts
- Screen reader (Orca)
- Ensure all UI elements have proper labels

### Localization Implementation
- All HZ branding strings in `po/` files for translations
- Welcome app internationalized (gettext or similar)
- Calamares slides/strings translated (EN/DE)
- Installer and first-run flows localized
- Docs in English and German as specified

---

## 12. Implementation Roadmap

### Phase 2 Complete (Current)
- [x] Brand identity defined
- [x] Color palette established
- [x] Versioning scheme set
- [x] Architecture diagram created
- [x] Package tiers defined
- [x] Security model outlined
- [x] Repository strategy documented

### Phase 3 Implementation Tasks
1. **Directory Structure**: Create all required directories per spec
2. **Build Scripts**: Write debootstrap-based build pipeline (main script + helpers)
3. **Branding Assets**: Create SVG logos, wordmarks, wallpapers, themes (Plymouth, GRUB, GDM)
4. **Debian Packaging**: Create debian/ dirs for 4 HZ packages
5. **Settings**: Write dconf profiles and gsettings overrides
6. **Calamares Config**: Configure installer with HZ branding
7. **Welcome App**: Build GTK4 + libadwaita app (Rust or Python - recommend Python with PyGObject for simplicity)
8. **CI/CD**: GitHub Actions workflow for building ISO
9. **Tests**: Smoke tests (QEMU), lintian checks, shellcheck
10. **Documentation**: README, build guide, install guides (EN/DE), contributing, license/trademark, FAQ, roadmap
11. **Licensing**: LICENSE files and third-party notices

---

## 13. Design Decisions Summary

| Area | Decision | Justification |
|---|---|---|
| Base | Ubuntu 24.04.5 LTS | Current, stable, long support |
| Build Tool | debootstrap+mksquashfs+xorriso | Transparent, reproducible, full control |
| Installer | Calamares | Best branding customization, derivative-friendly |
| Theme | Yaru-based with teal accent | Keeps Ubuntu feel, unique identity |
| Name | Happy Zero (HZ) | Distinct, no trademark conflicts |
| Default Tier | Standard | Balanced UX |
| Languages | EN + DE minimum | Spec requirement |
| Desktop | GNOME 46 | Matches spec |
| Architecture | amd64 only | Focused initial target |

---

## Next Steps

Proceed to Phase 3: Implementation of complete repository with all files as specified.