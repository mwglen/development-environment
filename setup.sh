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
rm -rf "$HOME/.zsh/pure"
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"  
cat <<EOT > $HOME/.zshrc
# zsh config
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
zstyle :prompt:pure:path color white
zstyle :prompt:pure:prompt:success color cyan
zstyle :prompt:pure:prompt:error color cyan
zstyle :prompt:pure:git:stash show yes
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

# Setup neovim
$INSTALL neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
cat <<EOT > $HOME/.config/nvim/init.vim
call plug#begin('~/.config/nvim/plugged')
Plug 'jacoborus/tender.vim'
Plug 'LnL7/vim-nix'
Plug 'rust-lang/rust.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
call plug#end()

set number relativenumber       " set line-numbers to be relative
set nohlsearch                  " no highlight search
set mouse=a                     " recognize and enable mouse
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

chsh -s /usr/bin/zsh
