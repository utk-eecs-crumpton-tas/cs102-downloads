set -euo pipefail

# Uninstall Neovim
rm -f ~/Apps/nvim.appimage
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim

# Uninstall Oh My Zsh
rm -rf ~/.oh-my-zsh/
rm -f ~/.zshrc
if [[ -f ~/.zshrc.pre-oh-my-zsh ]]; then
    mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc
fi

# Reload shell
exec zsh
