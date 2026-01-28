#!/bin/bash
# morning-routine.sh - Rutina de inicio diario
# Ejecutar manualmente o agregar a autostart.conf

# Esperar a que Hyprland esté listo
sleep 2

# 1. Abrir la app de accountability
APP_PATH="$HOME/Desktop/Dev/projects/obsidian-accountability-dashboard/src-tauri/target/release/obsidian-accountability-dashboard"

if [ -f "$APP_PATH" ]; then
    nohup env WEBKIT_DISABLE_DMABUF_RENDERER=1 "$APP_PATH" >/tmp/obsidian-accountability-dashboard.log 2>&1 & disown
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
