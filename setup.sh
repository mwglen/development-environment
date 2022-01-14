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

cat <<EOT > $HOME/.profile
export XDG_CONFIG_HOME=$(realpath .)/.config
export XDG_CACHE_HOME=$(realpath .)/.cache
export XDG_DATA_HOME=$(realpath .)/.local/share
export XDG_STATE_HOME=$(realpath .)/.local/state
export BACKGROUNDS=$(realpath .)/backgrounds
EOT
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

export INSTALL="yay -S --noconfirm --needed"
export INSTALL_LOCAL="yay -U --noconfirm --needed"
export REMOVE="yay -Rns --noconfirm --needed"
export UPDATE="yay -Syyu --noconfirm --needed"
export SEARCH="yay -Qs"

$UPDATE

$INSTALL man-db man-pages

$INSTALL cmake

$INSTALL rsync

$INSTALL wget
echo hsts-file \= "$XDG_CACHE_HOME"/wget-hsts >> "$XDG_CONFIG_HOME/wgetrc"

$INSTALL exfatprogs

$INSTALL ntfs-3g

$INSTALL libguestfs

$INSTALL usbutils usbip

$INSTALL bluez bluez-utils bluetooth-autoconnect
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
sudo systemctl enable bluetooth-autoconnect
sudo systemctl start bluetooth-autoconnect
sudo systemctl enable pulseaudio-bluetooth-autoconnect
sudo systemctl start pulseaudio-bluetooth-autoconnect

# sudo tee "/etc/bluetooth/main.conf" > /dev/null <<'EOF'
# [Policy]
# AutoEnable=true

# [General]
# DiscoverableTimeout = 0
# EOF

$INSTALL networkmanager network-manager-applet
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

$INSTALL git openssh
mkdir -p "$XDG_CONFIG_HOME"/git
touch "$XDG_CONFIG_HOME"/git/config
git config --global user.name "Matt Glen"
git config --global user.email "mwg2202@yahoo.com"
git config --global init.defaultBranch master

$INSTALL git-annex

$INSTALL tex-live-core tllocalmgr-git
tllocalmgr update
tllocalmgr install dvipng l3packages xcolor soul adjustbox collectbox amsmath amssymb siunitx
sudo texhash

$INSTALL zsh
cat <<EOT > $HOME/.zshenv
source $HOME/.profile
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
alias ls="ls --color=auto -h"
alias grep="grep --color=auto"
alias ip="ip -color=auto"

EOT
source $HOME/.zshenv
mkdir -p $ZDOTDIR
cat <<EOT > $ZDOTDIR/.zshrc
# zsh config
unsetopt BEEP
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
unsetopt HIST_EXPIRE_DUPS_FIRST
unsetopt EXTENDED_HISTORY
HISTSIZE="10000"
SAVEHIST="10000"
HISTFILE="$XDG_STATE_HOME/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"

EOT

if (mkdir "$XDG_CONFIG_HOME"/zsh/pure); then
    git clone https://github.com/sindresorhus/pure.git "$XDG_CONFIG_HOME"/zsh/pure
fi
cat <<EOT >> $ZDOTDIR/.zshrc
# pure config
fpath+="$XDG_CONFIG_HOME"/zsh/pure
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

EOT

$INSTALL neovim
mkdir -p $XDG_CONFIG_HOME/nvim
curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
cat <<EOT > $XDG_CONFIG_HOME/nvim/init.vim
call plug#begin('$XDG_CONFIG_HOME/nvim/plugged')
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
cat <<EOT >> $ZDOTDIR/.zshrc
# neovim config
alias vi=nvim
alias vim=nvim
export EDITOR=nvim
export VISUAL=nvim

EOT

$INSTALL emacs

$INSTALL cantarell-fonts ttf-fira-code

mkdir -p .config/emacs
ln ./doom-moonless-theme.el .config/emacs/doom-moonless-theme.el

cat <<EOT >> $ZDOTDIR/.zshrc
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

$INSTALL nim nimble
mkdir -p "$XDG_CONFIG_HOME"/nimble
mkdir -p "$XDG_DATA_HOME"/nimble
cat <<EOT > "$XDG_CONFIG_HOME"/nimble/nimble.ini
nimbleDir = "$XDG_DATA_HOME/nimble"

EOT

nimble install -y ntangle
cat <<EOT >> $ZDOTDIR/.zshrc
# ntangle config
alias ntangle="$XDG_DATA_HOME"/nimble/bin/ntangle

EOT

mkdir -p .config/emacs
"$XDG_DATA_HOME"/nimble/bin/ntangle emacs.org

mkdir -p "$XDG_CONFIG_HOME"/systemd/user/
cat <<EOT > "$XDG_CONFIG_HOME"/systemd/user/emacs.service
[Unit]
Description=Emacs
Documentation=info:emacs man:emacs(1) https://gnu.org/software/emacs/

[Service]
type=forking
ExecStart=/user/bin/emacs --daemon
ExecStop=/usr/bin/emacsclient --eval "(kill-emacs)"
Environment=SSH_AUTH_SOCK=%t/keyring/ssh
Restart=on_failure

[Install]
WantedBy=default.target

EOT

rm -rf ~/.emacs.d
ln -s $XDG_CONFIG_HOME/emacs ~/.emacs.d

systemctl enable --user emacs
systemctl start --user emacs

$INSTALL podman
echo "unqualified-search-registries = ['docker.io']" \
    | sudo tee /etc/containers/registries.conf

$INSTALL firefox bitwarden bitwarden-cli

$INSTALL sxhkd brightnessctl pulsemixer
mkdir -p $XDG_CONFIG_HOME/autostart
cat <<EOT > $XDG_CONFIG_HOME/autostart/sxhkd.desktop
[Desktop Entry]
Name=sxhkd
Comment=Simple X hotkey daemon
Exec=/usr/bin/sxhkd
Terminal=false
Type=Application

EOT
mkdir -p $XDG_CONFIG_HOME/sxhkd
cat <<EOT > $XDG_CONFIG_HOME/sxhkd/sxhkdrc
# Brightness Keys
XF86MonBrightness{Up,Down}
    brightnessctl s 10{+,-}

# Volume Keys
XF86Audio{Raise,Lower}Volume
    pulsemixer --change-volume {+,-}10
XF86AudioMute
    pulsemixer --toggle-mute

EOT

$INSTALL libvert qemu

# Network Connectivity with Virtual Machine #
$INSTALL iptables-nft \  # NAT/DHCP Netowrking (iptables!=iptables-nft)
         dnsmasq \       # NAT/DHCP Netowrking
         bridge-utils \  # Bridged Networking
         openbsd-netcat  # Remote Management over SSH

# Client Software #
$INSTALL virsh \         # Managing and configuring domains
         virt-manager    # Graphically manage KVM, Xen or LXC

# Other Software #
$INSTALL libguestfs \  # Access and modify virtual machine disk images
         edk2-ovmf     # UEFI Support
         
# Members of the libvirt group have passwordless access to the RW daemon socket by default.
sudo usermod -aG libvirt ${whoami}
sudo usermod -aG kvm ${whoami}

sudo systemctl enable libvirtd # Also enables virtlogd and virtlockd
sudo systemctl start virtlogd
sudo systemctl start libvirtd

# Make sure to set user = /etc/libvirt/qemu.conf

$INSTALL wine wine-mono wine-gecko

#git clone --depth 1 --recursive https://github.com/kholia/OSX-KVM.git
#cd OSX-KVM && (echo "4" > ./fetch-macOS-v2.py)
#cd OSX-KVM && qemu-img convert BaseSystem.dmg -O raw BaseSystem.img
#cd OSX-KVM && qemu-img create -f qcow2 mac_hdd_ng.img 128G
#Installation
#cd OSX-KVM && ./OpenCore-Boot.sh

$INSTALL redshift

$INSTALL obs-studio

# mkdir -p $XDG_CONFIG_HOME/X11
# echo "Xft.dpi: 282" > $XDG_CONFIG_HOME/X11/xresources
echo "Xft.dpi: 200" > ~/.Xresources

$INSTALL lightdm
systemctl enable lightdm

$INSTALL lightdm-webkit2-greeter lightdm-webkit-theme-litarvan
sudo tee "/etc/lightdm/lightdm.conf" > /dev/null <<'EOF'
#
# General configuration
#
# start-default-seat = True to always start one seat if none are defined in the configuration
# greeter-user = User to run greeter as
# minimum-display-number = Minimum display number to use for X servers
# minimum-vt = First VT to run displays on
# lock-memory = True to prevent memory from being paged to disk
# user-authority-in-system-dir = True if session authority should be in the system location
# guest-account-script = Script to be run to setup guest account
# logind-check-graphical = True to on start seats that are marked as graphical by logind
# log-directory = Directory to log information to
# run-directory = Directory to put running state in
# cache-directory = Directory to cache to
# sessions-directory = Directory to find sessions
# remote-sessions-directory = Directory to find remote sessions
# greeters-directory = Directory to find greeters
# backup-logs = True to move add a .old suffix to old log files when opening new ones
# dbus-service = True if LightDM provides a D-Bus service to control it
#
[LightDM]
#start-default-seat=true
#greeter-user=lightdm
#minimum-display-number=0
#minimum-vt=7 # Setting this to a value < 7 implies security issues, see FS#46799
#lock-memory=true
#user-authority-in-system-dir=false
#guest-account-script=guest-account
#logind-check-graphical=false
#log-directory=/var/log/lightdm
run-directory=/run/lightdm
#cache-directory=/var/cache/lightdm
#sessions-directory=/usr/share/lightdm/sessions:/usr/share/xsessions:/usr/share/wayland-sessions
#remote-sessions-directory=/usr/share/lightdm/remote-sessions
#greeters-directory=$XDG_DATA_DIRS/lightdm/greeters:$XDG_DATA_DIRS/xgreeters
#backup-logs=true
#dbus-service=true

#
# Seat configuration
#
# Seat configuration is matched against the seat name glob in the section, for example:
# [Seat:*] matches all seats and is applied first.
# [Seat:seat0] matches the seat named "seat0".
# [Seat:seat-thin-client*] matches all seats that have names that start with "seat-thin-client".
#
# type = Seat type (local, xremote)
# pam-service = PAM service to use for login
# pam-autologin-service = PAM service to use for autologin
# pam-greeter-service = PAM service to use for greeters
# xserver-command = X server command to run (can also contain arguments e.g. X -special-option)
# xmir-command = Xmir server command to run (can also contain arguments e.g. Xmir -special-option)
# xserver-config = Config file to pass to X server
# xserver-layout = Layout to pass to X server
# xserver-allow-tcp = True if TCP/IP connections are allowed to this X server
# xserver-share = True if the X server is shared for both greeter and session
# xserver-hostname = Hostname of X server (only for type=xremote)
# xserver-display-number = Display number of X server (only for type=xremote)
# xdmcp-manager = XDMCP manager to connect to (implies xserver-allow-tcp=true)
# xdmcp-port = XDMCP UDP/IP port to communicate on
# xdmcp-key = Authentication key to use for XDM-AUTHENTICATION-1 (stored in keys.conf)
# greeter-session = Session to load for greeter
# greeter-hide-users = True to hide the user list
# greeter-allow-guest = True if the greeter should show a guest login option
# greeter-show-manual-login = True if the greeter should offer a manual login option
# greeter-show-remote-login = True if the greeter should offer a remote login option
# user-session = Session to load for users
# allow-user-switching = True if allowed to switch users
# allow-guest = True if guest login is allowed
# guest-session = Session to load for guests (overrides user-session)
# session-wrapper = Wrapper script to run session with
# greeter-wrapper = Wrapper script to run greeter with
# guest-wrapper = Wrapper script to run guest sessions with
# display-setup-script = Script to run when starting a greeter session (runs as root)
# display-stopped-script = Script to run after stopping the display server (runs as root)
# greeter-setup-script = Script to run when starting a greeter (runs as root)
# session-setup-script = Script to run when starting a user session (runs as root)
# session-cleanup-script = Script to run when quitting a user session (runs as root)
# autologin-guest = True to log in as guest by default
# autologin-user = User to log in with by default (overrides autologin-guest)
# autologin-user-timeout = Number of seconds to wait before loading default user
# autologin-session = Session to load for automatic login (overrides user-session)
# autologin-in-background = True if autologin session should not be immediately activated
# exit-on-failure = True if the daemon should exit if this seat fails
#
[Seat:*]
#type=local
#pam-service=lightdm
#pam-autologin-service=lightdm-autologin
#pam-greeter-service=lightdm-greeter
#xserver-command=X
#xmir-command=Xmir
#xserver-config=
#xserver-layout=
#xserver-allow-tcp=false
#xserver-share=true
#xserver-hostname=
#xserver-display-number=
#xdmcp-manager=
#xdmcp-port=177
#xdmcp-key=
greeter-session=lightdm-webkit2-greeter
#greeter-hide-users=false
#greeter-allow-guest=true
#greeter-show-manual-login=false
#greeter-show-remote-login=true
#user-session=default
#allow-user-switching=true
#allow-guest=true
#guest-session=
session-wrapper=/etc/lightdm/Xsession
#greeter-wrapper=
#guest-wrapper=
#display-setup-script=
#display-stopped-script=
#greeter-setup-script=
#session-setup-script=
#session-cleanup-script=
#autologin-guest=false
#autologin-user=
#autologin-user-timeout=0
#autologin-in-background=false
#autologin-session=
#exit-on-failure=false

#
# XDMCP Server configuration
#
# enabled = True if XDMCP connections should be allowed
# port = UDP/IP port to listen for connections on
# listen-address = Host/address to listen for XDMCP connections (use all addresses if not present)
# key = Authentication key to use for XDM-AUTHENTICATION-1 or blank to not use authentication (stored in keys.conf)
# hostname = Hostname to report to XDMCP clients (defaults to system hostname if unset)
#
# The authentication key is a 56 bit DES key specified in hex as 0xnnnnnnnnnnnnnn.  Alternatively
# it can be a word and the first 7 characters are used as the key.
#
[XDMCPServer]
#enabled=false
#port=177
#listen-address=
#key=
#hostname=

#
# VNC Server configuration
#
# enabled = True if VNC connections should be allowed
# command = Command to run Xvnc server with
# port = TCP/IP port to listen for connections on
# listen-address = Host/address to listen for VNC connections (use all addresses if not present)
# width = Width of display to use
# height = Height of display to use
# depth = Color depth of display to use
#
[VNCServer]
#enabled=false
#command=Xvnc
#port=5900
#listen-address=
#width=1024
#height=768
#depth=8

EOF

sudo tee "/etc/lightdm/lightdm-webkit2-greeter.conf" > /dev/null <<'EOF'
#
# [greeter]
# debug_mode          = Greeter theme debug mode.
# detect_theme_errors = Provide an option to load a fallback theme when theme errors are detected.
# screensaver_timeout = Blank the screen after this many seconds of inactivity.
# secure_mode         = Don't allow themes to make remote http requests.
# time_format         = A moment.js format string so the greeter can generate localized time for display.
# time_language       = Language to use when displaying the time or "auto" to use the system's language.
# webkit_theme        = Webkit theme to use.
#
# NOTE: See moment.js documentation for format string options: http://momentjs.com/docs/#/displaying/format/
#

[greeter]
debug_mode          = false
detect_theme_errors = true
screensaver_timeout = 300
secure_mode         = true
time_format         = LT
time_language       = auto
webkit_theme        = litarvan

#
# [branding]
# background_images = Path to directory that contains background images for use by themes.
# logo              = Path to logo image for use by greeter themes.
# user_image        = Default user image/avatar. This is used by themes for users that have no .face image.
#
# NOTE: Paths must be accessible to the lightdm system user account (so they cannot be anywhere in /home)
#

[branding]
background_images = /usr/share/backgrounds
logo              = /usr/share/pixmaps/archlinux-logo.svg
user_image        = /usr/share/pixmaps/archlinux-user.svg


EOF

$INSTALL xorg dbus xorg-xrdb
sudo mkdir -p /usr/share/xsessions/
sudo tee "/usr/share/xsessions/exwm.desktop" > /dev/null <<'EOF'
[Desktop Entry]
Name=exwm
Type=Application
Icon=exwm
Comment=The Emacs X Window Manager
TryExec=emacs
Exec=emacs -fg --debug-init
EOF

$INSTALL picom feh

$INSTALL polybar
mkdir -p $XDG_CONFIG_HOME/polybar

cat <<EOT > $XDG_CONFIG_HOME/polybar/config
[settings]
screenchange-reload = true

[global/wm]
margin-top = 0
margin-bottom = 0
EOT

cat <<EOT >> $XDG_CONFIG_HOME/polybar/config
[colors]
background = #000000
background-alt = #161719
foreground = #c5c8c6
foreground-alt = #767876
primary = #1d1f21
secondary = #e60053
alert = #bd2c40
EOT

cat <<EOT >> $XDG_CONFIG_HOME/polybar/config
[bar/panel]
width = 100%
height = 80
offset-x = 0
offset-y = 0
fixed-center = true
enable-ipc = true

background = \${colors.background}
foreground = \${colors.foreground}

line-size = 3
line-color = #f00

border-size = 0
border-color = #00000000 padding-top = 5
padding-left = 2
padding-right = 2

module-margin = 1

font-0 = "Noto Sans:size=25:weight=bold"
font-1 = "Material Icons:size=35;5"
font-2 = "Font Awesome:size=35;5"

modules-left = date
modules-center = cpu temperature memory
modules-right = wireless-network pulseaudio backlight redshift battery

tray-position = right
tray-padding = 2
tray-maxsize = 28

cursor-click = pointer
cursor-scroll = ns-resize
EOT

cat <<EOT >> $XDG_CONFIG_HOME/polybar/config
[module/cpu]
type = internal/cpu
interval = 2
format = CPU <label>
label = %percentage:2%%
EOT

cat <<EOT >> $XDG_CONFIG_HOME/polybar/config
[module/date]
type = internal/date
interval = 5
date = "%B %d, %Y"
date-alt = "%A %B %d, %Y"
time = %l:%M %p
time-alt = %H:%M:%S

format-prefix-foreground = \${colors.foreground-alt}
label = %date% %time%
EOT

cat <<EOT >> $XDG_CONFIG_HOME/polybar/config
[module/battery]
type = internal/battery
battery = BAT0
adapter = ADP1
full-at = 98
time-format = %-l:%M

label-charging = %percentage%%
format-charging = <animation-charging> <label-charging>
label-discharging = %percentage%%
format-discharging = <ramp-capacity> <label-discharging>

format-full = <ramp-capacity> <label-full>

ramp-capacity-0 = 
ramp-capacity-1 = 
ramp-capacity-2 = 
ramp-capacity-3 = 
ramp-capacity-4 = 

animation-charging-0 = 
animation-charging-1 = 
animation-charging-2 = 
animation-charging-3 = 
animation-charging-4 = 
animation-charging-framerate = 750
EOT

cat <<EOT >> $XDG_CONFIG_HOME/polybar/config
[module/temperature]
type = internal/temperature
thermal-zone = 0
warn-temperature = 70

format = TEMP <label>
format-warn = TEMP <label-warn>

label = %temperature-c%
label-warn = %temperature-c%!
label-warn-foreground = \${colors.secondary}
EOT

$INSTALL pulseaudio-control

cat <<EOT >> $XDG_CONFIG_HOME/polybar/config
[module/pulseaudio]
type = custom/script
tail = true
label-padding = 2
label-foreground = $\{colors.foreground}

exec = pulseaudio-control --icons-volume " , " --icon-muted " " --sink-nicknames-from "device.description" --sink-nickname "alsa_output.pci-0000_00_1f.3.analog-stereo: Built In Speakers" listen
click-right = pavucontrol
click-left = pulseaudio-control togmute
click-middle = pulseaudio-control --sink-blacklist "alsa_output.pci-0000_01_00.1.hdmi-stereo-extra2" next-sink
scroll-up = pulseaudio-control up
scroll-down = pulseaudio-control down
EOT

cat <<EOT >> $XDG_CONFIG_HOME/polybar/config
[module/wireless-network]
type = internal/network
interface = wlan0

format-connected =  <label-connected>
format-disconnected = <label-disconnected>
format-packetloss = <animation-packetloss label-connected>

label-connected = %essid%: %downspeed:2%
label-connected-foreground = #eefafafa

label-disconnected = not connected
label-disconnected-foreground = #66ffffff
EOT

cat <<EOT >> $XDG_CONFIG_HOME/polybar/config
[module/memory]
type = internal/memory
interval = 3
format = <label>
label = MEM %percentage_used:2%%
EOT

sudo makedir -p /etc/udev/rules.d
groupadd -r video
sudo usermod -a -G video $USER
sudo chgrp video /sys/class/backlight/intel_backlight/brightness"
sudo chmod g+w /sys/class/backlight/intel_backlight/brightness

cat <<EOT >> $XDG_CONFIG_HOME/polybar/config
[module/backlight]
type = internal/backlight
enable-scroll = true
card = intel_backlight
format = <ramp> <label>
label = %percentage%%
ramp-0 = 
ramp-1 = 
EOT

mkdir -p $XDG_CONFIG_HOME/polybar/scripts
cat <<EOT > $XDG_CONFIG_HOME/polybar/scripts/env.sh
export REDSHIFT=on
export REDSHIFT_TEMP=5600
EOT

cat <<EOT > $XDG_CONFIG_HOME/polybar/scripts/redshift.sh
#!/bin/sh

envFile=$XDG_CONFIG_HOME/polybar/scripts/env.sh
changeValue=300

changeMode() {
  sed -i "s/REDSHIFT=\$1/REDSHIFT=\$2/g" \$envFile 
  REDSHIFT=\$2
  echo \$REDSHIFT
}

changeTemp() {
  if [ "\$2" -gt 1000 ] && [ "\$2" -lt 25000 ]
  then
    sed -i "s/REDSHIFT_TEMP=\$1/REDSHIFT_TEMP=\$2/g" \$envFile 
    redshift -P -O \$((REDSHIFT_TEMP+changeValue))
  fi
}

case \$1 in 
  toggle) 
    if [ "\$REDSHIFT" = on ];
    then
      changeMode "\$REDSHIFT" off
      redshift -x
    else
      changeMode "\$REDSHIFT" on
      redshift -O "\$REDSHIFT_TEMP"
    fi
    ;;
  increase)
    changeTemp \$((REDSHIFT_TEMP)) \$((REDSHIFT_TEMP+changeValue))
    ;;
  decrease)
    changeTemp \$((REDSHIFT_TEMP)) \$((REDSHIFT_TEMP-changeValue));
    ;;
  temperature)
    case \$REDSHIFT in
      on)
        printf "%dK" "\$REDSHIFT_TEMP"
        ;;
      off)
        printf "off"
        ;;
    esac
    ;;
esac
EOT
chmod +x $XDG_CONFIG_HOME/polybar/scripts/redshift.sh
chmod +x $XDG_CONFIG_HOME/polybar/scripts/env.sh

cat <<EOT >> $XDG_CONFIG_HOME/polybar/config
[module/redshift]
type = custom/script
format-prefix = ""
exec = source $XDG_CONFIG_HOME/polybar/scripts/env.sh && $XDG_CONFIG_HOME/polybar/scripts/redshift.sh temperature
click-left = source $XDG_CONFIG_HOME/polybar/scripts/env.sh && $XDG_CONFIG_HOME/polybar/scripts/redshift.sh toggle
scroll-up = source $XDG_CONFIG_HOME/polybar/scripts/env.sh && $XDG_CONFIG_HOME/polybar/scripts/redshift.sh increase
scroll-down = source $XDG_CONFIG_HOME/polybar/scripts/env.sh && $XDG_CONFIG_HOME/polybar/scripts/redshift.sh decrease
interval=0.5
EOT

cat <<EOT >> $XDG_CONFIG_HOME/polybar/config
[module/exwm-workspace]
type = custom/ipc
hook-0 = emacsclient -e "exwm-workspace-current-index" | sed -e 's/^"//' -e 's/"$//'
initial = 1
format-padding = 1
EOT

sudo chsh -s /usr/bin/zsh $(whoami)
