# Ubuntu XFCE Desktop with noVNC

Docker container running Ubuntu 22.04 with XFCE4 desktop environment accessible via noVNC in a browser.

## Features

- XFCE4 desktop environment
- noVNC web-based VNC client
- Xvfb virtual X server
- D-Bus session support
- Non-root user setup

## Building

```bash
docker build -t ubuntu-novnc:latest .
```

## Running

Basic usage:

```bash
docker run --rm -p 8080:8080 -p 5900:5900 --name ubuntu-novnc ubuntu-novnc:latest
```

With user volume mount (recommended for persistent files):

```bash
docker run --rm -v ./user:/home/user -p 8080:8080 -p 5900:5900 --name ubuntu-novnc ubuntu-novnc:latest
```

## Accessing the Desktop

Open your browser and navigate to: `http://localhost:8080/vnc.html`

## Installing Additional Packages

To add packages, modify the `apt-get install` command in the Dockerfile before building.

## Ports

- `8080` - noVNC web interface
- `5900` - VNC server (direct VNC client access)
