#!/bin/bash

set -e

set -v

# NOTE: This file is generated from setup.org

export DISTRO=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
if ! [ "$DISTRO" = "\"Arch Linux\"" ] \
    && ! [ "$DISTRO" = "\"Arch Linux ARM\"" ]; then echo "Unsupported Platform"
    echo "Currently only Arch Linux is supported"
    return 1
fi

DIR=$(realpath $(dirname $0))

source $HOME/.profile

#rm -rf $XDG_CONFIG_HOME
#rm -rf $XDG_CACHE_HOME
#rm -rf $XDG_DATA_HOME
#rm -rf $XDG_STATE_HOME

mkdir -p $XDG_CONFIG_HOME
mkdir -p $XDG_CACHE_HOME
mkdir -p $XDG_DATA_HOME
mkdir -p $XDG_STATE_HOME

if ! (pacman -Qs yay > /dev/null); then
    if (pacman -Qs fakeroot-tcp > /dev/null); then
        sudo pacman -Syyu --needed git base-devel \ && git clone https://aur.archlinux.org/yay.git \ && cd yay && yes | makepkg -si
    else # cannot use --noconfirm if fakeroot-tcp is installed
        sudo pacman -Syyu --needed --noconfirm git base-devel \
            && git clone https://aur.archlinux.org/yay.git \
            && cd yay && yes | makepkg -si
    fi
    rm -rf yay
fi

export INSTALL="yay -S --noconfirm --needed --useask"
export INSTALL_LOCAL="yay -U --noconfirm --needed"
export REMOVE="yay -Rns --noconfirm --needed"
export UPDATE="yay -Syyu --noconfirm --needed"
export SEARCH="yay -Qs"

$UPDATE

$INSTALL git openssh
mkdir -p "$XDG_CONFIG_HOME"/git
touch "$XDG_CONFIG_HOME"/git/config
git config --global user.name "Matt Glen"
git config --global user.email "mwg2202@yahoo.com"
git config --global init.defaultBranch master

$INSTALL man-db man-pages

$INSTALL cmake

$INSTALL rsync

$INSTALL wget
echo hsts-file \= "$XDG_CACHE_HOME"/wget-hsts >> "$XDG_CONFIG_HOME/wgetrc"

$INSTALL alacritty

$INSTALL nvidia

$INSTALL usbutils usbip

$INSTALL bluez bluez-utils pulseaudio-bluetooth
sudo systemctl enable bluetooth

$INSTALL networkmanager network-manager-applet
sudo systemctl enable NetworkManager

$INSTALL playerctl

$INSTALL brightnessctl

$INSTALL cups sane python-pillow simple-scan
sudo systemctl enable cups

$INSTALL hplip

$INSTALL texlive-core

$INSTALL zsh

source $HOME/.zshenv

if (mkdir "$XDG_CONFIG_HOME"/zsh/pure); then
    git clone https://github.com/sindresorhus/pure.git "$XDG_CONFIG_HOME"/zsh/pure
fi

$INSTALL xorg-xmodmap

$INSTALL tlp
sudo systemctl enable tlp

$INSTALL exfatprogs

$INSTALL ntfs-3g

$INSTALL libguestfs

$INSTALL isync

mkdir -p ~/personal-documents/Mail

$INSTALL linux-wifi-hotspot

$INSTALL polybar

$INSTALL pulseaudio-control

sudo mkdir -p /etc/udev/rules.d
groupadd -r video && true
sudo usermod -a -G video $USER
sudo chgrp video /sys/class/backlight/intel_backlight/brightness
sudo chmod g+w /sys/class/backlight/intel_backlight/brightness

$INSTALL materia-gtk-theme

echo "Xft.dpi: 200" > ~/.Xresources

$INSTALL lightdm
sudo systemctl enable lightdm

$INSTALL lightdm-webkit-theme-litarvan

$INSTALL picom-ibhagwan-git

$INSTALL xorg dbus xorg-xrdb xorg-transset wmctrl

cd ~/.config/emacs/lisp && wget https://raw.githubusercontent.com/mwglen/ivy-clipmenu.el/master/ivy-clipmenu.el

$INSTALL xmonad xmonad-contrib

$INSTALL rofi

rm -rf $XDG_CONFIG_HOME/rofi
ln -s $DIR/rofi  $XDG_CONFIG_HOME/rofi

$INSTALL xmobar

$INSTALL libnotify

$INSTALL dunst

$INSTALL libvirt qemu

# Network Connectivity with Virtual Machine #
$INSTALL iptables-nft    # NAT/DHCP Netowrking (iptables!=iptables-nft)
$INSTALL dnsmasq         # NAT/DHCP Netowrking
$INSTALL bridge-utils    # Bridged Networking
$INSTALL openbsd-netcat  # Remote Management over SSH

# Client Software #
$INSTALL virt-manager    # Graphically manage KVM, Xen or LXC

# Other Software #
$INSTALL libguestfs    # Access and modify virtual machine disk images
$INSTALL edk2-ovmf     # UEFI Emulation
$INSTALL swtpm         # TPM Emulation
         
# Members of the libvirt group have passwordless access to the RW daemon socket by default.
sudo usermod -a -G libvirt $USER
sudo usermod -a -G kvm $USER

sudo systemctl enable libvirtd # Also enables virtlogd and virtlockd
sudo systemctl start virtlogd

# Make sure to set user = /etc/libvirt/qemu.conf

$INSTALL gotop

$INSTALL cava

$INSTALL alsi

#$INSTALL emacs28-git

$INSTALL cantarell-fonts ttf-fira-code

rm -rf ~/.emacs.d/doom-moonless-theme.el
ln $DIR/doom-moonless-theme.el ~/.emacs.d/doom-moonless-theme.el

$INSTALL nim nimble
mkdir -p "$XDG_CONFIG_HOME"/nimble
mkdir -p "$XDG_DATA_HOME"/nimble

nimble install -y ntangle

#"$XDG_DATA_HOME"/nimble/bin/ntangle emacs.org

rm -rf ~/.emacs.d
ln -s $XDG_CONFIG_HOME/emacs ~/.emacs.d
rm -rf ~/backgrounds
ln -s $DIR/backgrounds ~/backgrounds

#sudo systemctl enable --user emacs

$INSTALL firefox

$INSTALL qutebrowser

mkdir -p $XDG_CONFIG_HOME/qutebrowser
cd $XDG_CONFIG_HOME/qutebrowser && git clone https://github.com/alphapapa/solarized-everything-css

$INSTALL bitwarden bitwarden-cli

$INSTALL spotify

$INSTALL discord

$INSTALL git-annex

$INSTALL redshift

$INSTALL obs-studio

$INSTALL podman
echo "unqualified-search-registries = ['docker.io']" \
    | sudo tee /etc/containers/registries.conf

$INSTALL feh

$INSTALL neovim
mkdir -p $XDG_CONFIG_HOME/nvim
curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sudo chsh -s /usr/bin/zsh $USER