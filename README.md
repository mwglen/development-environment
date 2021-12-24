#development-environment
## Complete configuration and setup scripts for my current linux environment.

## Scripts: 
- `setup.sh` sets up a new system with my environment
- `podman.sh` builds the environment using a podman container

## Loading my configuration on a clean Arch Linux install:
- Run `./setup.sh` from inside the repository
- Run `emacs`
- After emacs finishes installing packages (some error messages are to be expected) enter `M-x all-the-icons-install-fonts`
- Restart emacs and verify that no errors are shown and the the icons on the modeline are visible.

## Loading my configuration on a Podman Container:
- Run `./podman.sh` from inside the repository
- Run `emacs`
- After emacs finishes installing packages (some error messages are to be expected) enter `M-x all-the-icons-install-fonts`
- Restart emacs and verify that no errors are shown and the the icons on the modeline are visible.
- After closing emacs, run `Xephyr -br -ac -noreset -screen 800x600 :1` to start a new display.
- Open emacs on this display using `DISPLAY=:1 emacs`

## Important Information:
- If p10k errors with `character not in range`:
    1. Verify that `en_US.UTF-8 UTF-8` is uncommented in `/etc/locale.gen`
    2. Run `local-gen`
    3. Run `echo "LANG=en_US.UTF-8" > /etc/locale.conf`
- When `setup.sh` is installing base-devel, make sure to not install fakeroot if it is in IgnorePkg or IgnoreGroup
- After running `setup.sh` make sure to run :PlugInstall in neovim
- If you reach a "unable to lock database" error when the script runs pacman, run `sudo rm /var/lib/pacman/db.lck` and try the script again
- The scripts will not enable systemd services if it detects that you are installing on WSL.
- To run EXWM (or any window manager) on WSL2 or in a podman container use Xephyr to create a nested X window. Specifically run `Xephyr -br -ac -noreset -screen 800x600 :1 &` followed by `DISPLAY=:1 emacs`
