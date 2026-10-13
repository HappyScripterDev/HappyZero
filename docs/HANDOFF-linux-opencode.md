# Handoff: Happy Zero (HZ) Linux Distribution - Build Completion

This document is a complete briefing for an AI coding agent working inside the
Ubuntu 24.04 build VM. Read it fully, then read the rest of the repository
before changing anything. The goal is a real, bootable ISO.

---

## 0. TL;DR - What you must deliver

Make this command work end to end:

```bash
cd ~/HappyZeroOS
sudo ./build/scripts/build-hz.sh
```

It must produce a bootable hybrid ISO (BIOS + UEFI) at:

```
out/happy-zero-1.0-noble-zero-amd64.iso
```

That ISO must:
- boot to a live GNOME desktop with Happy Zero branding,
- let the user install via the Calamares installer (Happy Zero branded),
- install a system whose `/etc/os-release` shows `Happy Zero`, not `Ubuntu`,
- contain no Ubuntu trademarks in user-facing output (see trademark rules below).

**WARNING:** The current scripts are only a scaffold. `build-hz.sh` currently
stops after bootstrapping the chroot and prints "Further steps to be implemented
in Phase 3". It does NOT create an ISO. Several docs claim "all phases complete"
- do not trust those claims; verify every script by reading it.

---

## 1. Project overview

- **Product name:** Happy Zero (HZ)
- **Version:** 1.0 "Noble Zero"
- **Base:** Ubuntu 24.04 LTS "Noble Numbat" (codename `noble`)
- **Desktop:** GNOME 46, look/feel like stock Ubuntu Desktop (left dock, Yaru styling)
- **Architecture:** amd64
- **Installer:** Calamares
- **License:** MIT (repo `LICENSE`)
- **Tagline:** "Simple. Secure. Yours."
- **Accent color:** teal/cyan - primary `#1A9C89`, accent `#22D3EE`, dark bg `#1E1E1E`
- **Languages:** UI/docs English + German
- **Support window:** until 2029-05-31 (aligned with Ubuntu LTS)

Read these first:
- `README.md`
- `docs/research/phase1-research.md`
- `docs/design/phase2-design.md`
- `docs/trademark-license.md`
- `docs/build-guide.md`

---

## 2. Environment (the VM you are running in)

- Ubuntu 24.04 desktop VM, host is Windows, repo copied to `~/HappyZeroOS`.
- No git history; treat files as-is.
- You have sudo. Build uses `/tmp/hz-workspace` (configurable via `WORKSPACE_DIR`).
- Disk: ensure at least ~35 GB free; RAM 4 GB+ recommended.

Install build dependencies first:

```bash
sudo apt update
sudo apt install -y \
  debootstrap squashfs-tools xorriso mtools \
  syslinux-utils isolinux \
  grub-pc-bin grub-efi-amd64-bin grub-common \
  shim-signed mtools dosfstools \
  calamares calamares-settings-debian \
  dpkg-dev debhelper devscripts equivs
```

For testing (optional but recommended):

```bash
sudo apt install -y qemu-kvm qemu-system-x86 ovmf
```

---

## 3. Repository layout

```
branding/            os-release, lsb-release, issue, issue.net, motd,
                     logos/*.svg, plymouth/happy-zero/*, grub/happy-zero/logo.svg
build/
  config/default-config.sh    build variables (name, labels, package lists)
  scripts/build-hz.sh         MAIN orchestrator (INCOMPLETE)
  scripts/chroot-setup.sh     runs inside chroot (INCOMPLETE)
packages/
  happy-zero-branding/        debian/ package (branding files)
  happy-zero-settings/        debian/ package (dconf/gsettings defaults)
  happy-zero-desktop-meta/    debian/ metapackage (depends on desktop + apps)
  happy-zero-keyring/         debian/ package (archive keyring placeholder)
settings/
  dconf/db/local.d/*          dconf defaults
  dconf/profile/user
  gsettings/*.gschema.override
installer/calamares/
  settings.conf
  branding/happyzero/*        branding.desc, show.qml, logo.*, welcome.*
  modules/*.conf              welcome, packages, partition, unpackfs
welcome-app/                 GTK4/libadwaita first-run app scaffold
tests/smoke-test.sh
docs/*                       EN + DE documentation
ci/workflows/build-iso.yml   CI stub
```

---

## 4. What is missing / broken (your job)

### 4.1 `build/scripts/build-hz.sh` (critical)
Currently: checks root + deps, `debootstrap` noble minbase, mounts chroot,
runs `chroot-setup.sh`, unmounts, exits. **No squashfs, no ISO, no branding.**

Implement the full pipeline. Recommended stages (you may restructure, but keep
the CLI and output path stable):

1. `check_root`, `check_dependencies` (fail hard, not just warn, if a required
   tool is missing).
2. `setup_workspace` - clean and create `chroot/`, `image/`, `iso/`, `out/`.
3. `bootstrap_base` - `debootstrap --arch=amd64 --variant=minbase noble`.
4. `mount_chroot` - bind /dev, /run, /proc, /sys, /dev/pts.
5. Copy repo build assets INTO the chroot before running setup:
   `build/scripts/chroot-setup.sh` -> `/tmp/`.
6. `chroot-setup.sh` (see 4.2) installs base + desktop + calamares.
7. Build the four HZ packages inside the chroot from `packages/*` with
   `dpkg-buildpackage`, then install the resulting `.deb`s. (Alternatively build
   them on the host for `noble` and copy in - pick one and document it.)
8. Apply branding: copy `branding/os-release`, `lsb-release`, `issue`,
   `issue.net`, `motd` into `/etc/`; install the Plymouth theme into
   `/usr/share/plymouth/themes/happy-zero/`; install GRUB logo into
   `/usr/share/grub/` or `/boot/grub/`.
9. Configure the live system for casper:
   - write `/etc/casper.conf` (username, hostname, user full name),
   - create a live user (`ubuntu` or `hz`) if needed by casper,
   - ensure the installed `casper` package initramfs hooks are used.
10. Copy the Calamares config + branding into the chroot:
    `installer/calamares/settings.conf` -> `/etc/calamares/settings.conf`,
    `installer/calamares/branding/happyzero/` -> `/etc/calamares/branding/happyzero/`,
    `installer/calamares/modules/*.conf` -> `/etc/calamares/modules/`.
11. Clean the chroot (apt clean, remove logs, machine-id empty, remove SSH host
    keys), then unmount.
12. `mksquashfs` the chroot into `image/casper/filesystem.squashfs`
    (use `-comp xz` or `-comp zstd`, exclude `/proc /sys /dev /run /tmp`).
13. Report squashfs size into `image/casper/filesystem.size` and build a
    matching `filesystem.manifest`.
14. Assemble the ISO tree in `image/`:
    - `casper/` with squashfs + initrd + vmlinuz + `casper.conf`,
    - `isolinux/` (or `boot/grub`) for **BIOS** boot,
    - `EFI/boot/bootx64.efi` + `boot/grub/` for **UEFI** boot (use grub-mkstandalone
      or the shim + grub image from `grub-efi-amd64-bin` / `shim-signed`),
    - `.disk/info`, `.disk/casper-uuid-generic`.
15. Generate the hybrid ISO with `xorriso -as mkisofs` including both the
    BIOS boot image (`-isohybrid-mbr`) and the EFI El Torito image
    (`-eltorito-alt-boot ... -isohybrid-gpt-basdat`). Put it at
    `${OUTPUT_DIR}/${ISO_NAME}`.
16. Write `*.iso.sha256` next to the ISO.
17. `cleanup` on EXIT/INT/TERM must unmount everything and (optionally) keep the
    workspace if `HZ_KEEP_WORKSPACE=1` is set, so it can be debugged.

Keep the `log/warn/error` helpers and the config in `build/config/default-config.sh`.
Make dependency failures fatal.

### 4.2 `build/scripts/chroot-setup.sh` (critical)
Currently installs `ubuntu-minimal`, casper, kernel, `ubuntu-desktop-minimal`,
gdm3, plymouth, calamares - but:
- it does NOT copy or install the HZ packages,
- it does NOT apply branding/settings,
- it does NOT configure casper,
- it hardcodes archive.ubuntu.com (fine, but make mirror configurable).

Make it install everything needed for a working live desktop and the installer,
then apply branding and settings.

### 4.3 Calamares configuration (critical - must be validated)
- Verify module names in `installer/calamares/settings.conf` against the
  Calamares version in Ubuntu 24.04. Remove/replace modules that do not exist
  (common mismatches: `machineid`, `localecfg`, `initcpiocfg`, `initcpio`,
  `luksbootkeyfile`, `luksopenswaphookcfg`, `postcfg`, `displaymanager`).
  `calamares` on noble ships a known `settings.conf` at
  `/etc/calamares/settings.conf` - diff against it.
- Ensure module config files are placed in `/etc/calamares/modules/` with the
  names Calamares expects, and that `branding: happyzero` resolves to
  `/etc/calamares/branding/happyzero/`.
- `installer/calamares/modules/unpackfs.conf` must point its source at the live
  squashfs and its destination at `/`, so the installer unpacks the HZ system.
- `installer/calamares/modules/packages.conf` must not try to install packages
  that are not reachable; for an offline install prefer the squashfs contents.
- Make the welcome screen work without network and with HZ branding.

### 4.4 Packages
- Each `packages/happy-zero-*/debian/` needs valid `control`, `rules`,
  `changelog`, `compat`, and an `install` file where files are shipped. Some are
  placeholders - make them build cleanly with `dpkg-buildpackage -b -us -uc`.
- `happy-zero-branding` must actually ship the branding files (os-release,
  logos, plymouth, grub, issue, motd) to the right system paths via its
  `debian/install` + `debian/rules`.
- `happy-zero-settings` must ship dconf + gsettings overrides.
- `happy-zero-desktop-meta` is a metapackage (already lists apps) - verify all
  dependencies exist in noble; remove anything that does not (e.g. confirm
  `ubuntu-restricted-extras`, `vlc`, `flatpak` are available).
- `happy-zero-keyring` should not break the build; either ship a real keyring or
  keep it a no-op that installs cleanly.

### 4.5 Tests and docs
- `tests/smoke-test.sh` has a `set -euo pipefail` issue: a failing `test`
  inside a `&&` list can abort the script. Make it robust (use `if` or
  `|| true`, avoid `set -e` surprises) and add checks for the new pipeline.
- Update `docs/build-guide.md`, `README.md`, `docs/phase4-finalization.md` to
  match reality once the pipeline works (remove "coming in Phase 3" / false
  "all phases complete" claims).
- Keep documentation in English and German where it already exists.

---

## 5. Hard requirements and constraints

- **Trademark compliance:** No "Ubuntu" trademark in user-facing output (boot
  menu, Plymouth, installer, os-release, motd, logos). Ubuntu package repos may
  still be used. See `docs/trademark-license.md`.
- **Open source only.** No proprietary blobs except what the Ubuntu archive
  already provides. License stays MIT for repo code.
- **No emojis** anywhere in code, docs, or UI strings.
- **No inline code comments** - the project convention is self-documenting code.
  (Keep existing top-of-file section comments if present, but do not add
  explanatory inline comments.)
- **Style:** bash with `set -euo pipefail`; functions; `log/warn/error` helpers;
  quote all variables; use `$SCRIPT_DIR`-relative paths.
- **Reproducible:** the same script must work on a clean Ubuntu 24.04 install.
- **Idempotent cleanup:** never leave filesystems mounted if a stage fails.
- **Output paths and names must not change:** ISO is
  `out/happy-zero-1.0-noble-zero-amd64.iso`.

---

## 6. Definition of done (acceptance checklist)

- [ ] `sudo ./build/scripts/build-hz.sh` completes with exit code 0 on a clean
      VM and leaves no mounted filesystems in `/proc/mounts`.
- [ ] `out/happy-zero-1.0-noble-zero-amd64.iso` exists and is > ~2 GB.
- [ ] `out/happy-zero-1.0-noble-zero-amd64.iso.sha256` verifies.
- [ ] `file` on the ISO reports a bootable ISO 9660 image; it is hybrid
      (bootable via BIOS and UEFI).
- [ ] Boots in QEMU/BIOS:
      `qemu-system-x86_64 -m 4G -cdrom out/*.iso -boot d`
- [ ] Boots in QEMU/UEFI:
      `qemu-system-x86_64 -m 4G -bios /usr/share/OVMF/OVMF_CODE.fd -cdrom out/*.iso -boot d`
- [ ] GRUB menu shows the HZ labels from `build/config/default-config.sh`.
- [ ] Live session reaches GNOME desktop with HZ branding; no Ubuntu trademarks
      visible.
- [ ] Calamares launches with HZ branding and completes an install into a disk
      image/VM.
- [ ] Installed system boots; `cat /etc/os-release` shows `Happy Zero`.
- [ ] `tests/smoke-test.sh` passes.
- [ ] `docs/build-guide.md` and `README.md` reflect the real, working process.

---

## 7. Working method for the agent

1. Read every script and config before editing. List concrete defects.
2. Implement in small, testable stages. After each stage, if feasible, run it
   and inspect the workspace (`/tmp/hz-workspace`).
3. Prefer debugging with `HZ_KEEP_WORKSPACE=1` so the chroot/image tree stays.
4. Build the ISO, then boot it in QEMU (BIOS + UEFI) and fix what breaks.
5. Only when the ISO really boots and installs, update the docs.
6. Report a short summary: what changed, what was verified, what remains.

Do not claim success unless the checklist in section 6 is actually satisfied.
If something cannot be verified in this environment, say so explicitly.
