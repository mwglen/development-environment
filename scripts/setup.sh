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

mkdir -p $XDG_CONFIG_HOME
mkdir -p $XDG_CACHE_HOME
mkdir -p $XDG_DATA_HOME
mkdir -p $XDG_STATE_HOME
mkdir -p $REPOSITORIES

if ! (pacman -Qs yay > /dev/null); then
    if (pacman -Qs fakeroot-tcp > /dev/null); then
        sudo pacman -Syyu --needed git base-devel \ && git clone https://aur.archlinux.org/yay.git $REPOSITORIES/yay \ && cd $REPOSITORIES/yay && yes | makepkg -si
    else # cannot use --noconfirm if fakeroot-tcp is installed
        sudo pacman -Syyu --needed --noconfirm git base-devel \
            && git clone https://aur.archlinux.org/yay.git \
            && cd yay && yes | makepkg -si
    fi
    rm -rf $REPOSITORIES/yay
fi

export INSTALL="yay -S --noconfirm --needed"
export INSTALL_LOCAL="yay -U --noconfirm --needed"
export REMOVE="yay -R --noconfirm --needed"
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

$INSTALL inetutils

$INSTALL python python-matplotlib poetry

$INSTALL rustup
rustup default nightly

$INSTALL alacritty

$INSTALL nvidia

$INSTALL usbutils usbip

$INSTALL bluez bluez-utils pulseaudio-bluetooth blueman-git
sudo systemctl enable bluetooth

$INSTALL networkmanager network-manager-applet
sudo systemctl enable NetworkManager

$INSTALL alsa-utils pavucontrol

$INSTALL playerctl mpv yt-dlp baka-mplayer

sudo groupadd video && true
sudo usermod +aG video mwglen && true
sudo chgrp video /sys/class/backlight/intel_backlight/brightness && true

$INSTALL brightnessctl

git clone https://github.com/CameronNemo/brillo $REPOSITORIES/brillo && true
cd $REPOSITORIES/brillo && sudo make install

$INSTALL cups sane python-pillow simple-scan
sudo systemctl enable cups

$INSTALL hplip

$INSTALL texlive-core texlive-latexextra

$INSTALL zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions

source $HOME/.zshenv

$INSTALL nodejs npm
sudo npm install --global pure-prompt

$INSTALL xorg-xmodmap

$INSTALL tlp
sudo systemctl enable tlp

$INSTALL autofs
sudo mkdir -p /misc/android

$INSTALL exfatprogs

$INSTALL ntfs-3g

$INSTALL libguestfs

$INSTALL mtpfs

$INSTALL udisks2

$INSTALL isync

mkdir -p ~/personal-documents/Mail

$INSTALL ruby
gem install date icalendar optparse tzinfo

git clone https://tero.hasu.is/repos/icalendar-to-org.git $REPOSITORIES/icalendar-to-org && true

$INSTALL linux-wifi-hotspot

$INSTALL polybar

$INSTALL pulseaudio-control

sudo mkdir -p /etc/udev/rules.d
groupadd -r video && true
sudo usermod -a -G video $USER
sudo chgrp video /sys/class/backlight/intel_backlight/brightness
sudo chmod g+w /sys/class/backlight/intel_backlight/brightness

$INSTALL materia-kde kvantum-theme-materia kvantum

$INSTALL materia-gtk-theme

echo "Xft.dpi: 200" > ~/.Xresources

$INSTALL lightdm
sudo systemctl enable lightdm

$INSTALL lightdm-webkit2-greeter
sudo mkdir -p /usr/share/lightdm-webkit/themes/litaravan

wget https://github.com/Litarvan/lightdm-webkit-theme-litarvan/releases/download/v3.2.0/lightdm-webkit-theme-litarvan-3.2.0.tar.gz -O $REPOSITORIES/lightdm-webkit-theme-litarvan-3.2.0.tar.gz

sudo tar -xf $REPOSITORIES/lightdm-webkit-theme-litarvan-3.2.0.tar.gz -C /usr/share/lightdm-webkit/themes/litarvan

$INSTALL picom-ibhagwan-git

$INSTALL xorg dbus xorg-xrdb xorg-transset wmctrl

$INSTALL xbindkeys

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

sudo systemctl enable --now libvirtd # Also enables virtlogd and virtlockd
sudo systemctl start virtlogd

# Make sure to set user = /etc/libvirt/qemu.conf

$INSTALL mimeo

$INSTALL gotop

$INSTALL cava

$INSTALL alsi

$INSTALL emacs28-git

$INSTALL cantarell-fonts ttf-fira-code noto-fonts ttf-roboto ttf-roboto-mono noto-fonts-emoji

$INSTALL ahoviewer-git

ln $DIR/doom-moonless-theme.el ~/.emacs.d/doom-moonless-theme.el

$INSTALL nim nimble

nimble install -y ntangle

rm -rf ~/.emacs.d
ln -s $XDG_CONFIG_HOME/emacs ~/.emacs.d
rm -rf ~/backgrounds
ln -s $DIR/backgrounds ~/backgrounds

#sudo systemctl enable --now --user emacs

$INSTALL firefox

$INSTALL blender blendnet

$INSTALL flameshot

$INSTALL qutebrowser python-qutescript-git
mkdir -p $XDG_DATA_HOME/qutebrowser/userscripts

wget raw.githubusercontent.com/qutebrowser/qutebrowser/master/misc/userscripts/qute-bitwarden -O $XDG_DATA_HOME/qutebrowser/userscripts/qute-bitwarden
chmod +x $XDG_DATA_HOME/qutebrowser/userscripts/qute-bitwarden

$INSTALL python-tldextract

mkdir -p $XDG_CONFIG_HOME/qutebrowser
mkdir -p ~/Downloads
cd $XDG_CONFIG_HOME/qutebrowser && git clone https://github.com/alphapapa/solarized-everything-css && true

$INSTALL bitwarden bitwarden-cli

$INSTALL sidequest-bin

$INSTALL glxinfo

$INSTALL spotify

$INSTALL discord

$INSTALL libreoffice-fresh libreoffice-fresh-ru

$INSTALL git-annex

$INSTALL redshift

$INSTALL obs-studio

$INSTALL podman
echo "unqualified-search-registries = ['docker.io']" \
    | sudo tee /etc/containers/registries.conf

$INSTALL feh

mkdir -p $BACKGROUNDS
cp -r $DIR/backgrounds/* $BACKGROUNDS

$INSTALL neovim
mkdir -p $XDG_CONFIG_HOME/nvim
curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sudo chsh -s /usr/bin/zsh $USER