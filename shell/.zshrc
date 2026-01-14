# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set theme to Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    colored-man-pages
    history
    sudo
    extract
)

source $ZSH/oh-my-zsh.sh


ZSH_HIGHLIGHT_STYLES[comment]='fg=cyan,bold'

# Color support
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Better alternatives with colors and icons
alias cat='bat'
alias ls='exa --icons'
alias ll='exa -la --icons'
alias tree='exa --tree --icons'

# Additional useful exa aliases
alias la='exa -la --icons'
alias l='exa -l --icons'
alias lt='exa --tree --icons --level=2'
alias ltr='exa --tree --icons --level=3'

# Bitwarden cleanup
alias bitwardencleanup='rm -rf ~/.config/Bitwarden/'

# Hyprland environment variables
export MOZ_ENABLE_WAYLAND=1
export GDK_SCALE=1.25
export QT_SCALE_FACTOR=1.25
export XCURSOR_SIZE=24
export HYPRCURSOR_SIZE=24

export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
export PATH=$PATH:~/tizen-studio/tools

# System management (Arch/EndeavourOS)
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias search='pacman -Ss'
alias remove='sudo pacman -Rs'

# Git shortcuts
alias gst='git status'
alias gaa='git add .'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git pull'

# Hyprland specific
alias hypr-reload='hyprctl reload'
alias screenshot='grim -g "$(slurp)" - | wl-copy'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# System aliases
alias shutdown='shutdown -h 0'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load environment variables from ~/.env (contains sensitive API keys and passwords)
if [[ -f "$HOME/.env" ]]; then
    source "$HOME/.env"
fi

# Dotfiles Auto-Update Management
alias dotfiles-status='~/dotfiles/timer-status.sh'
alias dotfiles-logs='journalctl --user -u dotfiles-update.service -f'
alias dotfiles-run='systemctl --user start dotfiles-update.service'
alias dotfiles-enable='systemctl --user enable --now dotfiles-update.timer'
alias dotfiles-disable='systemctl --user disable --now dotfiles-update.timer'

# Borg Backup Aliase
alias borg-status='systemctl --user status borg-backup.timer'
alias borg-logs='journalctl --user -u borg-backup.service -f'
alias borg-run='systemctl --user start borg-backup.service'
alias borg-list='BORG_REPO="ssh://hetzner-backup/./backups/x1carbon" BORG_PASSPHRASE="$(cat ~/.config/borg-passphrase)" borg list "$BORG_REPO"'
alias borg-info='BORG_REPO="ssh://hetzner-backup/./backups/x1carbon" BORG_PASSPHRASE="$(cat ~/.config/borg-passphrase)" borg info "$BORG_REPO"'

# System Documentation Aliases
alias doc-log='~/system-docs/scripts/log-change.sh'
alias doc-service='~/system-docs/scripts/document-service.sh'
alias doc-inventory='~/system-docs/scripts/system-inventory.sh'
alias doc-full='~/system-docs/scripts/full-inventory.sh'
alias doc-status='cd ~/system-docs && git status'
alias doc-history='cd ~/system-docs && git log --oneline -10'
alias doc-cd='cd ~/system-docs'

alias moonlight='QT_SCALE_FACTOR=1 moonlight --platform wayland'
alias mqttui-local='mqttui -b mqtt://${MQTT_HOST:-192.168.40.2}:${MQTT_PORT:-1883} -u ${MQTT_USER:-admin} --password ${MQTT_PASSWORD}'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# IBKR TWS für Hyprland
    export _JAVA_AWT_WM_NONREPARENTING=1
