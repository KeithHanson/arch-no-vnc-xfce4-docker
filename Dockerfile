FROM ubuntu:22.04

MAINTAINER keith <keith@keithhanson.io>

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for adding Mozilla apt repo
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    && install -d -m 0755 /etc/apt/keyrings \
    && curl -fsSL https://packages.mozilla.org/apt/repo-signing-key.gpg \
       | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null \
    && echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" \
       > /etc/apt/sources.list.d/mozilla.list \
    && echo 'Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000' \
       > /etc/apt/preferences.d/mozilla

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    xfce4 \
    xfce4-goodies \
    net-tools \
    python3 \
    python3-numpy \
    supervisor \
    terminator \
    vim \
    x11vnc \
    xorg \
    xvfb \
    dbus-x11 \
    sudo \
    adwaita-icon-theme \
    gir1.2-gdkpixbuf-2.0 \
    librsvg2-common \
    shared-mime-info \
    firefox \
    && apt-get purge -y xfce4-power-manager \
    && apt-get autoremove -y

# Create non-root user
RUN useradd -m -G sudo -s /bin/bash user
RUN echo 'user:user123' | chpasswd
RUN echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN mkdir -p /src/noVNC

WORKDIR /src

# Clone noVNC
RUN git clone https://github.com/novnc/noVNC.git

WORKDIR /home/user

# Set display environment
ENV DISPLAY=:0.0

# Expose noVNC port
EXPOSE 8080

ENV TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Copy supervisor configuration
COPY supervisord.ini /etc/supervisor/conf.d/supervisord.ini

WORKDIR /home/user

# Launch X11, x11vnc, xfce4 and noVNC from supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.ini"]
