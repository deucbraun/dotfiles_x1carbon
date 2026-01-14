#!/bin/bash
# Smart update that works with stow-managed configs and syncs to GitHub

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

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

# Main function
main() {
    echo -e "${GREEN}"
    echo "🔄 Smart Dotfiles Update & Sync"
    echo "==============================="
    echo -e "${NC}"

    # Check if we're in dotfiles directory
    if [[ ! -f "install.sh" ]] || [[ ! -d "hyprland" ]]; then
        log_error "Please run from dotfiles directory"
        exit 1
    fi

    # Check if git repository
    if ! git status &>/dev/null; then
        log_error "Not a git repository"
        exit 1
    fi

    # Check GitHub HTTPS connection
    log_info "Testing GitHub HTTPS connection..."
    if curl -s --connect-timeout 5 https://api.github.com/user 2>/dev/null | grep -q "login\|message"; then
        log_success "GitHub connection verified"
    else
        log_warning "GitHub connection failed - will skip remote sync"
        SKIP_REMOTE=true
    fi

    # Check if remote origin exists
    if [[ -z "$SKIP_REMOTE" ]] && ! git remote get-url origin &>/dev/null; then
        log_warning "No remote origin configured - will skip remote sync"
        SKIP_REMOTE=true
    fi

    # Pull latest changes first (if remote available)
    if [[ -z "$SKIP_REMOTE" ]]; then
        log_info "Pulling latest changes from remote..."
        if git pull --rebase origin main 2>/dev/null; then
            log_success "Successfully pulled latest changes"
        else
            log_warning "Failed to pull changes - continuing with local update"
            log_info "Consider checking your Git credentials or network connection"
        fi
    fi

    # Update package lists
    log_info "Updating package lists..."
    if command -v pacman &> /dev/null; then
        pacman -Qqen > packages.txt 2>/dev/null && log_success "Pacman packages updated ($(wc -l < packages.txt) packages)"
        pacman -Qqem > aur-packages.txt 2>/dev/null && log_success "AUR packages updated ($(wc -l < aur-packages.txt) packages)"
    fi

    # Update system info (optional)
    if command -v neofetch &> /dev/null; then
        echo "# Last updated: $(date)" > system-info.txt
        neofetch --stdout >> system-info.txt 2>/dev/null && log_success "System info updated"
    fi

    # Check for any new files in the dotfiles structure
    log_info "Checking for configuration changes..."
    
    # Add any new files that might have been created
    git add .

    # Show current status
    if [[ -n "$(git status --porcelain)" ]]; then
        echo
        log_info "Changes found:"
        git status --short
        echo
        
        # Create detailed commit message
        CHANGED_FILES=$(git diff --staged --name-only)
        PACKAGE_COUNT_MAIN=$(wc -l < packages.txt 2>/dev/null || echo "0")
        PACKAGE_COUNT_AUR=$(wc -l < aur-packages.txt 2>/dev/null || echo "0")
        
        COMMIT_MSG="Auto-update: $(date '+%Y-%m-%d %H:%M')

Configuration changes:
$(echo "$CHANGED_FILES" | sed 's/^/• /')

System info:
• Pacman packages: $PACKAGE_COUNT_MAIN
• AUR packages: $PACKAGE_COUNT_AUR
• Hostname: $(hostname)
• Kernel: $(uname -r)
• Updated from: $(whoami)@$(hostname)"

        git commit -m "$COMMIT_MSG"
        log_success "Changes committed locally!"
        
        # Push to remote if available
        if [[ -z "$SKIP_REMOTE" ]]; then
            log_info "Pushing changes to GitHub..."
            if git push origin main; then
                log_success "Successfully pushed to GitHub! 🚀"
                
                # Show GitHub repository URL
                REPO_URL=$(git remote get-url origin | sed 's/git@github.com:/https:\/\/github.com\//' | sed 's/\.git$//')
                log_info "View changes at: $REPO_URL"
            else
                log_warning "Failed to push to remote repository"
                log_info "You can manually push later with: git push origin main"
            fi
        else
            log_info "Remote sync skipped - changes are committed locally"
        fi
        
        # Show what was changed
        echo
        log_info "Latest changes:"
        git log --oneline -3
        
    else
        log_info "No changes to commit - everything up to date"
        
        # Still try to push if there are unpushed commits
        if [[ -z "$SKIP_REMOTE" ]] && [[ -n "$(git log origin/main..HEAD 2>/dev/null)" ]]; then
            log_info "Found unpushed commits, pushing to GitHub..."
            if git push origin main; then
                log_success "Unpushed commits synchronized to GitHub!"
            fi
        fi
    fi

    # Reload Hyprland if running
    if pgrep -x "Hyprland" > /dev/null; then
        log_info "Reloading Hyprland configuration..."
        hyprctl reload &>/dev/null && log_success "Hyprland reloaded" || log_warning "Failed to reload Hyprland"
    fi

    echo
    echo -e "${GREEN}🎉 Smart update completed successfully!${NC}"
    echo
    log_info "Summary:"
    echo "  • Local changes: $(git log --oneline -1 --pretty=format:'%h - %s')"
    if [[ -z "$SKIP_REMOTE" ]]; then
        echo "  • Remote sync: ✅ Synchronized with GitHub"
        echo "  • Repository: https://github.com/PewB/dotfiles_x1carbon"
    else
        echo "  • Remote sync: ⏭️  Skipped (no connection or not configured)"
    fi
    echo "  • Next auto-update: $(systemctl --user list-timers dotfiles-update.timer --no-legend 2>/dev/null | awk '{print $1, $2}' || echo 'Timer not configured')"
}

main "$@"