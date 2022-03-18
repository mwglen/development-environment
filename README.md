# development-environment
## Complete configuration and setup scripts for my current linux environment.

## Introduction
Originally this was a repository to hold my WSL configuration, but then I started to daily drive Arch Linux and this became a place to document, manage, and distribute my current desktop environment. As such the name development-environment doesn't fit as much as it used to and I might later change it to desktop-environment.

Currently, I use XMonad as my window manager (although I sometimes switch to EXWM). Picom is used for transparency, window animations, and blurring. Feh is used to set my background. Qutebrowser and Firefox are my web browsers of choice. For editing text, I use Emacs and Neovim. Polybar is used for my system panel. Many other applications are also used and these can be seen in `setup.org`.

## Screenshots
![image](https://user-images.githubusercontent.com/10079472/154896328-05ddd9bf-d218-4511-b7b6-81b398def00a.png)

## Loading my configuration on a clean Arch Linux install:
- Download this repository to a thumb drive
- Follow the Arch wiki's installation instructions. Stop following the instructions after running `arch-chroot /mnt`
- Create a new user and give them sudo access
- Mount the thumb drive and move this repository to the home directory of the newly created user
- Switch to the new user
- Run setup-grub.sh
- Install emacs to tangle and edit setup.org
	- Make sure to change the drive referenced in the grub config
- Run `./setup.sh` from inside the repository
- Reboot the system

## Important Information:
- Consider enabling SSD Trim by running `sudo systemctl enable fstrim.timer`. This prevents write amplification and can lead to faster drives that live longer. Make sure to check `lsblk --discard` for non-zero values of `DISC-GRAN` and `DISC_MAX` before enabling. This starts up a weekly timer to trim your drive
- When `setup.sh` is installing base-devel, make sure to not install fakeroot if it is in IgnorePkg or IgnoreGroup
- After running `setup.sh` make sure to run :PlugInstall in neovim
- After running `setup.sh` make sure to run `M-x all-the-icons-install-fonts` in emacs.
- After running `setup.sh` make sure to run `bw login` so that bitwarden can be used in other applications such as bitwarden-rofi
- If you reach a "unknown trust" error from pacman. Try running `pacman-key --refresh-keys`
- If you reach a "corrupted GPG key" error from pacman. Try running `pacman -Sy archlinux-keyring`
- If you reach a "unable to lock database" error when the script runs pacman, run `sudo rm /var/lib/pacman/db.lck` and try the script again. This usually happens after force closing the script while it is running.
- To run EXWM (or any window manager) on WSL2 or in a podman container use Xephyr to create a nested X window. Specifically run `Xephyr -br -ac -noreset -screen 800x600 :1 &` followed by `DISPLAY=:1 emacs`
- To Setup Samba:
  - Setup a samba username and password by running `sudo smbpasswd -a <username>` and then entering your password
  - Edit the config for samba in setup.org to share your directory and then retangle setup.org
  - Enable the samba daemon by running `sudo systemctl enable --now samba`.
  - To connect to shared folder on a windows machine create a shorcut to `\\IP-ADDRESS\SHARE-NAME`
