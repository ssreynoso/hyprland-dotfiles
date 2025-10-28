#!/bin/bash

# Script para ajustar scroll_factor del touchpad según la ventana activa
# Si la ventana es Kitty, scroll_factor = valor alto
# Caso contrario, scroll_factor default = 0.1

handle() {
  case $1 in
    activewindow*)
      # Obtener clase de la ventana activa
      window_class=$(hyprctl activewindow -j | jq -r '.class')

      if [ "$window_class" = "kitty" ]; then
        hyprctl keyword input:touchpad:scroll_factor 2 > /dev/null
      else
        hyprctl keyword input:touchpad:scroll_factor 0.2 > /dev/null
      fi
      ;;
  esac
}

# Suscribirse al socket de eventos de Hyprland
socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
  handle "$line"
done
