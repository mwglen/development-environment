#!/bin/bash
set -e
set -v

# Determine OS platform
export DISTRO=$(awk -F= '/^NAME/{print $2}' /etc/os-release)

# Set OS specific variables
if [ "$DISTRO" = "\"Arch Linux\"" ]; then 
    # Get yay
    sudo pacman -S --needed git base-devel \
        && git clone https://aur.archlinux.org/yay.git \
        && cd yay && makepkg -si
    rm -rf yay

    # Setup shortcuts
    export INSTALL="sudo yay -Syu --noconfirm"
    export REMOVE="sudo yay -Rns --noconfirm"
    export UPDATE="sudo yay -Syu --noconfirm"
fi

# Update packages
$UPDATE

# Setup git
$INSTALL git openssh
git config user.name "Matt Glen"
git config user.email "mwg2202@yahoo.com"

# Setup ZSH (with Pure theme)
$INSTALL zsh
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"  
chsh -s /usr/bin/zsh
cat <<EOT >> $HOME/.zshrc
# zsh config
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure

# misc config
unsetopt BEEP
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
unsetopt HIST_EXPIRE_DUPS_FIRST
unsetopt EXTENDED_HISTORY
HISTSIZE="10000"
SAVEHIST="10000"
HISTFILE="$HOME/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"
EOT

# Install neovim
$INSTALL neovim neovim-airline neovim-airline-themes vim-rust-git \
    vim-commentary vim-tender-git vim-nix-git vim-gitgutter-git \
    neovim-surround neovim-fugitive
cat <<EOT > $HOME/.config/nvim/init.vim
set number relativenumber       " set line-numbers to be relative
set nohlsearch                  " no highlight search
syntax enable                   " enable syntax highlighting
set mouse=a                     " recognize and enable mouse
filetype plugin indent on       " automatic indention using filetype
set tabstop=4                   " show existing tab as 4 spaces
set shiftwidth=4                " use 4 spaces when indenting with '>'
set expandtab                   " on pressing tab, insert 4 spaces
set termguicolors               " use terminal colors
let g:airline_powerlin_fonts=1  " set airline theme
colorscheme tender              " change the colorscheme
let g:airline_theme = 'tender'  " change airline colorscheme

EOT
cat <<EOT >> $HOME/.zshrc
# neovim config
alias vi=nvim
alias vim=nvim
export EDITOR=nvim
export VISUAL=nvim

EOT

# Setup nix
$INSTALL nix
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update
nix-env -iA nixpkgs.nixUnstable
cat <<EOT >> $HOME/.zshrc
# nix config
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi
export NIXPKGS_ALLOW_UNFREE=1

EOT
