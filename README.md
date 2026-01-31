# Arch Linux XFCE Desktop with noVNC

Docker container running Arch Linux with XFCE4 desktop environment accessible via noVNC in a browser.

## Features

- XFCE4 desktop environment
- noVNC web-based VNC client
- Xvfb virtual X server
- D-Bus session support
- Non-root user setup for AUR packages (yay)

## Building

```bash
docker build -t arch-novnc:latest .
```

## Running

Basic usage:

```bash
docker run --rm -p 8080:8080 -p 5900:5900 --name arch-novnc -e DISPLAY=:0.0 arch-novnc:latest
```

With user volume mount (recommended for persistent files):

```bash
docker run --rm -v ./user:/home/user -p 8080:8080 -p 5900:5900 --name arch-novnc -e DISPLAY=:0.0 arch-novnc:latest
```

## Accessing the Desktop

Open your browser and navigate to: `http://localhost:8080/vnc.html`

## Installing AUR Packages

The container includes `yay` for installing AUR packages. To add packages, uncomment and modify the yay install line in the Dockerfile before building.

```dockerfile
RUN yay -S --noconfirm --needed <your-package>
```

## Ports

- `8080` - noVNC web interface
- `5900` - VNC server (direct VNC client access)
