# Update Ubuntu
sudo apt update && apt upgrade

# Install Nix
curl -L https://nixos.org/nix/install | sh

# Enable flakes
nix-env -iA nixpkgs.nixUnstable
echo "experimental-features = nix-command flakes" >> $HOME/.config/nix/nix.conf

# Remove apt's version of git
sudo apt remove git

# Initialize home-manager
./update-hm.sh

# Add zsh
echo "$HOME/.nix-profile/bin/zsh" | sudo tee -a /etc/shells
echo "chsh -s $HOME/.nix-profile/bin/zsh" >> $HOME/.bashrc
echo "source $HOME/.profile" | sudo tee -a $HOME/.zshrc
