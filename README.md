#nix-configuration
## Complete configuration and setup scripts for my current linux environment.

## Scripts: 
- `setup.sh` sets up a new system with my environment
- `update-hm.sh` updates home-manager to match`home.nix`
- `update-nixos.sh` updates nixos to match `configuration.nix`
- `podman.sh` builds the environment using a podman container

## Important Information:
- If p10k errors with `character not in range`:
    1. Verify that `en_US.UTF-8 UTF-8` is uncommented in `/etc/locale.gen`
    2. Run `local-gen`
    3. Run `echo "LANG=en_US.UTF-8" > /etc/locale.conf`
- When `setup.sh` is installing base-devel, make sure to not install fakeroot if it is in IgnorePkg or IgnoreGroup
- After running `setup.sh` make sure to run :PlugInstall in neovim
