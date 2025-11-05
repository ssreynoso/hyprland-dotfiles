#!/usr/bin/env bash
set -euo pipefail

# bind = $mainMod, SPACE, exec, bash -lc 'hyprctl dispatch togglefloating; hyprctl dispatch resizeactive exact 1200 800; hyprctl dispatch centerwindow'

# Detecta si la ventana activa está en modo flotante
if hyprctl activewindow -j | grep -q '"floating":false'; then
    # Fuerza flotante y luego redimensiona + centra en una sola llamada
    hyprctl --batch "dispatch setfloating active; dispatch resizeactive exact 1200 800; dispatch centerwindow"
else
    hyprctl dispatch togglefloating
fi

