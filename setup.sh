# Determine OS platform
export DISTRO=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
echo $DISTRO

# Set OS specific variables
if [ "$DISTRO" = "\"Arch Linux\"" ]; then 
    export PM_ADD="sudo yay -Syu"
    export PM_RMV="sudo yay -Rns"
    export PM_UPDATE="sudo yay -Syu"
fi

if [ "$DISTRO" = "Ubuntu" ]; then 
    export PM_ADD="sudo apt install"
    export PM_RMV="sudo apt remove"
    export PM_UPDATE="sudo apt update && apt upgrade"
fi

# Update Packages
$PM_UPDATE

# Install Nix
sudo curl -L https://nixos.org/nix/install | sh

# Enable flakes
nix-env -iA nixpkgs.nixUnstable
echo "experimental-features = nix-command flakes" >> $HOME/.config/nix/nix.conf

# Remove apt's version of git
$PM_RMV git

# Install home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
nix-shell '<home-manager>' -A install

# Initialize home-manager
./update-hm.sh

# Install NixGL (tells nix how to reach OpenGL and Vulkan APIs)
nix-channel --add https://github.com/guibou/nixGL/archive/main.tar.gz nixgl
nix-channel --update

# Add zsh to list of available shells
echo "$HOME/.nix-profile/bin/zsh" | sudo tee -a /etc/shells

# Change default shell to ZSH
chsh -s $HOME/.nix-profile/bin/zsh
