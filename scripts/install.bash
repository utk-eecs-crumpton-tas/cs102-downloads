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

install_omz() {
    local omz_dir=~/.oh-my-zsh
    local omz_plugins=$omz_dir/custom/plugins

    print_install_log 'Oh My Zsh'

    if [[ -d $omz_dir ]] && ! rm -rf $omz_dir; then
        print_error 'Failed to remove existing Oh My Zsh'
        exit 1
    fi

    if ! curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh; then
        print_error 'Oh My Zsh install failed'
        exit 1
    fi

    print_success 'Oh My Zsh installed'
    print_install_log 'Oh My Zsh plugins'

    if ! git clone https://github.com/tamcore/autoupdate-oh-my-zsh-plugins.git $omz_plugins/autoupdate; then
        print_error 'Cloning zsh autoupdate install failed'
        exit 1
    fi

    if ! git clone https://github.com/zsh-users/zsh-autosuggestions.git $omz_plugins/zsh-autosuggestions; then
        print_error 'Cloning zsh autosuggestions install failed'
        exit 1
    fi

    if ! git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $omz_plugins/zsh-syntax-highlighting; then
        print_error 'Cloning zsh syntax highlighting install failed'
        exit 1
    fi

    if ! sed -i 's/plugins=(\(.*\))/plugins=(\1 autoupdate zsh-autosuggestions zsh-syntax-highlighting)/' $ZSHRC; then
        print_error 'Adding omz plugins to .zshrc failed'
        exit 1
    fi

    print_success 'Zsh plugins installed'
}

# install_nvim_appimage() {
#     local apps_dir=~/Apps
#     local nvim_appimage=$apps_dir/nvim.appimage

#     print_install_log 'Neovim'

#     if ! mkdir -p $apps_dir; then
#         print_error 'Creating ~/Apps failed'
#         exit 1
#     fi

#     if ! curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o ~/Apps/nvim.appimage; then
#         print_error 'Neovim download failed'
#         exit 1
#     fi

#     if ! chmod u+x $nvim_appimage; then
#         print_error 'Neovim chmod failed'
#         exit 1
#     fi

#     if ! echo "alias nvim='~/Apps/nvim.appimage'" >>$ZSHRC; then
#         print_error 'Adding nvim alias failed'
#         exit 1
#     fi

#     print_success 'Neovim installed'
# }

install_nvim_kickstart() {
    local nvim_config_dir=~/.config/nvim
    local nvim_init_lua=$nvim_config_dir/init.lua
    print_install_log 'Neovim kickstart'

    if ! mkdir -p $nvim_config_dir; then
        print_error 'Failed to create nvim config directory'
        exit 1
    fi

    if ! curl https://raw.githubusercontent.com/nvim-lua/kickstart.nvim/master/init.lua |
        sed "s/{ import = 'custom.plugins' }/-- { import = 'custom.plugins' }/" >$nvim_init_lua; then
        print_error 'Downloading nvim kickstart init.lua failed'
        exit 1
    fi

    print_success 'Neovim kickstart installed'
}

install_omz
# install_nvim_appimage
install_nvim_kickstart

echo
print_success 'Installation complete!'
echo -e "run ${DARK_BLUE}exec zsh${RESET} to restart the shell and start using oh-my-zsh"
echo -e "run ${DARK_BLUE}nvim${RESET} to start using neovim"
echo
echo -e "open your .zshrc file with ${DARK_BLUE}nvim ~/.zshrc${RESET} to customize your zsh config"
echo -e "open your init.lua file with ${DARK_BLUE}nvim ~/.config/nvim/init.lua${RESET} to customize your nvim config"
echo
echo -e 'watch this video to learn more about nvim kickstart'
echo -e "${DARK_MAGENTA}https://youtu.be/stqUbv-5u2s${RESET}"
echo
