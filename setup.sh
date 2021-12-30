#!/bin/bash
set -e
set -v

# Make sure OS is supported
export DISTRO=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
if ![ "$DISTRO" = "\"Arch Linux\"" ] \
    && ![ "$DISTRO" = "\"Arch Linux ARM\"" ]; then 
    echo "Unsupported Platform"
    echo "Currently only Arch Linux is supported"
    return 1
fi

# Setup a folder to hold config files
mkdir -p .config
export CONFIG=$(realpath .config)

# Setup a folder to hold dotfiles
mkdir -p .dotfiles
export DOTFILES=$(realpath .dotfiles)

# Set XDG_CONFIG_HOME
export XDG_CONFIG_HOME=$CONFIG
echo "export XDG_CONFIG_HOME=$XDG_CONFIG_HOME" > $DOTFILES/zshrc

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
export INSTALL="yay -S --noconfirm --needed"
export INSTALL_LOCAL="yay -U --noconfirm --needed"
export REMOVE="yay -Rns --noconfirm --needed"
export UPDATE="yay -Syyu --noconfirm --needed"
export SEARCH="yay -Qs"

# Update packages
$UPDATE

# Install basic packages
$INSTALL wget man-db man-pages cmake

# Setup wslu (WSL utilties)
if (grep -qi microsoft /proc/version) && ! ($SEARCH wslu > /dev/null); then
    wget https://github.com/wslutilities/wslu/releases/download/v3.2.3/wslu-3.2.3-0-any.pkg.tar.zst
    $INSTALL_LOCAL *.zst
    rm *.zst
fi

# Setup git
$INSTALL git openssh
git config --global user.name "Matt Glen"
git config --global user.email "mwg2202@yahoo.com"

# Setup Git Annex
$INSTALL git-annex

# Setup ZSH (with Pure theme)
$INSTALL zsh
mkdir -p "$CONFIG/zsh"
rm -rf "$CONFIG/zsh/pure"
git clone https://github.com/sindresorhus/pure.git "$CONFIG/zsh/pure" 
cat <<EOT >> $DOTFILES/zshrc
# zsh config
fpath+=$CONFIG/zsh/pure
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
mkdir -p $CONFIG/nvim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
cat <<EOT > $CONFIG/nvim/init.vim
call plug#begin('$CONFIG/nvim/plugged')
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
cat <<EOT >> $DOTFILES/zshrc
# neovim config
alias vi=nvim
alias vim=nvim
export EDITOR=nvim
export VISUAL=nvim

EOT

# Setup emacs
$INSTALL emacs cantarell-fonts ttf-fira-code
cat <<EOT >> $DOTFILES/zshrc
# emacs config
vterm_printf(){
    if [ -n "\$TMUX" ] && ([ "\${TERM%%-*}" = "tmux" ] \
       || [ "\${TERM%%-*}" = "screen" ] ); then
        printf "\ePtmux;\e\e]%s\007\e\\\" "\$1"
    elif [ "\${TERM%%-*}" = "screen" ]; then
        printf "\eP\e]%s\007\e\\\" "\$1"
    else
        printf "\e]%s\e\\\" "\$1"
    fi
}

EOT

# Tangle emacs config
$INSTALL nim nimble
nimble install -y ntangle
~/.nimble/bin/ntangle emacs.org

# Setup EXWM (Emacs X Window Manager)
$INSTALL xorg xorg-server-xephyr

# Setup podman
$INSTALL podman
echo "unqualified-search-registries = ['docker.io']" \
    | sudo tee /etc/containers/registries.conf

# Install other applications
$INSTALL firefox

# Setup for WSL
if (grep -qi microsoft /proc/version); then
cat <<EOT >> $DOTFILES/zshrc
# WSL aliases
alias shutdown="shutdown.exe /s"
alias emacs="DISPLAY=:1 emacs"
alias xephyr="Xephyr -br -ac -noreset -fullscreen :1"

EOT
fi

# Link dotfiles and change shell
ln $DOTFILES/zshrc ~/.zshrc
sudo chsh -s /usr/bin/zsh $(whoami)
