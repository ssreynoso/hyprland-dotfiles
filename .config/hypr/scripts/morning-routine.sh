#!/bin/bash
# morning-routine.sh - Rutina de inicio diario
# Ejecutar manualmente o agregar a autostart.conf

# Esperar a que Hyprland esté listo
sleep 2

# 1. Cambiar al workspace especial
hyprctl dispatch togglespecialworkspace

# 2. Abrir la app de accountability
APP_PATH="$HOME/Desktop/Dev/projects/obsidian-accountability-dashboard/src-tauri/target/release/obsidian-accountability-dashboard"

if [ -f "$APP_PATH" ]; then
    $APP_PATH &
    sleep 2
    # Hacer fullscreen la ventana
    hyprctl dispatch fullscreen 1
else
    echo "App no encontrada en $APP_PATH"
    echo "Ejecutá 'pnpm tauri:build' en el proyecto primero"
fi

# 3. Abrir browser con tabs de Notion
google-chrome-stable --new-window \
    "https://www.notion.so/sreynoso/Brain-1af72ac2cb1e46f28d6aec63ac023c2c" \
    "https://calendar.notion.so/" &

# 4. Abrir terminal
kitty &

echo "Morning routine completada!"
