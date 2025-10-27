#!/usr/bin/env bash

# Script para alternar el estado del touchpad
TOUCHPAD_NAME="elan1200:00-04f3:309f-touchpad"
STATE_FILE="/tmp/touchpad_state"

# Verificar el estado actual
if [ -f "$STATE_FILE" ]; then
    CURRENT_STATE=$(cat "$STATE_FILE")
else
    CURRENT_STATE="enabled"
fi

# Función para detectar si hay un mouse externo conectado
has_external_mouse() {
    # Busca dispositivos que NO sean del touchpad integrado (elan1200)
    # Si encuentra algún mouse que no sea elan1200, significa que hay un mouse externo
    hyprctl devices | awk '/Mouse at/,/^$/' | grep -v "elan1200" | grep -q "[a-z0-9]:[a-z0-9]"
}

# Alternar el estado
if [ "$CURRENT_STATE" = "enabled" ]; then
    hyprctl keyword "device[$TOUCHPAD_NAME]:enabled" false

    # Solo ocultar cursor si NO hay mouse externo
    if ! has_external_mouse; then
        hyprctl keyword "cursor:no_hardware_cursors" true
        hyprctl keyword "cursor:hide_on_key_press" true
        notify-send "Touchpad" "Desactivado (cursor oculto)" -t 2000 -u low
    else
        notify-send "Touchpad" "Desactivado (mouse externo detectado)" -t 2000 -u low
    fi

    echo "disabled" > "$STATE_FILE"
else
    hyprctl keyword "device[$TOUCHPAD_NAME]:enabled" true
    hyprctl keyword "cursor:no_hardware_cursors" false
    hyprctl keyword "cursor:hide_on_key_press" false
    echo "enabled" > "$STATE_FILE"
    notify-send "Touchpad" "Activado" -t 2000 -u low
fi
