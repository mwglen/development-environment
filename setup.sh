#!/bin/bash
set -e
set -v

# Determine OS platform
export DISTRO=$(awk -F= '/^NAME/{print $2}' /etc/os-release)

# Set OS specific variables
if [ "$DISTRO" = "\"Arch Linux\"" ] \
    || [ "$DISTRO" = "\"Arch Linux ARM\"" ]; then 

    # Get yay (can't use --noconfirm if fakeroot-tcp is installed)
    if ! (pacman -Qs yay > /dev/null); then
        if (pacman -Qs fakeroot-tcp > /dev/null); then
            sudo pacman -Syyu --needed git base-devel \
                && git clone https://aur.archlinux.org/yay.git \
                && cd yay && yes | makepkg -si
        else
            sudo pacman -Syyu --needed --noconfirm git base-devel \
                && git clone https://aur.archlinux.org/yay.git \
                && cd yay && yes | makepkg -si
        fi
        rm -rf yay
    fi

    # Setup shortcuts
    export INSTALL="yay -Syu --noconfirm --needed"
    export INSTALL_LOCAL="yay -U --noconfirm --needed"
    export REMOVE="yay -Rns --noconfirm --needed"
    export UPDATE="yay -Syu --noconfirm --needed"
    export SEARCH="yay -Qs"

else
    echo "Unsupported Platform"
    echo "Currently only Arch Linux is supported"
    return 1
fi

# Update packages
$UPDATE

# Install basic packages
$INSTALL wget man-db man-pages

# Setup wslu (WSL utilties)
if (grep -qi microsoft /proc/version) && ! ($SEARCH wslu > /dev/null); then
    wget https://github.com/wslutilities/wslu/releases/download/v3.2.3/wslu-3.2.3-0-any.pkg.tar.zst
    $INSTALL_LOCAL *.zst
    rm *.zst
fi

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
zstyle :prompt:pure:prompt:success color green
zstyle :prompt:pure:prompt:error color red
zstyle :prompt:pure:prompt:continuation color white
zstyle :prompt:pure:virtualenv color white
zstyle :prompt:pure:execution_time color white
zstyle :prompt:pure:git:stash show yes
zstyle :prompt:pure:git:stash color white
zstyle :prompt:pure:git:arrow color white
zstyle :prompt:pure:git:action color white
zstyle :prompt:pure:git:dirty color white
zstyle :prompt:pure:git:branch color white
zstyle :prompt:pure:git:branch:cached color red
zstyle :prompt:pure:path color white
zstyle :prompt:pure:host color white
zstyle :prompt:pure:user color white
zstyle :prompt:pure:user:root color magenta
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
mkdir -p $HOME/.config/nvim/
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

# Setup emacs
$INSTALL emacs
cat <<EOT > $HOME/.emacs
(setq inhibit-startup-message t)
(scroll-bar-mode -1)    ; Disable visible scrollbar
(tool-bar-mode -1)      ; Disable the toolbar
(tooltip-mode -1)       ; Disable tooltips
(set-fringe-mode 10)    ; Give some breathing room
(menu-bar-mode -1)      ; Disable the menu bar

; (set-face-attribute 'default nil :font "Fira Code Retina" :height 280)

(load-theme 'tango-dark)

; Load org mode
; (require 'package)
; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
; (package-initialize)
EOT

# Setup podman
$INSTALL podman
echo "unqualified-search-registries = ['docker.io']" \
    | sudo tee /etc/containers/registries.conf

sudo chsh -s /usr/bin/zsh $(whoami)
