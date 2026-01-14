#!/bin/bash

# Funktion für Event-Handling
handle() {
    case $1 in
        monitoradded* | monitorremoved*)
            echo "Monitor event detected: $1"
            sleep 1  # Kurz warten damit Hardware stabilisiert
            ~/.config/hypr/scripts/monitor-management.sh
            ;;
    esac
}

# Hyprland Socket Events abonnieren
if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do 
        handle "$line"
    done
else
    echo "Fehler: HYPRLAND_INSTANCE_SIGNATURE nicht gefunden"
    exit 1
fi
