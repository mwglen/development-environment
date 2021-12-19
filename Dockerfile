# syntax=docker/dockerfile:1
FROM archlinux:latest
MAINTAINER "Matthew Glen" <mwg2202@gmail.com>

# Set username for non-root user
ARG username=user
ENV USERNAME=$username

# Install basic packages
RUN pacman --noconfirm -Syyu sudo

# Add and switch to a user with sudo access 
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN useradd -G wheel -m ${USERNAME}
USER $username
WORKDIR /home/$username

# Run the setup script
ADD ./setup.sh /home/"$username"/setup.sh
RUN sudo chmod +x /home/${USERNAME}/setup.sh
RUN . /home/${USERNAME}/setup.sh

# Open zsh on startup
CMD ["/usr/sbin/zsh"]
