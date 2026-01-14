#!/bin/bash

# Wallpaper Rotation Script for Hyprpaper
# Save this as: ~/.config/hypr/scripts/wallpaper-rotation.sh
# Make executable: chmod +x ~/.config/hypr/scripts/wallpaper-rotation.sh

# Configuration
WALLPAPER_DIR="$HOME/Bilder/Wallpapers"
MONITOR="eDP-1"  # Your monitor from system info
ROTATION_INTERVAL=1800  # 30 minutes in seconds (1800)
LOG_FILE="$HOME/.config/hypr/wallpaper-rotation.log"

# Supported image formats
FORMATS=("jpg" "jpeg" "png" "webp" "bmp")

# Create wallpaper directory if it doesn't exist
mkdir -p "$WALLPAPER_DIR"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
    echo "$1"
}

# Function to get random wallpaper
get_random_wallpaper() {
    local wallpapers=()
    
    # Find all supported image files
    for format in "${FORMATS[@]}"; do
        while IFS= read -r -d '' file; do
            wallpapers+=("$file")
        done < <(find "$WALLPAPER_DIR" -type f -iname "*.${format}" -print0)
    done
    
    if [ ${#wallpapers[@]} -eq 0 ]; then
        log_message "ERROR: No wallpapers found in $WALLPAPER_DIR"
        return 1
    fi
    
    # Select random wallpaper
    local random_index=$((RANDOM % ${#wallpapers[@]}))
    echo "${wallpapers[$random_index]}"
}

# Function to set wallpaper
set_wallpaper() {
    local wallpaper="$1"
    
    if [ ! -f "$wallpaper" ]; then
        log_message "ERROR: Wallpaper file not found: $wallpaper"
        return 1
    fi
    
    # Preload the wallpaper first
    if hyprctl hyprpaper preload "$wallpaper" 2>/dev/null; then
        log_message "Preloaded: $wallpaper"
        
        # Set the wallpaper
        if hyprctl hyprpaper wallpaper "$MONITOR,$wallpaper" 2>/dev/null; then
            log_message "Set wallpaper: $(basename "$wallpaper")"
            return 0
        else
            log_message "ERROR: Failed to set wallpaper: $wallpaper"
            return 1
        fi
    else
        log_message "ERROR: Failed to preload wallpaper: $wallpaper"
        return 1
    fi
}

# Function to cleanup old preloaded wallpapers (optional)
cleanup_wallpapers() {
    # This helps prevent memory buildup from too many preloaded wallpapers
    # You can adjust this based on your needs
    local current_wallpapers
    current_wallpapers=$(hyprctl hyprpaper listloaded 2>/dev/null | wc -l)
    
    if [ "$current_wallpapers" -gt 10 ]; then
        log_message "Cleaning up preloaded wallpapers (currently: $current_wallpapers)"
        # You might want to implement specific cleanup logic here
    fi
}

# Function to handle script termination
cleanup_and_exit() {
    log_message "Wallpaper rotation script terminated"
    exit 0
}

# Set up signal handlers
trap cleanup_and_exit SIGTERM SIGINT

# Main function
main() {
    log_message "Starting wallpaper rotation script"
    log_message "Wallpaper directory: $WALLPAPER_DIR"
    log_message "Monitor: $MONITOR"
    log_message "Rotation interval: $ROTATION_INTERVAL seconds"
    
    # Check if hyprpaper is running
    if ! pgrep -x "hyprpaper" > /dev/null; then
        log_message "ERROR: hyprpaper is not running!"
        exit 1
    fi
    
    # Set initial wallpaper
    local initial_wallpaper
    initial_wallpaper=$(get_random_wallpaper)
    if [ $? -eq 0 ] && [ -n "$initial_wallpaper" ]; then
        set_wallpaper "$initial_wallpaper"
    else
        log_message "ERROR: Could not set initial wallpaper"
        exit 1
    fi
    
    # Main rotation loop
    while true; do
        sleep "$ROTATION_INTERVAL"
        
        # Check if hyprpaper is still running
        if ! pgrep -x "hyprpaper" > /dev/null; then
            log_message "ERROR: hyprpaper is no longer running, exiting"
            exit 1
        fi
        
        # Get and set new wallpaper
        local new_wallpaper
        new_wallpaper=$(get_random_wallpaper)
        if [ $? -eq 0 ] && [ -n "$new_wallpaper" ]; then
            set_wallpaper "$new_wallpaper"
            cleanup_wallpapers
        else
            log_message "ERROR: Could not get new wallpaper"
        fi
    done
}

# Handle command line arguments
case "${1:-}" in
    "next")
        log_message "Manual wallpaper change requested"
        new_wallpaper=$(get_random_wallpaper)
        if [ $? -eq 0 ] && [ -n "$new_wallpaper" ]; then
            set_wallpaper "$new_wallpaper"
        fi
        ;;
    "stop")
        log_message "Stopping wallpaper rotation"
        pkill -f "wallpaper-rotation.sh"
        ;;
    "status")
        if pgrep -f "wallpaper-rotation.sh" > /dev/null; then
            echo "Wallpaper rotation is running"
        else
            echo "Wallpaper rotation is not running"
        fi
        ;;
    *)
        main
        ;;
esac
