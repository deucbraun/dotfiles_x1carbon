#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
eval "$(starship init bash)" 
alias cat='bat'
alias ls='exa --icons'
alias ll='exa -la --icons'
alias tree='exa --tree --icons'
alias code='code --enable-features=UseOzonePlatform --ozone-platform=wayland --force-device-scale-factor=1.25 2>/dev/null'