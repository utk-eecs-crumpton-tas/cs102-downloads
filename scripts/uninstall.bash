set -euo pipefail

rm ~/Apps/nvim.appimage
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
rm -rf ~/.oh-my-zsh/
rm ~/.zshrc
if [[ -f ~/.zshrc.pre-oh-my-zsh ]]; then
    mv .zshrc.pre-oh-my-zsh ~/.zshrc
fi
