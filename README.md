# My Hyprland Dotfiles

Personal configuration for Hyprland on EndeavourOS with automated installation and updates.

## 🎯 Features

- **Wayland-optimized Hyprland setup** with comprehensive configuration
- **Automated installation** with GNU Stow and proper backup handling
- **Smart update system** with GitHub synchronization
- **Modular configuration** for easy customization
- **Modern shell environment** with Zsh, Oh My Zsh, and Powerlevel10k
- **Complete package management** tracking both official and AUR packages

## 📁 Repository Structure

```
dotfiles/
├── hyprland/                 # Hyprland ecosystem configurations
│   ├── .config/hypr/        # Main Hyprland configuration
│   │   ├── hyprland.conf    # Main config file
│   │   ├── configs/         # Modular configuration files
│   │   │   ├── keybinds.conf
│   │   │   ├── autostart.conf
│   │   │   ├── monitors.conf
│   │   │   ├── appearance.conf
│   │   │   ├── input.conf
│   │   │   ├── layouts.conf
│   │   │   ├── windowrules.conf
│   │   │   ├── environment.conf
│   │   │   ├── programs.conf
│   │   │   └── permissions.conf
│   │   └── scripts/         # Custom utility scripts
│   │       ├── wallpaper-rotation.sh
│   │       └── bluetooth-toggle.sh
│   ├── .config/waybar/      # Status bar configuration
│   ├── .config/dunst/       # Notification daemon
│   ├── .config/hyprpaper.conf
│   ├── .config/hypridle.conf
│   └── .config/hyprlock.conf
├── shell/                   # Shell configurations
│   ├── .zshrc              # Zsh with Oh My Zsh & Powerlevel10k
│   ├── .bashrc             # Bash with Starship prompt
│   └── .p10k.zsh           # Powerlevel10k theme configuration
├── terminal/               # Terminal emulator configs
│   └── .config/kitty/      # Kitty terminal with Tokyo Night theme
├── install.sh              # Automated installation script
├── update-dotfiles.sh      # Smart update & sync script
├── timer-status.sh         # Update timer status checker
├── packages.txt            # Official package list (207 packages)
├── aur-packages.txt        # AUR package list (4 packages)
├── .env.example            # Environment variables template
├── .gitignore              # Git exclusion rules
└── README.md              # This documentation
```

## 🚀 Quick Installation

```bash
# Clone the repository
git clone https://github.com/PewB/dotfiles_x1carbon.git ~/dotfiles
cd ~/dotfiles

# Set up environment variables for sensitive credentials
cp .env.example ~/.env
# Edit ~/.env with your actual API keys and passwords
nano ~/.env  # or use your preferred editor
chmod 600 ~/.env

# Run the automated installer
./install.sh

# Enable automatic updates (optional)
systemctl --user enable --now dotfiles-update.timer
```

## 🔧 What Gets Installed

### Desktop Environment
- **Hyprland** - Dynamic tiling Wayland compositor
- **Waybar** - Highly customizable status bar
- **Dunst** - Lightweight notification daemon
- **Wofi** - Application launcher for Wayland

### Terminal & Shell
- **Kitty** - GPU-accelerated terminal emulator
- **Zsh** with Oh My Zsh framework
- **Powerlevel10k** - Feature-rich Zsh theme
- **Starship** - Cross-shell prompt (Bash fallback)

### Development Tools
- **Git** with optimized configuration
- **Visual Studio Code** with Wayland support
- **Claude Code** - AI-powered coding assistant

### System Utilities
- **GNU Stow** - Symlink farm manager
- **exa** - Modern ls replacement with icons
- **bat** - Cat clone with syntax highlighting
- **Bitwarden** - Password manager integration

## 🎨 Key Features

### Hyprland Configuration
- **Modular setup** - Organized into logical configuration files
- **Custom keybindings** - Optimized for productivity
- **Multi-monitor support** - Flexible display configuration
- **Window rules** - Application-specific behaviors
- **Wallpaper rotation** - Automated background changes
- **Bluetooth toggle** - Quick connectivity management

### Shell Environment
- **Rich aliases** - Shortcuts for common commands
- **Wayland integration** - Proper scaling and display support
- **Package management** - Quick install/update/search aliases
- **Git shortcuts** - Streamlined version control workflow
- **Hyprland controls** - Direct compositor management

### Automated Management
- **Smart installation** - Backup existing configs before installation
- **Update system** - Automatic package list updates and Git sync
- **GitHub integration** - Seamless repository synchronization
- **Timer-based updates** - Scheduled maintenance via systemd

## 🛠️ Usage

### Manual Updates
```bash
# Update dotfiles and sync to GitHub
./update-dotfiles.sh

# Check update timer status
dotfiles-status

# View update logs
dotfiles-logs

# Run manual update
dotfiles-run
```

### Timer Management
```bash
# Enable automatic updates
dotfiles-enable

# Disable automatic updates
dotfiles-disable
```

### Development Workflow
```bash
# Quick git operations
gst          # git status
gaa          # git add .
gcm "message" # git commit -m "message"
gp           # git push
gl           # git pull

# Hyprland management
hypr-reload  # Reload Hyprland configuration
screenshot   # Take screenshot with slurp/grim
```

## 🔐 Security Considerations

### Environment Variables Setup
This repository uses environment variables for sensitive credentials. Before using these dotfiles:

1. **Copy the template file:**
   ```bash
   cp .env.example ~/.env
   ```

2. **Edit `~/.env` with your actual credentials:**
   - `ANTHROPIC_API_KEY` - Your Anthropic API key for Claude Code
   - `MQTT_PASSWORD` - Your MQTT server password
   - Other sensitive values as needed

3. **Secure the file:**
   ```bash
   chmod 600 ~/.env
   ```

**Note**: The `.env` file is automatically excluded from version control via `.gitignore`.

### Security Features Implemented
- ✅ **Environment variable management** - All API keys and passwords stored in `~/.env`
- ✅ **Git ignore protection** - Sensitive files excluded from repository
- ✅ **Secure credential storage** - Borg backup passphrase in separate file
- ✅ **Template documentation** - `.env.example` provides clear setup instructions

### Additional Security Notes
- **Git Credentials**: Uses credential.helper=store which saves credentials in plaintext
- **Borg Backup**: Passphrase stored in `~/.config/borg-passphrase` (not in repository)
- **SSH Keys**: Bitwarden SSH agent integration for secure key management

### Future Security Improvements
- [ ] **Enhanced credential management** - Consider using keyring for Git credentials
- [ ] **Input validation** - Add proper validation for script parameters
- [ ] **Audit logging** - Implement logging for security-sensitive operations
- [ ] **Permission hardening** - Review and restrict script permissions

## 📋 System Requirements

### Operating System
- **EndeavourOS** (or Arch Linux based)
- **Wayland** support required

### Dependencies
The installer automatically handles most dependencies, but these are key requirements:
- `stow` - Configuration management
- `git` - Version control
- `curl` - HTTP requests
- `hyprland` - Window manager
- `waybar` - Status bar
- `dunst` - Notifications
- `kitty` - Terminal emulator

## 🔄 Update System

The dotfiles include a sophisticated update system that:

1. **Checks connectivity** to GitHub
2. **Pulls latest changes** from remote repository
3. **Updates package lists** (pacman and AUR)
4. **Tracks system information** 
5. **Commits changes** with detailed messages
6. **Syncs to GitHub** automatically
7. **Reloads Hyprland** if running

### Update Schedule
- **Timer-based**: Configurable via systemd timer
- **Manual**: Run `./update-dotfiles.sh` anytime
- **Automatic**: Enable with `dotfiles-enable`

## 🧪 Testing

After installation, verify everything works:

```bash
# Test shell environment
echo $SHELL
which zsh

# Test Hyprland
hyprctl version
hyprctl reload

# Test applications
code --version
kitty --version
```

## 🚨 Troubleshooting

### Common Issues

**Installation fails with stow conflicts:**
```bash
# Remove existing configs and retry
rm -rf ~/.config/hypr ~/.config/waybar ~/.config/dunst
./install.sh
```

**Git sync fails:**
```bash
# Check Git configuration
git config --list
# Verify GitHub credentials
git remote -v
```

**Hyprland doesn't start:**
```bash
# Check logs
journalctl -u display-manager
# Verify installation
hyprland --version
```

## 📝 Customization

### Adding New Configurations
1. Create new files in appropriate directories
2. Update the stow structure if needed
3. Run `./install.sh` to create symlinks
4. Commit changes with `./update-dotfiles.sh`

### Modifying Existing Configs
1. Edit files in the dotfiles directory
2. Changes are automatically reflected (symlinked)
3. Run `./update-dotfiles.sh` to sync changes

## 🤝 Contributing

Feel free to fork this repository and adapt it to your needs. If you find improvements or fixes, pull requests are welcome!

## 📄 License

This configuration is personal and provided as-is. Use at your own discretion.

---

**Last Updated**: Auto-generated by update system  
**System**: EndeavourOS with Hyprland  
**Maintainer**: Personal dotfiles configuration
