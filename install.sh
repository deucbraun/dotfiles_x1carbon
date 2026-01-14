#!/bin/bash
# install.sh - Setup dotfiles on new system
# Usage: ./install.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Main installation function
main() {
    echo -e "${GREEN}"
    echo "🚀 Installing Hyprland Dotfiles"
    echo "================================"
    echo -e "${NC}"

    # Check if we're in the dotfiles directory
    if [[ ! -f "install.sh" ]] || [[ ! -d "hyprland" ]]; then
        log_error "Please run this script from the dotfiles directory"
        log_info "Usage: cd ~/dotfiles && ./install.sh"
        exit 1
    fi

    # Install dependencies
    log_info "Checking dependencies..."
    
    if ! command -v stow &> /dev/null; then
        log_info "Installing GNU Stow..."
        if command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm stow
        elif command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y stow
        else
            log_error "Please install GNU Stow manually"
            exit 1
        fi
        log_success "GNU Stow installed"
    else
        log_success "GNU Stow already installed"
    fi

    # Create backup of existing configs
    if [[ -d ~/.config/hypr ]] || [[ -f ~/.bashrc ]] || [[ -f ~/.zshrc ]]; then
        BACKUP_DIR=~/dotfiles-backup-$(date +%Y%m%d-%H%M%S)
        log_warning "Existing configs found. Creating backup..."
        mkdir -p "$BACKUP_DIR"
        
        # Backup existing configs
        [[ -d ~/.config/hypr ]] && cp -r ~/.config/hypr "$BACKUP_DIR/" 2>/dev/null
        [[ -d ~/.config/waybar ]] && cp -r ~/.config/waybar "$BACKUP_DIR/" 2>/dev/null
        [[ -d ~/.config/dunst ]] && cp -r ~/.config/dunst "$BACKUP_DIR/" 2>/dev/null
        [[ -f ~/.bashrc ]] && cp ~/.bashrc "$BACKUP_DIR/" 2>/dev/null
        [[ -f ~/.zshrc ]] && cp ~/.zshrc "$BACKUP_DIR/" 2>/dev/null
        [[ -f ~/.p10k.zsh ]] && cp ~/.p10k.zsh "$BACKUP_DIR/" 2>/dev/null
        
        log_success "Backup created in: $BACKUP_DIR"
    fi

    # Remove existing configs to avoid conflicts
    log_info "Removing existing configs..."
    rm -rf ~/.config/hypr ~/.config/waybar ~/.config/dunst 2>/dev/null || true
    rm -f ~/.bashrc ~/.zshrc ~/.p10k.zsh 2>/dev/null || true

    # Install packages with stow
    log_info "Installing dotfiles packages..."
    
    # Install hyprland package
    if [[ -d "hyprland" ]]; then
        stow hyprland
        log_success "Hyprland package installed"
    else
        log_warning "Hyprland package not found"
    fi

    # Install shell package
    if [[ -d "shell" ]]; then
        stow shell
        log_success "Shell package installed"
    else
        log_warning "Shell package not found"
    fi

    # Install terminal package (optional)
    if [[ -d "terminal" ]]; then
        stow terminal
        log_success "Terminal package installed"
    else
        log_info "Terminal package not found (optional)"
    fi

    # Verify installation
    log_info "Verifying installation..."
    
    verify_symlink() {
        if [[ -L "$1" ]]; then
            log_success "✓ $1 → $(readlink "$1")"
        else
            log_warning "✗ $1 (not a symlink)"
        fi
    }

    verify_symlink ~/.config/hypr
    verify_symlink ~/.config/waybar
    verify_symlink ~/.bashrc
    verify_symlink ~/.zshrc

    # Set proper permissions for scripts
    if [[ -d ~/.config/hypr/scripts ]]; then
        chmod +x ~/.config/hypr/scripts/* 2>/dev/null || true
        log_success "Script permissions set"
    fi

    # Final instructions
    echo
    echo -e "${GREEN}🎉 Installation completed successfully!${NC}"
    echo
    log_info "Next steps:"
    echo "  1. Restart your terminal session"
    echo "  2. Run 'hyprctl reload' to reload Hyprland config"
    echo "  3. Restart Waybar: 'killall waybar && waybar &'"
    echo
    log_info "To update dotfiles later, run: ./update-dotfiles.sh"
}

# Run main function
main "$@"
