# development-environment
## Complete configuration and setup scripts for my current linux environment.

## Loading my configuration on a clean Arch Linux install:
- Run `./setup.sh` from inside the repository
- Reboot the system

## Loading my configuration on a Podman Container:
- Run `./podman.sh` from inside the repository

## Important Information:
- When `setup.sh` is installing base-devel, make sure to not install fakeroot if it is in IgnorePkg or IgnoreGroup
- After running `setup.sh` make sure to run :PlugInstall in neovim
- After running `setup.sh` make sure to run `M-x all-the-icons-install-fonts` in emacs.
- If you reach a "unable to lock database" error when the script runs pacman, run `sudo rm /var/lib/pacman/db.lck` and try the script again. This usually happens after force closing the script while it is running.
- To run EXWM (or any window manager) on WSL2 or in a podman container use Xephyr to create a nested X window. Specifically run `Xephyr -br -ac -noreset -screen 800x600 :1 &` followed by `DISPLAY=:1 emacs`