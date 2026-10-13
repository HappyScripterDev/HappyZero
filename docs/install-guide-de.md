# Happy Zero Installationsanleitung (Deutsch)

## Systemvoraussetzungen

- 64-Bit x86_64 Prozessor (2GHz Dual-Core oder besser empfohlen)
- 4 GB RAM (8 GB empfohlen)
- 25 GB freier Festplattenspeicher (50 GB empfohlen)
- Internetverbindung für Updates (optional)
- USB-Stick (mind. 4 GB) für Installationsmedium

## Erste Schritte

### 1. Installationsmedium erstellen

Laden Sie das Happy Zero ISO herunter und schreiben Sie es mit [Balena Etcher](https://etcher.balena.io/) oder `dd` auf einen USB-Stick (siehe Build Guide).

### 2. Vom USB-Stick booten

1. USB-Stick in den Zielrechner einstecken
2. Neustarten und Boot-Menü aufrufen (F12, F2, ESC oder DEL je nach Hersteller)
3. USB-Stick als Boot-Gerät auswählen
4. "Try Happy Zero without installing" oder "Install Happy Zero" auswählen

### 3. Ausprobieren oder Installieren

- **Try Happy Zero**: Live-System ohne Änderungen an der Festplatte starten
- **Install Happy Zero**: Calamares-Installer zum permanenten Installieren starten

## Installation mit Calamares

### Willkommen
- Sprache und Region auswählen
- Release Notes bei Bedarf lesen

### Tastatur
- Tastaturlayout automatisch erkennen oder manuell auswählen
- Tastatureingabe testen

### Partitionierung
Installationsart wählen:
1. **Festplatte löschen** - Happy Zero komplett installieren (empfohlen für Neuinstallationen)
2. **Partition ersetzen** - Bestehende Partition durch Happy Zero ersetzen
3. **Manuelle Partitionierung** - Für fortgeschrittene Benutzer
4. **Neben bestehendem System installieren** - Dual-Boot (falls erkannt)

Bei UEFI-Systemen ist eine EFI-Systempartition erforderlich. Calamares erstellt diese automatisch bei geführter Installation.

### Benutzer
- Primären Benutzeraccount erstellen (Benutzername, vollständiger Name, Passwort)
- Hostname festlegen
- Automatischen Login wählen (optional)
- Root-Account aktivieren (nicht empfohlen)

### Zusammenfassung
Installationseinstellungen vor dem Start überprüfen

### Installation
Installation läuft. Dauer je nach Hardware 10-30 Minuten.

### Fertig
- Installationsmedium entfernen wenn aufgefordert
- System neu starten

## Nach der Installation

### Erster Start
Nach Neustart Happy Zero starten und mit Zugangsdaten anmelden.

### Willkommens-App (Erststart)
Die "Welcome to Happy Zero" App wird beim ersten Start geöffnet und bietet:
- Systemupdates prüfen
- Hardwaretreiber installieren (NVIDIA/AMD)
- Flatpak und Flathub einrichten
- Multimediacodecs installieren
- Theme und Akzentfarbe anpassen
- Nützliche Links und Dokumentation

### Updates
Regelmäßig Updates durchführen:
```bash
sudo apt update && sudo apt upgrade
```

Oder über Software Center.

### Sicherheit
UFW-Firewall ist standardmäßig aktiviert. AppArmor bietet zusätzlichen Anwendungsschutz.

## Hilfe & Support

- Dokumentation: https://happyzero.org
- Support: https://happyzero.org/support
- Fehlerberichte: https://github.com/happyzero/happy-zero/issues
