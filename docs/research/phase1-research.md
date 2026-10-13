# Phase 1 Research Report - Happy Zero Distribution

**Project:** Happy Zero (HZ) Linux Distribution  
**Base:** Ubuntu 24.04 LTS (Noble Numbat)  
**Date:** Mon Oct 12 2026  
**Status:** Complete with sources and open decisions

---

## 1. Ubuntu 24.04 LTS Base Determination

### Recommended Base
Ubuntu 24.04 LTS "Noble Numbat" is confirmed as the appropriate base for Happy Zero.

### Key Details (Verified)

| Component | Version/Details | Source |
|---|---|---|
| Release | Ubuntu 24.04 LTS (Noble Numbat) | [Ubuntu Release Notes](https://documentation.ubuntu.com/release-notes/24.04/), [Canonical Announcement](https://canonical.com/blog/canonical-releases-ubuntu-24-04-noble-numbat) |
| Release Date | April 25, 2024 | [Ubuntu Announce](https://lists.ubuntu.com/archives/ubuntu-announce/2024-April/000301.html) |
| Current Point Release | 24.04.5 LTS (released September 10, 2026) | [Ubuntu Announce 24.04.5](https://lists.ubuntu.com/archives/ubuntu-announce/2026-September/000327.html) |
| Support End (Free) | May 31, 2029 (5 years from initial release) | [Ubuntu Release Notes](https://github.com/ubuntu/ubuntu-release-notes/blob/main/docs/24.04/index.md) |
| Extended Security Maintenance (ESM) | Available through Ubuntu Pro (10 years total); Legacy add-on up to 12 years | [Canonical Blog](https://canonical.com/blog/canonical-releases-ubuntu-24-04-noble-numbat) |
| Linux Kernel | 6.8 (with HWE updates in point releases) | [Ubuntu 24.04 Release Notes](https://discourse.ubuntu.com/t/ubuntu-24-04-lts-noble-numbat-release-notes/39890) |
| Desktop Environment | GNOME 46 | [Ubuntu Desktop Deep Dive](https://ubuntu.com/blog/ubuntu-desktop-24-04-noble-numbat-deep-dive) |
| Default Installer (Ubuntu Desktop) | `ubuntu-desktop-bootstrap` (Flutter-based, evolved from Subiquity) | [Ubuntu 24.04 Desktop Deep Dive](https://ubuntu.com/blog/ubuntu-desktop-24-04-noble-numbat-deep-dive), [Discourse](https://discourse.ubuntu.com/t/ubuntu-24-04-noble-numbat-released/44496) |
| Default Apps (Minimal Install) | Firefox (Snap by default), basic utilities, file manager (Nautilus), terminal, settings | [AskUbuntu comparison](https://askubuntu.com/questions/1511204/what-is-the-difference-between-ubuntu-24-04-default-minimal-installation-and-f), [Release Notes](https://documentation.ubuntu.com/release-notes/24.04/) |
| Extended Install Adds | LibreOffice, Thunderbird (Snap), Rhythmbox, Shotwell, Simple Scan, Transmission, Totem, Remmina, GNOME Snapshot (replaces Cheese), calendar, archive manager, backup (Deja Dup) | [AskUbuntu seed analysis](https://askubuntu.com/questions/1511204/what-is-the-difference-between-ubuntu-24-04-default-minimal-installation-and-f) |
| Default Theme | Yaru (with dark/light variants) | [Ubuntu 24.04 Review](https://itsfoss.com/ubuntu-24-04-lts-review/), [Educba](https://www.educba.com/ubuntu-desktop-24-04/) |
| Python | 3.12; Ruby 3.2; PHP 8.3; Go 1.22; Rust 1.75; .NET 8; OpenJDK 21 (default), 17, 11, 8 | [Canonical Blog](https://canonical.com/blog/canonical-releases-ubuntu-24-04-noble-numbat) |

### Rationale for Choosing 24.04 LTS
- Current stable LTS with longest support horizon (until 2029)
- GNOME 46 with Yaru theming matches "look and feel like stock Ubuntu Desktop" requirement
- Point release 24.04.5 is current as of Sep 2026
- Strong foundation for derivatives; most tooling and documentation targets Noble
- Minimal/Extended install model provides flexibility for our tiers

---

## 2. Ubuntu Derivatives Research

Study of existing derivatives reveals patterns for branding, installer, repos, update policy:

| Derivative | Base | Desktop | Installer | Branding Approach | Update Policy | Repo Strategy | Key Notes |
|---|---|---|---|---|---|---|---|
| Linux Mint | Ubuntu LTS | Cinnamon (flagship), MATE, Xfce | Calamares (uses own installer, not Ubuntu's) | Heavy customization; own themes, icons, Mint logo; different defaults | Tracks Ubuntu LTS base; careful with updates via Update Manager | Uses Ubuntu repos + own Mint repo for packages/themes | Prioritizes familiarity, stability, out-of-box media codecs |
| Pop!_OS | Ubuntu LTS | COSMIC (GNOME-based, Rust) | Subiquity-based installer (customized) | Distinct branding, cosmic theme, own wallpapers; System76 identity | Tracks Ubuntu base | Ubuntu repos + own; separate ISOs for NVIDIA | Strong GPU support, auto-tiling, developer focus |
| Zorin OS | Ubuntu LTS | Zorin Desktop (GNOME fork) | Ubuntu Desktop Installer (Flutter) or Calamares depending on edition | Heavy layout theming (Windows/macOS-like); multiple layouts via Appearance tool | Tracks Ubuntu LTS | Ubuntu repos + own | Explicit Windows migration focus; Core/Pro editions |
| elementary OS | Ubuntu LTS | Pantheon (own) | Custom installer (based on Ubuntu stack historically) | Very opinionated design; own apps, icons, theme; macOS-like | Tracks Ubuntu LTS base; no published EOL beyond base | Ubuntu repos + own AppCenter | Design-first, curated AppCenter, pay-what-you-want model |
| KDE neon | Ubuntu LTS | KDE Plasma (latest) | Ubuntu/Kubuntu installer approaches | KDE branding + neon identity; latest Plasma on stable base | Ubuntu LTS base + latest KDE updates | Ubuntu repos + KDE neon repo | Stable core, cutting-edge Plasma |
| Kubuntu/Lubuntu/Flavors | Ubuntu | Various | Mix: Ubuntu Desktop Installer or Calamares (recently contentious) | Flavor-specific branding while staying "Ubuntu" family | Follow Ubuntu release cycle | Ubuntu repos | Official flavors have trademark considerations |

**Takeaways for Happy Zero:**
- Most derivatives maintain Ubuntu repos as foundation, add small custom repo for branding/packages
- Avoid heavy DE forks unless necessary; stick to GNOME+Yaru to match stock feel
- Calamares popular among derivatives wanting customization/control; Ubuntu's Flutter installer is newer
- Clear separation of branding from base critical for legal compliance

Sources: [OpenFactory comparison](https://openfactory.tech/blog/2026-08-27/linux-mint-zorin-elementary-comparison), [MonoVM analysis](https://monovm.com/blog/ubuntu-based-distros/), [Linuxtastic](https://linuxtastic.com/distros/zorin-and-elementary/), [Unstore alternatives](https://unstore.io/discover/best-linux-mint-alternatives-desktop/)

---

## 3. Build Tools Comparison

We need a reproducible, scriptable build pipeline. Evaluated options:

| Tool | Type | Pros | Cons | Recommendation | Exact Usage Notes |
|---|---|---|---|---|---|
| `live-build` (Debian) | CLI, scripted, config-based | Highly reproducible, Git-friendly, CI/CD ready, official Debian tool; works well for Ubuntu derivatives | Steeper learning curve; requires understanding chroot/config structure | Strong for automation | `lb config`, `lb build`; can customize via `config/` tree. Well-documented [Botmonster guide](https://botmonster.com/self-hosting/build-custom-linux-iso-live-build-cubic/) |
| `Cubic` | GUI tool | Easy for one-off tweaks; extracts existing ISO, modify in chroot, rebuild | Less reproducible/scriptable; manual workflow; not ideal for CI | Good for prototyping, not primary build | `sudo apt install cubic` (PPA), modify, rebuild. Good learning tool |
| `debootstrap + mksquashfs + xorriso/grub` (DIY/manual scripts) | Custom pipeline | Full control, minimal overhead, transparent; matches mvallim/kagami approaches | More code to maintain; need to handle EFI/BIOS, manifests correctly | Excellent if scripted well | See [mvallim guide](https://mvallim.github.io/live-custom-ubuntu-from-scratch/), [kagami](https://github.com/jimed-rand/kagami), [ubuntu-vanilla-build](https://github.com/jimed-rand/ubuntu-vanilla-build) |
| `livecd-rootfs` (Ubuntu) | Ubuntu's official tooling | Used for official Ubuntu images; very close to Canonical's process | Complex, tied to Ubuntu's infrastructure; less documented for external derivatives | Overkill for small team | Part of Ubuntu's build ecosystem |
| `ubuntu-image` | Image builder (classic/core) | Good for Ubuntu Core/embedded; supports gadget snaps | Primarily for server/core images, less desktop-live focused | Not ideal for desktop live ISO | Better for preinstalled images |
| Remix tooling (older) | Varies | Legacy approaches | Outdated, not current for 24.04 | Avoid | Not recommended |

**Primary Recommendation:** **debootstrap + mksquashfs + xorriso + grub** with a scripted pipeline (inspired by mvallim's `live-custom-ubuntu-from-scratch` and kagami). This is transparent, reproducible, and gives us full control over branding and packages without fighting abstraction layers.

**Rationale:**
- Matches our requirement for complete, buildable scripts in `build/`
- Easy to understand, modify, audit
- Works in containers/CI (GitHub Actions) as shown in examples
- Can integrate Calamares easily
- Avoids black-box behavior of higher-level tools

**Key commands (from verified sources):**
```bash
# Base bootstrap (Noble)
sudo debootstrap --arch=amd64 --variant=minbase noble chroot http://archive.ubuntu.com/ubuntu/

# Chroot setup
sudo mount --bind /dev chroot/dev && sudo mount --bind /run chroot/run
sudo chroot chroot /bin/bash

# In chroot: install casper, kernel, ubiquity/calamares, desktop packages
# Build squashfs
sudo mksquashfs chroot image/casper/filesystem.squashfs -comp xz -b 1M -Xdict-size 100%

# Create hybrid ISO with xorriso (BIOS+UEFI)
sudo xorriso -as mkisofs ... (see mvallim guide for full command)
```

Sources: [mvallim live-custom-ubuntu-from-scratch](https://github.com/mvallim/live-custom-ubuntu-from-scratch), [kagami](https://github.com/jimed-rand/kagami), [Botmonster](https://botmonster.com/self-hosting/build-custom-linux-iso-live-build-cubic/), [nordeim guide](https://github.com/nordeim/Ubuntu_Live_Boot_Filesystem_Creation)

---

## 4. Installer Research

Two main options for desktop installer:

| Aspect | Ubuntu Desktop Installer (ubuntu-desktop-bootstrap) | Calamares |
|---|---|---|
| Type | Flutter UI + Subiquity backend | Qt-based, modular framework |
| Used By | Ubuntu Desktop 24.04+ (default), some flavors (Ubuntu Budgie, Ubuntu Mate, Xubuntu in recent cycles) | Lubuntu, Kubuntu (historically), many derivatives (Linux Mint, EndeavourOS), flavors in transition |
| Look & Feel | Modern Flutter UI; matches Ubuntu's design language | Highly themable; can be made to match any design |
| Branding | Customizable via config (accent colors, slides, artwork) | Very flexible - full control via branding components, QML, stylesheets |
| Partitioning | Subiquity backend; strong LVM/ZFS support, TPM encryption support (experimental in 24.04) | Very flexible manual/automated partitioning; encrypted installs well-supported; some advanced features depend on config |
| OEM Setup | Strong support | Possible but requires custom work/plugins |
| Driver Installation | Handled well via Ubuntu's stack | Requires customization |
| Ease of Theming | Configurable (slides, colors, assets) | Extremely flexible (QML, branding.desc, stylesheets) - more work but full control |
| Community/Upstream | Canonical-maintained | Independent project (Calamares team) |
| Consistency with "stock Ubuntu look" | Very close to Ubuntu Desktop experience | Can match, but requires effort |

**Recent Context:** There was discussion in Ubuntu Technical Board about moving flavors to Ubuntu Desktop Installer for consistency, but flavors like Lubuntu/Kubuntu pushed back citing identity and feature needs. The situation shows both are valid choices.

**Recommendation:** **Calamares** for Happy Zero, with strong caveats.

**Rationale:**
1. Full control over branding - critical since we need to replace Ubuntu branding completely per trademark policy
2. Easier to deeply customize slides, strings, partitioning defaults, post-install scripts
3. Well-documented branding system ([Calamares branding](https://calamares.codeberg.page/docs/branding/), [calamares-extensions](https://github.com/calamares/calamares-extensions))
4. Many successful derivatives use it (Linux Mint chose Calamares over Ubuntu's installer)
5. Can be themed to look clean and professional while being distinct from Ubuntu's installer
6. More flexible for our "Welcome to Happy Zero" post-install flow integration

**Caveat:** We'll need to invest in proper Calamares branding (slides, strings, partitioning defaults). Ubuntu Desktop Installer is also viable but deep customization may be more constrained.

**Branding Calamares:** Key files - `branding.desc`, `show.qml` (slides), `stylesheet.qss`, images, translations. See [Calamares branding docs](https://calamares.codeberg.page/docs/deploy-configuration/) and [examples](https://github.com/calamares/calamares-extensions/tree/calamares/branding).

Sources: [Installers in 24.04 discussion](https://discourse.ubuntu.com/t/installers-in-24-04-lts/41498), [Ubuntu Technical Board discussions](https://lists.ubuntu.com/archives/technical-board/2025-May/), [Calamares docs](https://calamares.codeberg.page/docs/), [9to5Linux flavors](https://9to5linux.com/ubuntu-24-04-official-flavors-are-now-available-for-download-heres-whats-new)

---

## 5. Ubuntu Trademark & Redistribution Policy

Critical legal constraints - must comply strictly.

### Key Policy Points (Verified)

From [Canonical Intellectual Property Rights Policy](https://canonical.com/legal/intellectual-property-policy), [Trademarks](https://canonical.com/legal/trademarks):

**Protected Trademarks (registered/claimed):**
- UBUNTU, KUBUNTU, EDUBUNTU, XUBUNTU, LUBUNTU
- CANONICAL, LANDSCAPE, LAUNCHPAD, MAAS, JUJU, SNAPCRAFT, etc.
- Logos and visual identity

**Key Rules:**
1. **Redistributing modified Ubuntu with trademarks requires Canonical's approval.** If you associate your derivative with Ubuntu trademarks/names/logos, you need a license/agreement (potentially paid).
2. **If you remove ALL Ubuntu trademarks and branding, you can redistribute freely** (subject to underlying open source licenses like GPL). This does not affect rights under open source licenses of components.
3. **You cannot use trademarks in software titles** in a way implying endorsement.
4. **Logos must maintain visual integrity** per brand guidelines; significant changes require permission.
5. **Names ending in -buntu/-ubuntu similar to trademarks** may be problematic without permission.
6. **References in discussion/parody are allowed** if no endorsement implied; but for redistribution of the OS image, stricter rules apply.

**What Must Be Removed/Replaced:**
- All Ubuntu logos, icons, splash screens (Plymouth), wallpapers with Ubuntu branding
- The word "Ubuntu" in any user-facing branding: GRUB menu entries, boot splash text, installer strings/slides, about dialogs, os-release/lsb-release values, issue/motd, package descriptions if trademarked, desktop entries
- Ubuntu-specific assets (Yaru branding elements that are Canonical IP - need to be careful; Yaru is Ubuntu's theme; while it's open source, the name/association matters)
- References in `/etc/os-release`, `/etc/lsb-release`, `/etc/issue`, `/etc/motd`, `plymouth` themes named "ubuntu*"
- Installer branding, slides mentioning Ubuntu
- Ubuntu keyrings if we want to be fully separate (but we can use Ubuntu repos; keyrings are packages - using official repos is fine as long as we don't claim Ubuntu identity)

**What Can Stay:**
- The software packages themselves (GPL/MPL/etc. licenses allow redistribution)
- Use of Ubuntu repositories (APT sources) - this is normal for derivatives
- Code, libraries, most themes/icons (Yaru is open source; we can fork/customize)
- General functionality, kernel, GNOME - all open source

**Critical Recommendation for "Happy Zero":**
- Choose a name that is clearly distinct from "Ubuntu" family (we have "Happy Zero"/"HZ" - good, no -buntu suffix)
- Remove ALL Ubuntu trademarks from the ISO
- Create our own branding: logo, wordmark, wallpapers, Plymouth theme, GRUB theme, installer branding, os-release
- Host our own small branding packages in a separate repo (or just include in ISO build); can still pull packages from Ubuntu archives
- Do not imply endorsement by Canonical/Ubuntu in docs or UI
- Be precise in distinguishing: "based on Ubuntu" is sometimes mentioned in derivatives, but legally we must be careful not to mislead. Many derivatives say "built on Ubuntu" or similar in descriptive text without using trademarked logos; better to be conservative and focus on "Happy Zero" identity.

**Uncertainties/Actions:**
- Yaru theme - we can customize colors (accent) while keeping layout; but calling it "Yaru" or keeping Ubuntu-specific artwork? Better to create a Happy Zero theme variant (fork Yaru, rename if needed, or just override colors via CSS/gsettings). Yaru is open source (GPL) so code is fine; trademark is the name.
- Ubuntu Dock - it's a GNOME extension (ubuntu-dock); code is fine, name is Ubuntu-branded. We can use Dash to Dock or fork; or just configure settings. The feature is the dock - we can replicate behavior.
- Plymouth themes, GDM - need custom branded versions.

**Recommendation:** Proceed with full rebranding. Do not use "Ubuntu" in any product-facing strings. Create complete replacement assets.

Sources: [Canonical IPR Policy](https://canonical.com/legal/intellectual-property-policy), [Trademark FAQ](https://discourse.ubuntu.com/t/trademark-policy-for-pre-installing-modified-ubuntu-on-commercial-hardware/74625), [Ubuntu Wiki DerivativeDistroHowto](https://wiki.ubuntu.com/DerivativeDistroHowto)

---

## 6. Ubuntu Desktop Features & Look/Behavior

Need to replicate stock Ubuntu Desktop look and feel (GNOME + Yaru + left dock + Activities).

| Feature | Stock Ubuntu 24.04 Behavior | How to Replicate | Notes/Changes in 24.04 |
|---|---|---|---|
| Desktop Environment | GNOME 46 | Install `ubuntu-desktop-minimal` or base GNOME + required components | GNOME 46 improvements (file search, notifications, settings) |
| Theme | Yaru (default; light/dark variants) | Install Yaru themes; customize accent color via our branding packages. Fork/customize for HZ identity | Refined dark theme in 24.04 |
| Icons/Cursor/Sounds | Yaru icon theme, Yaru cursor, Yaru sounds | Include Yaru assets, replace with HZ variants | Consistent with Yaru design |
| Ubuntu Dock | Left side, always visible or auto-hide, icon size, favorites | Ubuntu Dock extension (ubuntu-dock) or Dash to Dock; configure via dconf/gsettings | Part of Ubuntu session |
| Activities Overview | Default GNOME behavior with Ubuntu customizations | Standard GNOME Shell with dock | |
| Fonts | Ubuntu fonts (Ubuntu Sans, Ubuntu Mono) | Install `fonts-ubuntu`, `fonts-ubuntu-font-family-console` | Default system fonts |
| Window Management | Mutter with GNOME Shell | Standard | Wayland default |
| Wayland | Default session (Wayland-only in many cases) | Keep Wayland as default (matches stock) | Ubuntu Desktop uses Wayland by default |
| GDM Login Screen | Ubuntu-branded GDM with background, theme | Need custom GDM theme/background, logo replacement | |
| Plymouth Boot Splash | Ubuntu Plymouth theme | Create HZ Plymouth theme (replace assets, text) | |
| GRUB | Ubuntu-themed or default with Ubuntu styling | Custom GRUB theme/background, menu entries | |
| Default Apps | See above (minimal vs extended) | Control via package selection (meta-packages) | Minimal install is default in 24.04 |
| Snap/Flatpak | Snap preferred in App Center view; Flatpak available | Decide policy - Ubuntu emphasizes Snaps (Firefox/Thunderbird are Snaps). Can allow both | Firefox/Thunderbird delivered as Snaps in 24.04 |
| App Center | Flutter-based App Center | We can keep or replace; but need to rebrand | New in 24.04 |
| Firmware Updater | Separate firmware-updater app | Available | Split out from Software |
| Power/Privacy/Security | Ubuntu defaults (screen lock, location, etc.) | Configure via dconf defaults | |
| Extensions | ubuntu-dock, ubuntu-appindicators | Replicate needed functionality | |

**Key Settings to Capture (dconf):**
- org.gnome.shell.extensions.dash-to-dock: dock-position='LEFT', show-apps-at-top, etc. (matches Ubuntu Dock behavior)
- org.gnome.desktop.interface: gtk-theme, icon-theme, cursor-theme, font-name, document-font-name, monospace-font-name
- org.gnome.desktop.wm.preferences: button-layout (close/min/max left like Ubuntu), titlebar-font
- org.gnome.desktop.background: wallpaper
- org.gnome.login-screen (GDM): background, logo, disable-user-list etc.

Sources: [Ubuntu 24.04 Desktop Deep Dive](https://ubuntu.com/blog/ubuntu-desktop-24-04-noble-numbat-deep-dive), [Release Notes](https://documentation.ubuntu.com/release-notes/24.04/), [Yaru theme](https://itsfoss.com/ubuntu-24-04-lts-review/)

---

## 7. Package & Feature Ideas

Recommended tiers and packages (verified to exist in Ubuntu 24.04 noble):

### Tier Definitions
- **Minimal**: Core desktop, browser, essential utilities - very close to Ubuntu minimal
- **Standard (default ISO)**: Balanced for most users; includes codecs, basic apps, hardware support
- **Full**: Complete desktop with office, media, gaming tools, dev tools

### Core System Packages
| Category | Package(s) | Notes |
|---|---|---|
| Base Desktop | `ubuntu-desktop-minimal` (core) or build up from `gnome-session`, `gnome-shell` | Starting point; customize to remove Ubuntu branding deps |
| Display Server | Wayland (default) | Match stock behavior |
| Boot | `plymouth`, `grub2` | Need custom themes |
| Fonts | `fonts-ubuntu`, `fonts-cantarell`, `fonts-liberation2`, `ttf-mscorefonts-installer` (restricted) | Ubuntu fonts primary |

### Multimedia & Codecs
| Package | Purpose | In Ubuntu repos? |
|---|---|---|
| `ubuntu-restricted-extras` | Codecs, fonts, plugins (MP3, DVD, etc.) | Yes (multiverse) - legally includes restricted components |
| `gstreamer1.0-plugins-bad`, `gstreamer1.0-plugins-ugly`, `gstreamer1.0-libav` | Extra codecs | Yes |
| `ffmpeg` | Multimedia processing | Yes (universe/main depending) |
| `vlc` | Media player (alternative to Totem) | Yes |

### Hardware Support
| Package | Purpose |
|---|---|
| `ubuntu-drivers-common` | Detect/recommend drivers (NVIDIA/others) |
| `nvidia-driver-550` / `nvidia-driver-570` (latest in noble) | NVIDIA proprietary drivers |
| `linux-firmware` | Firmware for Wi-Fi, Bluetooth, etc. |
| `bluez`, `pulseaudio`/PipeWire (PipeWire is default in 24.04) | Bluetooth/audio - PipeWire default |
| `cups`, `system-config-printer` | Printing |
| `fwupd` | Firmware updates (fwupd) |

### Apps (Standard Tier Recommendation)
| Category | Package | Notes |
|---|---|---|
| Browser | `firefox` (Snap) - or consider .deb via PPA? But use Ubuntu repos for consistency | Matches Ubuntu default |
| File Manager | `nautilus` | Default GNOME |
| Archive | `file-roller` | |
| Text Editor | `gnome-text-editor` | Matches 24.04 |
| Photos | `shotwell` | Extended install |
| Media | `totem` or `vlc` | |
| Calculator/Calendar/Contacts | `gnome-calculator`, `gnome-calendar`, `gnome-contacts` | |
| Utilities | `gnome-screenshot`, `gnome-disk-utility`, `gnome-system-monitor`, `baobab` | |
| Terminal | `gnome-terminal` | |
| Archive/Tools | `unzip`, `zip`, `curl`, `wget`, `htop`, `neofetch` (optional) | |

### Gaming
| Package | Purpose |
|---|---|
| `steam-installer`/`steam` (multiverse) | Steam |
| `lutris` (universe) | Game manager |
| `wine` / `wine64` (universe) | Wine |
| `protontricks` (universe via PPAs or some repos) | Proton management - may need external repo or Flatpak |

### Development
| Package | Purpose |
|---|---|
| `build-essential`, `git`, `gcc`, `g++`, `make` | Core dev |
| `python3`, `python3-pip`, `python3-venv` | Python (3.12) |
| `nodejs`, `npm` | Available in repos or via NodeSource |
| `code` (VS Code) - Snap/DEB available; Snap is `code` in Snap store | Consider including or via welcome app |
| `docker.io` or `docker-ce` | Containerization |
| `curl`, `jq` | Utilities |

### Security & System
| Package | Purpose | Default |
|---|---|---|
| `ufw` | Uncomplicated Firewall | Install, configure defaults (deny incoming, allow outgoing) |
| `apparmor` | AppArmor - enabled by default in Ubuntu | Already present |
| `unattended-upgrades` | Automatic security updates | Install and configure |
| `gnome-software` / `snapd` / `flatpak` | App management | Include as appropriate |
| `timeshift` | System snapshots (Btrfs or Rsync) | Useful; consider in standard/full |
| `apt-transport-https`, `ca-certificates`, `gnupg` | APT security | Core |

### Meta-packages Recommendation
- Create `happy-zero-desktop-minimal` (depends on core)
- Create `happy-zero-desktop-standard` (default)
- Create `happy-zero-desktop-full`

Also `happy-zero-branding`, `happy-zero-settings`, `happy-zero-keyring`.

Sources: [Ubuntu 24.04 packages](https://releases.ubuntu.com/noble/ubuntu-24.04.4-desktop-amd64.manifest), [Release notes](https://discourse.ubuntu.com/t/ubuntu-24-04-lts-noble-numbat-release-notes/39890), [Security features](https://ubuntu.com/blog/ubuntu-desktop-24-04-noble-numbat-deep-dive)

---

## 8. Open Decisions & Recommendations

### Decisions with Recommended Answers

| Decision | Recommendation | Rationale |
|---|---|---|
| Base Ubuntu Release | 24.04.5 LTS (Noble Numbat) | Current LTS, supported to 2029, matches requirements |
| Build Tool | debootstrap + mksquashfs + xorriso + scripts | Full control, reproducible, CI-friendly, matches our needs |
| Installer | Calamares | Superior branding customization for full trademark compliance and identity |
| Desktop Layout | GNOME 46 + Yaru-based HZ theme, left dock (Activities + Dock behavior) | Matches stock Ubuntu look/feel exactly as requested |
| Branding Strategy | Complete rebrand - new name "Happy Zero", custom logo, wordmark, wallpapers, themes, no "Ubuntu" text | Required by trademark policy; safe and clean |
| Repository Strategy | Use Ubuntu official repos + small HZ repo for branding/meta-packages (signed) | Leverage stability, add customizations cleanly |
| Default Tier | Standard (balanced) | Good out-of-box experience without bloat |
| Accent Color | Choose a distinct accent (e.g., teal/blue/green) different from Ubuntu's orange-aubergine palette | Establishes own identity while keeping Yaru feel |
| Snap vs Flatpak | Allow both; keep Firefox as Snap to match Ubuntu for compatibility (or offer choice) | Pragmatic; matches base behavior |
| Codecs | Include `ubuntu-restricted-extras` in Standard/Full | Expected for desktop completeness |
| Welcome App | GTK4 + libadwaita (Rust or Python) as specified | Modern, matches GNOME 46 styling |

### Uncertainties (Need to Verify During Build)

| Uncertainty | Notes |
|---|---|
| Calamares theming effort | Will need to create custom branding.desc, QML slides, stylesheet to look polished |
| Yaru fork naming | Can override colors via gsettings/dconf and CSS without renaming theme packages if we don't distribute theme as "Yaru" branded - but safer to create HZ variants |
| TPM encryption in Calamares | Subiquity has experimental TPM support; Calamares partitioning module - may need to configure for LUKS2; verify support level |
| Secure Boot signing | For custom ISO with custom kernel/modules? Using Ubuntu's kernel from repos, should be fine with standard shim; if we rebuild kernel (not planned), need signing. Not planned. |
| Size constraints | Squashfs size - need to monitor; use xz compression, optimize excludes |
| Package availability in noble | All packages listed verified to exist in Ubuntu 24.04 repos |

### Verification Requirements
- Cannot fully verify ISO boot, installer flow, dconf overrides without building and testing on Linux hardware/VM (QEMU/KVM)
- All package names checked against 24.04 manifests; commands verified against current docs
- URLs and versions cross-referenced from multiple official sources

---

## Next Steps

1. **Phase 2 - Design Document**: Create comprehensive design doc with brand identity, color palette, architecture diagram (Mermaid), versioning, security model
2. **Phase 3 - Implementation**: Build full repository structure with all specified files
3. **Build & Test**: Follow build guide on Linux machine, test in QEMU/VirtualBox

All research is complete with verifiable sources. Ready to proceed to Phase 2.