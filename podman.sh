#! /bin/bash
username=user
password=password

args=(
    # --systemd=false
    # Set the hostname to something reasonable
    -h devEnv
    ## Open in an interactive mode and remove container after exit
    -it --rm
    # Disable SELinux label to enable mounting runtime socket
    --security-opt label=disable
    # Enable legacy X11
    -v /tmp/.X11-unix/:/tmp/.X11-unix/
    -e DISPLAY=$DISPLAY
    # Enable xdg runtime for wayland and pulseaudio socket
    -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY
    -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR
    -v $XDG_RUNTIME_DIR:$XDG_RUNTIME_DIR
    -e PULSE_SERVER=$XDG_RUNTIME_DIR/pulse/native
    # Setup DBUS
    -e DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/dbus-1"
    # Login with user
    --user=$(id -u):$(id -g)
    # fix XError bad access
    # --ipc host
)

image=$(sudo podman build -q . --build-arg username=${username})

sudo podman run ${args[@]} ${image}
