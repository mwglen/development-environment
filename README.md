#nix-configuration
## Complete configuration and setup scripts for my current linux environment.

## Scripts: 
    - `setup.sh` sets up a new system with my environment
    - `update-hm.sh` rebuilds home-manager from`home.nix`
    - `update-nixos.sh` rebuilds nixos from `configuration.nix`

## To Do List:
    - System wide audio support through home-manager
    - System wide GPU support through home-manager (NVIDIA Proprietary)
    - Working SSH-agent service through home-manager

## Common Issues
    - If p10k errors with `character not in range`:
        1. Verify that `en_US.UTF-8 UTF-8` is uncommented in `/etc/locale.gen`
        2. Run `local-gen`
        3. Run `echo "LANG=en_US.UTF-8" > /etc/locale.conf`

