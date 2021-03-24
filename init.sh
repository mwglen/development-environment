sudo cp configuration.nix /etc/nixos/configuration.nix
sudo cp syschdemd.nix /etc/nixos/syschdemd.nix
sudo cp syschdemd.sh /etc/nixos/syschdemd.sh
sudo nixos-rebuild switch

mkdir -p /home/mwglen/.config/nixpkgs/p10k-config
cp home.nix ~/.config/nixpkgs/home.nix
cp p10k.zsh ~/.config/nixpkgs/p10k-config/p10k.zsh
home-manager switch
