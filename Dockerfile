FROM archlinux:latest
MAINTAINER keith <keith@keithhanson.io>

# Reset and reinitialize GPG keyring
RUN rm -rf /etc/pacman.d/gnupg
RUN pacman-key --init
RUN pacman-key --populate archlinux
RUN pacman-key --refresh-keys
RUN pacman -Syyu archlinux-keyring --noconfirm

# Install packages
RUN pacman -Sy --needed --noconfirm \
	    facter \
	    git \
	    base-devel \
	    xfce4 \
	    net-tools \
	    python \
	    python-numpy \
	    supervisor \
	    terminator \
	    vim \
	    x11vnc \
	    xorg-server \
	    xorg-server-xvfb \
	    adwaita-icon-theme gdk-pixbuf2 librsvg shared-mime-info \
	    elementary-icon-theme

# Update all packages
RUN pacman -Syu --noconfirm

# Create non-root user for yay
RUN useradd -m -G wheel -s /bin/bash user
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN mkdir src

WORKDIR src

RUN git clone https://github.com/novnc/noVNC.git

# Install yay as non-root user
USER user
WORKDIR /home/user
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm && \
    cd .. && \
    rm -rf yay

# Switch back to root for rest of setup
USER root
WORKDIR /src

# Not seems to work, but...
RUN export DISPLAY=:0.0

# Be sure that the noVNC port is exposed
EXPOSE 8080

ENV TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Prepare X11, x11vnc, mate and noVNC from supervisor
COPY supervisord.ini /etc/supervisor.d/supervisord.ini

WORKDIR /home/user

# Launch X11, x11vnc, mate and noVNC from supervisor
CMD ["sudo", "/usr/bin/supervisord"]
