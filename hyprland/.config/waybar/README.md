# Waybar Configuration

Eine moderne, minimalistische Waybar-Konfiguration für Hyprland mit pastel-dunklem Design.

## Überblick

Diese Konfiguration erstellt eine elegante Top-Bar mit allen wichtigen System-Informationen und einem konsistenten Design-Schema.

## Module

### Links (modules-left)
- **hyprland/workspaces**: Zeigt Arbeitsbereiche 1-5 mit visuellen Indikatoren
- **hyprland/window**: Aktueller Fenstertitel (max. 50 Zeichen)

### Mitte (modules-center)
- **clock**: Uhrzeit und Datum im Format HH:MM DD.MM.YYYY

### Rechts (modules-right)
- **tray**: System-Tray mit Icons (Größe 21px)
- **idle_inhibitor**: Bildschirmsperre-Status 🔒/🔓
- **bluetooth**: Bluetooth-Status mit Geräte-Info
- **backlight**: Bildschirmhelligkeit 🔅/🔆
- **pulseaudio**: Lautstärke mit verschiedenen Ausgabegerät-Icons
- **battery**: Batteriestatus mit Ladezustand und Icons

## Design-Features

### Farbschema
- **Primär**: Dunkler Pastel-Blau (rgba(45, 50, 70, 0.9))
- **Aktiver Workspace**: Neon-Grün (#00ff99)
- **Text**: Helles Grau (#f8f8f2)
- **Akzente**: Dracula-inspirierte Farben

### Workspace-Styling
- **Aktiv**: Neon-grün hervorgehoben
- **Belegt**: Subtiler Hintergrund
- **Hover**: Blaue Akzentfarbe
- **Urgent**: Rote Warnung mit Glow-Effekt

## Interaktive Funktionen

### Bluetooth
- **Linksklick**: Öffnet Blueman-Manager
- **Rechtsklick**: Bluetooth Toggle-Script

### Backlight
- **Scroll hoch**: Helligkeit +5%
- **Scroll runter**: Helligkeit -5%

### Pulseaudio
- **Klick**: Öffnet Pavucontrol

## Konfigurationsdateien

- `config`: Haupt-Konfigurationsdatei mit Modul-Definitionen
- `style.css`: CSS-Styling für visuelles Design
- `scripts/`: Zusätzliche Scripts (falls vorhanden)

## Abhängigkeiten

- **Waybar**: Status-Bar für Wayland
- **Hyprland**: Wayland-Compositor
- **brightnessctl**: Helligkeit-Steuerung
- **pavucontrol**: Audio-Kontrolle
- **blueman-manager**: Bluetooth-Verwaltung

## Anpassung

### Farben ändern
Alternative Farbschemata sind in `style.css` auskommentiert verfügbar:
- Dunkler Pastel-Lila
- Dunkler Pastel-Grün  
- Dunkler Pastel-Braun

### Module hinzufügen
Neue Module können in der `config`-Datei zu den entsprechenden Bereichen hinzugefügt werden.

## Tipps

- Workspace-Zahlen werden als einfache Ziffern angezeigt
- Tooltips bieten zusätzliche Informationen bei Hover
- Alle Icons sind Emoji-basiert für konsistente Darstellung
- Batteriezustände werden mit verschiedenen Icons dargestellt