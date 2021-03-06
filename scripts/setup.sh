#!/bin/bash

set -e

set -v

# NOTE: This file is generated from setup.org

export DISTRO=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
if ! [ "$DISTRO" = "\"Arch Linux\"" ] \
    && ! [ "$DISTRO" = "\"Arch Linux ARM\"" ]; then
    echo "Unsupported Platform"
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

sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key FBA220DFC880C036
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

$INSTALL git openssh
mkdir -p "$XDG_CONFIG_HOME"/git
touch "$XDG_CONFIG_HOME"/git/config
git config --global user.name "Matt Glen"
git config --global user.email "mwg2202@yahoo.com"
git config --global init.defaultBranch master

$INSTALL man-db man-pages

$INSTALL bazel

$INSTALL cmake

$INSTALL rsync

$INSTALL wget
echo hsts-file \= "$XDG_CACHE_HOME"/wget-hsts >> "$XDG_CONFIG_HOME/wgetrc"

$INSTALL inetutils

$INSTALL nerd-fonts-complete
# cd /usr/share/fonts/nerd-fonts-complete/TTF && sudo mkfontscale && mkfontdir
# sudo xset +fp /usr/share/fonts/nerd-fonts-complete/TTF
sudo fc-cache -fv

# Create font directory
mkdir -p ~/.local/share/fonts

# Copy font to directory
cp /usr/share/fonts/'Roboto Mono Nerd Font Complete Mono.ttf' ~/.local/share/fonts/roboto-mono-nerd-font-complete-mono.ttf

# Initialize font directory
cd ~/.local/share/fonts && mkfontscale && mkfontdir

# Add font directory
xset +fp '/home/$USER/.local/share/fonts'
xset fp rehash

$INSTALL python python-matplotlib poetry

$INSTALL rustup
rustup default nightly
rustup component add rls rust-analysis rust-src

$INSTALL gprolog swi-prolog

pip install git+https://github.com/yuce/pyswip@master#egg=pyswip

$INSTALL php

$INSTALL alacritty

$INSTALL nvidia

$INSTALL optimus-manager-qt

$INSTALL usbutils usbip

$INSTALL pipewire wireplumber pipewire-alsa pipewire-pulse pipewire-jack

$INSTALL pulseaudio-control

$INSTALL bluez bluez-utils
sudo systemctl enable bluetooth

$INSTALL networkmanager network-manager-applet
sudo systemctl enable NetworkManager

$INSTALL networkmanager-dmenu-git

$INSTALL alsa-utils pavucontrol

$INSTALL playerctl mpv yt-dlp baka-mplayer

$INSTALL acpi

#!/bin/bash
acpi -b | awk -F'[,:%]' '{print $2, $3}' | {
    read -r status capacity
  
    if [ "$status" = Discharging -a "$capacity" -lt 10 ]; then
        logger "Critical battery threshold"
        systemctl hibernate
    fi
}

sudo systemctl daemon-reload
sudo systemctl enable --now auto-hibernate.timer

sudo groupadd video && true
sudo usermod +aG video mwglen && true
sudo chgrp video /sys/class/backlight/intel_backlight/brightness && true

$INSTALL brightnessctl

$INSTALL brillo

$INSTALL cups sane python-pillow simple-scan
sudo systemctl enable cups

$INSTALL hplip

$INSTALL kdocker

$INSTALL texlive-core texlive-latexextra

$INSTALL zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions

source $HOME/.zshenv

$INSTALL nodejs npm
sudo npm install --global pure-prompt

$INSTALL tlp
sudo systemctl enable tlp

$INSTALL exfatprogs

$INSTALL ntfs-3g

$install cryfs

$INSTALL libguestfs

$INSTALL mtpfs

$INSTALL udisks2 udiskie

mkdir -p ~/personal-documents/Mail

$INSTALL notmuch gmailieer

$INSTALL gmailieer

mkdir ~/Mail/account.gmail

gmi init mwg2202@gmail.com
gmi pull

$INSTALL neomutt

$INSTALL ruby
gem install date icalendar optparse tzinfo

git clone https://tero.hasu.is/repos/icalendar-to-org.git $REPOSITORIES/icalendar-to-org && true

$INSTALL linux-wifi-hotspot

$INSTALL stalonetray

$INSTALL polybar

curl https://raw.githubusercontent.com/unode/polypomo/master/polypomo > $XDG_CONFIG_HOME/polybar/scripts/polypomo
chmod +x $XDG_CONFIG_HOME/polybar/scripts/polypomo

sudo mkdir -p /etc/udev/rules.d
groupadd -r video && true
sudo usermod -a -G video $USER
sudo chgrp video /sys/class/backlight/intel_backlight/brightness
sudo chmod g+w /sys/class/backlight/intel_backlight/brightness

$INSTALL materia-kde kvantum-theme-materia kvantum

$INSTALL materia-gtk-theme phinger-cursors

$INSTALL lightdm
sudo systemctl enable lightdm

$INSTALL lightdm-webkit2-greeter
sudo mkdir -p /usr/share/lightdm-webkit/themes/litaravan

wget https://github.com/Litarvan/lightdm-webkit-theme-litarvan/releases/download/v3.2.0/lightdm-webkit-theme-litarvan-3.2.0.tar.gz -O $REPOSITORIES/lightdm-webkit-theme-litarvan-3.2.0.tar.gz

sudo tar -xf $REPOSITORIES/lightdm-webkit-theme-litarvan-3.2.0.tar.gz -C /usr/share/lightdm-webkit/themes/litarvan

# The jonaburg fork of picom has rounded corners, dual kawase blur, and window animations
$INSTALL picom-jonaburg-git

$INSTALL fcitx-im fcitx-configtool fcitx-qt4
sudo locale-gen

$INSTALL xorg-xmodmap

$INSTALL fcitx-mozc

$INTSALL wlroots python-pywlroots

$INSTALL kanshi

profile {
    output eDP-1 enable mode 3840x2160 scale 2 position 0,0
}

$INSTALL xorg dbus xorg-xrdb xorg-transset wmctrl xorg-xmessage xclip

$INSTALL xbindkeys

$INSTALL xmonad-git xmonad-contrib-git

$INSTALL rofi pinentry-rofi rofi-bluetooth-git rofi-dmenu

$INSTALL xmobar trayer ttf-mononoki

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

$INTSALL vagrant

$INSTALL wine-staging wine-gecko wine-mono

$INSTALL nmap

$INSTALL tcpdump

$INSTALL xfoil openvsp-git

$INSTALL todoist-electron

$INSTALL krita

$INSTALL conky

$INSTALL pandoc

$INSTALL zk

$INSTALL rmtrash

$INSTALL mimeo

$INSTALL anki

$INSTALL dolphin

$INSTALL ranger python-ueberzug-git

$INSTALL minecraft-launcher steam

$INSTALL gotop

$INSTALL cava

$INSTALL alsi

$INSTALL ahoviewer-git

$INSTALL emacs-git

ln $DIR/doom-moonless-theme.el ~/.emacs.d/doom-moonless-theme.el

$INSTALL nim nimble

nimble install -y ntangle

rm -rf ~/.emacs.d
ln -s $XDG_CONFIG_HOME/emacs ~/.emacs.d
rm -rf ~/backgrounds
ln -s $DIR/backgrounds ~/backgrounds
#sudo systemctl enable --now --user emacs

$INSTALL yandex-browser-beta

$INSTALL google-chrome

$INSTALL firefox

$INSTALL blender blendnet

$INSTALL flameshot

$INSTALL bitwarden bitwarden-cli bitwarden-rofi

$INSTALL sidequest-bin

$INSTALL glxinfo

$INSTALL spotify psst-git-bin

$INSTALL discord

$INSTALL libreoffice-fresh libreoffice-fresh-ru

$INSTALL git-annex

$INSTALL redshift

$INSTALL obs-studio

$INSTALL devour

$INSTALL nsxiv

$INSTALL feh

mkdir -p $BACKGROUNDS
cp -r $DIR/backgrounds/* $BACKGROUNDS

curl -L https://raw.githubusercontent.com/thomas10-10/foo-Wallpaper-Feh-Gif/master/install.sh | bash
#back4.sh 0.010 gif/pixel.gif &

$INSTALL python-pywal python-colorthief

sudo pip3 install wpgtk

$INSTALL python-pywalfox
sudo pywalfox install

$INSTALL neovim neovide-git
mkdir -p $XDG_CONFIG_HOME/nvim
curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim +'PlugInstall' +qall
nvim +'TSUpdate org' +qall
nvim +'CocInstall -sync coc-json coc-tsserver coc-html coc-rls coc-pyright coc-css coc-cmake coc-sh coc-cl coc-clojure coc-godot' +qall
nvim +CocUpdateSync +qall

$INSTALL svlangserver
$INSTALL haskell-language-server
sudo npm install moby --global
$INSTALL sdcv stardict-oed stardict-full-rus-eng stardict-full-eng-rus

sudo chsh -s /usr/bin/zsh $USER
