# Happy Zero Install Guide (English)

## System Requirements

- 64-bit x86_64 processor (2GHz dual-core or better recommended)
- 4 GB RAM (8 GB recommended)
- 25 GB free disk space (50 GB recommended)
- Internet connection for updates (optional)
- USB drive (4 GB minimum) for installation media

## Getting Started

### 1. Create Installation Media

Download the Happy Zero ISO and write to USB using [Balena Etcher](https://etcher.balena.io/) or `dd` (see Build Guide).

### 2. Boot from USB

1. Insert USB drive into target computer
2. Boot/restart and enter BIOS/UEFI boot menu (usually F12, F2, ESC, or DEL)
3. Select USB drive as boot device
4. Select "Try Happy Zero without installing" or "Install Happy Zero"

### 3. Try or Install

- **Try Happy Zero**: Boot into live environment without making changes to disk
- **Install Happy Zero**: Launch Calamares installer to install permanently

## Installation with Calamares

### Welcome
- Select language and location
- Review release notes if desired

### Keyboard
- Detect keyboard layout automatically or select manually
- Test keyboard input

### Partitions
Choose installation type:
1. **Erase disk** - Install Happy Zero on entire disk (recommended for new installs)
2. **Replace partition** - Replace existing partition with Happy Zero
3. **Manual partitioning** - Advanced users, full control over partitions
4. **Install alongside** - Dual-boot with existing OS (if detected)

For UEFI systems, EFI System Partition (ESP) is required. Calamares will handle this automatically for guided installs.

### Users
- Create primary user account (username, full name, password)
- Set hostname for system
- Choose automatic login option if desired
- Optionally enable root account (not recommended)

### Summary
Review installation settings before proceeding.

### Install
Installation will proceed. This may take 10-30 minutes depending on hardware.

### Finish
- Remove installation media when prompted
- Restart system

## Post-Installation

### First Boot
After reboot, you'll boot into Happy Zero. If you created a user, log in with your credentials.

### Welcome App (First Run)
The "Welcome to Happy Zero" app will launch on first boot, offering:
- Check for system updates
- Install hardware drivers (NVIDIA/AMD)
- Set up Flatpak and Flathub
- Install multimedia codecs
- Theme and accent color customization
- Useful links and documentation

### Updates
Check for updates regularly:
```bash
sudo apt update && sudo apt upgrade
```

Or use Software Center.

### Security
UFW firewall is enabled by default. AppArmor provides additional application sandboxing.

## Troubleshooting

| Issue | Solution |
|---|---|
| Wi-Fi not working | Check drivers; Welcome app can help install proprietary drivers |
| NVIDIA drivers | Use "Additional Drivers" or Welcome app driver installer |
| Dual-boot issues | Ensure EFI/bootloader properly configured; may need to adjust BIOS boot order |
| Display issues | Try kernel parameter `nomodeset` or update graphics drivers |

## Getting Help

- Documentation: https://happyzero.org
- Support: https://happyzero.org/support
- Bug Reports: https://github.com/happyzero/happy-zero/issues
