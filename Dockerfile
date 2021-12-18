# syntax=docker/dockerfile:1
FROM archlinux:latest
MAINTAINER "Matthew Glen" <mwg2202@gmail.com>

# Set username for non-root user
ARG username=user
ENV USERNAME=$username

# Set password for root
# ARG root_password=password
# ENV ROOT_PASSWORD=$root_password 
# ENV PASSWRD_ROOT=$root_password\n$root_password
# RUN echo ${PASSWRD_ROOT} | passwd

RUN pacman --noconfirm -Syyu sudo \
    fakeroot libnotify imv sysbench

RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN useradd -G wheel -m ${USERNAME}
RUN su ${USERNAME}

# Install Nix
RUN pacman --noconfirm -S nix
RUN systemctl enable nix-daemon.service
# CMD ["/usr/sbin/init"]

# RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable
# RUN nix-channel --update
# RUN nix-env -iA nixpkgs.nixUnstable
# RUN echo "experimental-features = nix-command flakes" \
#     >> $HOME/.config/nix/nix.conf

# Switch to zsh
# RUN echo "$HOME/.nix-profile/bin/zsh" | sudo tee -a /etc/shells
# RUN chsh -s $HOME/.nix-profile/bin/zsh
# RUN "source $HOME/.profile" | sudo tee -a $HOME/.zshrc

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/sbin/init"]
