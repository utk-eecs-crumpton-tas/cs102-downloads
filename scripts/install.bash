#!/bin/bash

DARK_RED='\e[38;5;1m'
DARK_GREEN='\e[38;5;2m'
DARK_BLUE='\e[38;5;4m'
DARK_MAGENTA='\e[38;5;5m'
# DARK_BLACK='\e[38;5;0m'
DARK_YELLOW='\e[38;5;3m'
# DARK_CYAN='\e[38;5;6m'
# DARK_WHITE='\e[38;5;7m'

# BOLD='\e[1m'
# ITALIC='\e[3m'
RESET='\e[0m'

ZSHRC=~/.zshrc
APPS_DIR=~/Apps
NVIM_APPIMAGE=$APPS_DIR/nvim.appimage

print_success() {
    local message="$@"
    echo -e "${DARK_GREEN}Success${RESET}: $message"
}

print_error() {
    local message="$@"
    echo -e "${DARK_RED}Error${RESET}: $message" >&2

}

print_install_log() {
    local message="$@"
    echo -e "${DARK_BLUE}Installing${RESET}: $message"
}

print_skipping_log() {
    local message="$@"
    echo -e "${DARK_YELLOW}Skipping${RESET}: $message"
}

install_omz() {
    local omz_dir=~/.oh-my-zsh
    local omz_plugins="$omz_dir/custom/plugins"

    print_install_log 'Oh My Zsh'

    if [[ -d "$omz_dir" ]]; then
        print_skipping_log '~/.oh-my-zsh already exists'
        return
    fi

    if ! curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh; then
        print_error 'Oh My Zsh install failed'
        exit 1
    fi

    print_success 'Oh My Zsh installed'

    echo
    print_install_log 'Oh My Zsh plugins'

    if ! git clone https://github.com/tamcore/autoupdate-oh-my-zsh-plugins.git "$omz_plugins/autoupdate"; then
        print_error 'Cloning zsh-autoupdate failed'
        exit 1
    fi

    if ! git clone https://github.com/zsh-users/zsh-autosuggestions.git "$omz_plugins/zsh-autosuggestions"; then
        print_error 'Cloning zsh-autosuggestions failed'
        exit 1
    fi

    if ! git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$omz_plugins/zsh-syntax-highlighting"; then
        print_error 'Cloning zsh-syntax-highlighting failed'
        exit 1
    fi

    if ! sed -i 's/plugins=(\(.*\))/plugins=(\1 autoupdate zsh-autosuggestions zsh-syntax-highlighting)/' "$ZSHRC"; then
        print_error 'Adding omz plugins to .zshrc failed'
        exit 1
    fi

    print_success 'Zsh plugins installed'
}

install_nvim_appimage() {
    local nvim_alias="alias nvim='~/Apps/nvim.appimage'"

    echo
    print_install_log 'Neovim'

    if ! mkdir -p "$APPS_DIR"; then
        print_error 'Creating ~/Apps failed'
        exit 1
    fi

    if ! curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o ~/Apps/nvim.appimage; then
        print_error 'Downloading nvim.appimage failed'
        exit 1
    fi

    if ! chmod u+x "$NVIM_APPIMAGE"; then
        print_error 'Making nvim.appimage executable failed'
        exit 1
    fi

    if grep -q "$nvim_alias" "$ZSHRC"; then
        print_skipping_log 'nvim alias already exists in ~/.zshrc'
        return
    fi

    if ! echo "alias nvim='~/Apps/nvim.appimage'" >>"$ZSHRC"; then
        print_error 'Adding nvim alias failed'
        exit 1
    fi

    print_success 'Neovim installed'
}

install_nvim_kickstart() {
    local config_dir=~/.config
    local nvim_config_dir=~/.config/nvim
    # local nvim_init_lua=$nvim_config_dir/init.lua

    echo
    print_install_log 'Neovim kickstart'

    if [[ -d "$nvim_config_dir" ]]; then
        print_skipping_log '~/.config/nvim already exists'
        return
    fi

    if ! mkdir -p "$config_dir"; then
        print_error 'Creating ~/.config failed'
        exit 1
    fi

    if ! mkdir -p "$nvim_config_dir"; then
        print_error 'Creating ~/.config/nvim failed'
        exit 1
    fi

    # if ! curl https://raw.githubusercontent.com/nvim-lua/kickstart.nvim/master/init.lua -o $nvim_init_lua; then
    if ! git clone https://github.com/nvim-lua/kickstart.nvim.git "$nvim_config_dir"; then
        print_error 'Cloning kickstart.nvim failed'
        exit 1
    fi

    echo
    print_install_log 'Neovim plugins'
    if ! "$NVIM_APPIMAGE" --headless -c 'Lazy install' -c 'qa!'; then
        print_error 'Neovim kickstart lazy install failed'
        exit 1
    fi

    if ! "$NVIM_APPIMAGE" --headless -c 'MasonInstall clangd' -c 'qa!'; then
        print_error 'Neovim kickstart mason install clangd failed'
        exit 1
    fi

    print_success 'Neovim kickstart installed'
}

install() {
    install_omz
    install_nvim_appimage
    install_nvim_kickstart

    echo
    print_success 'Installation complete!'
    echo -e "run ${DARK_BLUE}nvim${RESET} to start using neovim"
    echo
    echo -e "open your .zshrc file with ${DARK_BLUE}nvim ~/.zshrc${RESET} to customize your zsh config"
    echo -e "open your init.lua file with ${DARK_BLUE}nvim ~/.config/nvim/init.lua${RESET} to customize your nvim config"
    echo
    echo -e 'watch this video to learn more about nvim kickstart'
    echo -e "${DARK_MAGENTA}https://youtu.be/stqUbv-5u2s${RESET}"
    echo

    exec zsh
}

install
