#!/bin/bash

# Funktion um zu prüfen ob Monitor verfügbar ist
monitor_exists() {
    hyprctl monitors | grep -q "Monitor $1"
}

# Prüfe ob Docking Station angeschlossen (beide externe Monitore verfügbar)
if monitor_exists "DP-5" && monitor_exists "DP-4"; then
    echo "Docking Station erkannt - Setup für 3 Monitore"
    
    # Samsung Odyssey G80SD (DP-5) als primär in der Mitte - höchste Auflösung
    hyprctl keyword monitor "DP-5,3840x2160@60,2048x0,1.00"
    
    # Laptop Display (eDP-1) links neben Samsung
    hyprctl keyword monitor "eDP-1,2560x1440@60,0x0,1.25"
    
    # LG Ultra HD (DP-4) rechts neben Samsung - PIVOTIERT (90° gedreht) - höchste Auflösung
    # Transform 1 = 90° im Uhrzeigersinn, Transform 3 = 90° gegen Uhrzeigersinn
    hyprctl keyword monitor "DP-4,3840x2160@60,5888x0,1.50,transform,1"
    
    # Workspaces auf primären Monitor (DP-5) setzen
    for i in {1..5}; do
        hyprctl dispatch moveworkspacetomonitor "$i" "DP-5"
    done
    
    # Focus auf primären Monitor
    hyprctl dispatch focusmonitor "DP-5"
    
    echo "3-Monitor Setup aktiviert: Laptop(links) + Samsung(Mitte/primär) + LG(rechts/pivotiert)"
    
else
    echo "Docking Station nicht angeschlossen - Laptop Display primär"
    
    # Nur Laptop Display aktiv
    hyprctl keyword monitor "eDP-1,2560x1440@60,0x0,1.25"
    
    # Externe Monitore deaktivieren falls noch aktiv
    hyprctl keyword monitor "DP-4,disable" 2>/dev/null || true
    hyprctl keyword monitor "DP-5,disable" 2>/dev/null || true
    
    # Alle Workspaces auf Laptop Display
    for i in {1..5}; do
        hyprctl dispatch moveworkspacetomonitor "$i" "eDP-1"
    done
    
    # Focus auf Laptop Display
    hyprctl dispatch focusmonitor "eDP-1"
    
    echo "Laptop-Only Setup aktiviert"
fi
