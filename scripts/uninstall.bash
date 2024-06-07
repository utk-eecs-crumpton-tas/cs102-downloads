set -euo pipefail

uninstall() {
    # Uninstall Neovim
    echo 'Removing Neovim...'
    rm -f ~/Apps/nvim.appimage
    rm -rf ~/.config/nvim
    rm -rf ~/.local/share/nvim
    rm -rf ~/.cache/nvim

    # Uninstall Oh My Zsh
    echo 'Removing Oh My Zsh...'
    rm -rf ~/.oh-my-zsh/
    rm -f ~/.zshrc
    if [[ -f ~/.zshrc.pre-oh-my-zsh ]]; then
        echo 'Restoring previous .zshrc...'
        mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc
    fi

    # Reload shell
    exec zsh
}

uninstall
