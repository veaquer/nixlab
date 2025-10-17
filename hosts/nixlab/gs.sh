#!/usr/bin/env bash
set -xeuo pipefail

gamescopeArgs=(
    --adaptive-sync # VRR support
    --hdr-enabled
    --mangoapp # performance overlay
    --rt
    --steam
)
steamArgs=(
    -pipewire-dmabuf
)
mangoConfig=(
    cpu_temp
    gpu_temp
    ram
    vram
)
mangoVars=(
    MANGOHUD=1
    MANGOHUD_CONFIG="$(IFS=,; echo "${mangoConfig[*]}")"
)

export XDG_CURRENT_DESKTOP=gamescope
export XDG_SESSION_TYPE=x11
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"


export "${mangoVars[@]}"
exec gamescope "${gamescopeArgs[@]}" -- steam "${steamArgs[@]}"
