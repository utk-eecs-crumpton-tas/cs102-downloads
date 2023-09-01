#!/bin/bash

DARK_RED='\e[38;5;1m'
DARK_GREEN='\e[38;5;2m'
DARK_BLUE='\e[38;5;4m'
DARK_MAGENTA='\e[38;5;5m'
# DARK_BLACK='\e[38;5;0m'
# DARK_YELLOW='\e[38;5;3m'
# DARK_CYAN='\e[38;5;6m'
# DARK_WHITE='\e[38;5;7m'

# BOLD='\e[1m'
# ITALIC='\e[3m'
RESET='\e[0m'

ZSHRC=~/.zshrc

OMZ_DIR=~/.oh-my-zsh
OMZ_PLUGINS=$OMZ_DIR/custom/plugins

APPS_DIR=~/Apps
NVIM_APPIMAGE=$APPS_DIR/nvim.appimage
NVIM_CONFIG=~/.config/nvim
NVIM_INIT_LUA=$NVIM_CONFIG/init.lua

print_success() {
    local message="$@"
    echo -e "${DARK_GREEN}Success${RESET}: $message"
}

print_error() {
    local message="$@"
    echo -e "${DARK_RED}Error${RESET}: $message" >&2

}

print_blue() {
    local message="$@"
    echo -e "${DARK_BLUE}$message${RESET}"
}

install_omz() {
    print_blue 'Installing Oh My Zsh'

    if [[ -d $OMZ_DIR ]] && ! rm -rf $OMZ_DIR; then
        print_error 'Failed to remove existing Oh My Zsh'
        exit 1
    fi

    if ! curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh; then
        print_error 'Oh My Zsh install failed'
        exit 1
    fi

    print_success 'Oh My Zsh installed'
    print_blue 'Installing Oh My Zsh plugins'

    if ! git clone https://github.com/tamcore/autoupdate-oh-my-zsh-plugins.git $OMZ_PLUGINS/autoupdate; then
        print_error 'Cloning zsh autoupdate install failed'
        exit 1
    fi

    if ! git clone https://github.com/zsh-users/zsh-autosuggestions.git $OMZ_PLUGINS/zsh-autosuggestions; then
        print_error 'Cloning zsh autosuggestions install failed'
        exit 1
    fi

    if ! git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $OMZ_PLUGINS/zsh-syntax-highlighting; then
        print_error 'Cloning zsh syntax highlighting install failed'
        exit 1
    fi

    if ! sed -i 's/plugins=(\(.*\))/plugins=(\1 autoupdate zsh-autosuggestions zsh-syntax-highlighting)/' $ZSHRC; then
        print_error 'Adding omz plugins to .zshrc failed'
        exit 1
    fi

    print_success 'Zsh plugins installed'
}

install_nvim() {
    print_blue 'Installing Neovim'

    if ! mkdir -p $APPS_DIR; then
        print_error 'Creating ~/Apps failed'
        exit 1
    fi

    if ! curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o ~/Apps/nvim.appimage; then
        print_error 'Neovim download failed'
        exit 1
    fi

    if ! chmod u+x $NVIM_APPIMAGE; then
        print_error 'Neovim chmod failed'
        exit 1
    fi

    if ! echo "alias nvim='~/Apps/nvim.appimage'" >>$ZSHRC; then
        print_error 'Adding nvim alias failed'
        exit 1
    fi

    print_success 'Neovim installed'
}

install_nvim_kickstart() {
    print_blue 'Installing Neovim kickstart'

    if ! mkdir -p $NVIM_CONFIG; then
        print_error 'Failed to create nvim config directory'
        exit 1
    fi

    if ! curl https://raw.githubusercontent.com/nvim-lua/kickstart.nvim/master/init.lua |
        sed "s/{ import = 'custom.plugins' }/-- { import = 'custom.plugins' }/" >$NVIM_INIT_LUA; then
        print_error 'Downloading nvim kickstart init.lua failed'
        exit 1
    fi

    print_success 'Neovim kickstart installed'
}

install_omz
install_nvim
install_nvim_kickstart

echo
print_success 'Installation complete'
echo -e "  run ${DARK_BLUE}exec zsh${RESET} to restart the shell and start using oh-my-zsh and nvim"
echo -e "  run ${DARK_BLUE}nvim${RESET} to start using neovim"
echo
echo -e "  open your .zshrc file with ${DARK_BLUE}nvim $ZSHRC${RESET} to customize your zsh config"
echo -e "  open your init.lua file with ${DARK_BLUE}nvim $NVIM_INIT_LUA${RESET} to customize your nvim config"
echo
echo -e '  watch this video to learn more about nvim kickstart'
echo -e "  ${DARK_MAGENTA}https://youtu.be/stqUbv-5u2s${RESET}"
