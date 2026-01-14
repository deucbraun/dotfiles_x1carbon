#!/bin/bash
echo "🕐 Dotfiles Auto-Update & GitHub Sync Status"
echo "============================================"

cd ~/dotfiles

echo "📊 Timer Status:"
systemctl --user is-active --quiet dotfiles-update.timer && echo "✅ Timer ACTIVE" || echo "❌ Timer INACTIVE"
systemctl --user is-enabled --quiet dotfiles-update.timer && echo "✅ Timer ENABLED" || echo "❌ Timer DISABLED"

echo -e "\n⏰ Next Scheduled Run:"
systemctl --user list-timers dotfiles-update.timer --no-pager | tail -1

echo -e "\n🌐 GitHub Status:"
if git remote get-url origin &>/dev/null; then
    echo "✅ Remote configured: $(git remote get-url origin)"
    
    # Check if there are unpushed commits
    if git log origin/main..HEAD --oneline 2>/dev/null | grep -q .; then
        echo "⚠️  Unpushed commits: $(git log origin/main..HEAD --oneline | wc -l)"
    else
        echo "✅ All commits pushed to GitHub"
    fi
    
    # Check credential configuration
    if [[ -f ~/.git-credentials ]]; then
        echo "✅ Token authentication configured"
    else
        echo "⚠️  No token file found"
    fi
else
    echo "❌ No remote repository configured"
fi

echo -e "\n📅 Last 3 Service Runs:"
journalctl --user -u dotfiles-update.service --lines=3 --no-pager --output=short-iso

echo -e "\n📋 Recent Commits:"
git log --oneline -3

echo -e "\n🔗 Repository: https://github.com/PewB/dotfiles_x1carbon"

echo -e "\n💡 Commands:"
echo "  Manual run:    dotfiles-run"
echo "  View logs:     dotfiles-logs"
echo "  Check GitHub:  https://github.com/PewB/dotfiles_x1carbon"
