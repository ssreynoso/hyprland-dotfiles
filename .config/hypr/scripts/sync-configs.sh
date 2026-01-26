#!/bin/bash

# Script para sincronizar repositorios de configuración al inicio
# Ejecutado por Hyprland exec-once

REPOS=(
    "/home/ssreynoso/obsidian/obsidian-main"
    "/home/ssreynoso/Desktop/Dev/projects/obsidian-accountability-dashboard"
    "/home/ssreynoso/Desktop/Dev/trabajo/Aislant/aislant-framework"
    "/home/ssreynoso/dotfiles"
    "/home/ssreynoso/dotfiles/.config/nvim"
    "/home/ssreynoso/Desktop/Dev/utils/db-queries"
)

# Fecha actual para el stash
FECHA=$(date +"%Y-%m-%d %H:%M:%S")

for REPO in "${REPOS[@]}"; do
    if [ -d "$REPO/.git" ]; then
        REPO_NAME=$(basename "$REPO")
        cd "$REPO" || continue

        # Verificar si hay cambios (staged, unstaged o untracked)
        if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
            notify-send "Config Sync" "Guardando cambios en $REPO_NAME..." -u normal -t 3000
            git stash save "$FECHA"
            notify-send "Config Sync" "Cambios guardados en stash: $REPO_NAME" -u normal -t 3000
        fi

        # Hacer pull después de limpiar el staging
        notify-send "Config Sync" "Actualizando $REPO_NAME..." -u normal -t 3000
        PULL_OUTPUT=$(git pull origin main 2>&1)

        if echo "$PULL_OUTPUT" | grep -q "Already up to date"; then
            notify-send "Config Sync" "$REPO_NAME ya está actualizado" -u low -t 3000
        elif echo "$PULL_OUTPUT" | grep -q "Updating\|Fast-forward"; then
            notify-send "Config Sync" "$REPO_NAME actualizado correctamente" -u normal -t 3000
        else
            notify-send "Config Sync" "Error al actualizar $REPO_NAME" -u critical -t 5000
        fi
    fi
done

notify-send "Config Sync" "Sincronización completada" -u low -t 2000
