#!/bin/bash

# Script para pushear repositorios de configuración
# Usa claude --print para generar mensajes de commit

REPOS=(
    "/home/ssreynoso/obsidian/obsidian-main"
    "/home/ssreynoso/Desktop/Dev/projects/obsidian-accountability-dashboard"
    "/home/ssreynoso/Desktop/Dev/trabajo/Aislant/aislant-framework"
    "/home/ssreynoso/dotfiles"
    "/home/ssreynoso/.config/nvim"
)

for REPO in "${REPOS[@]}"; do
    if [ -d "$REPO/.git" ]; then
        REPO_NAME=$(basename "$REPO")
        cd "$REPO" || continue

        # Verificar si hay cambios (staged, unstaged o untracked)
        if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
            notify-send "Config Push" "Procesando cambios en $REPO_NAME..." -u normal -t 3000

            # Agregar todos los cambios
            git add -A

            # Obtener el diff para el commit message
            DIFF=$(git diff --cached --stat)

            # Generar mensaje de commit con claude
            PROMPT="Genera un mensaje de commit conciso en español para estos cambios. Solo responde con el mensaje, sin explicaciones adicionales ni comillas:

$DIFF"

            COMMIT_MSG=$(claude --print "$PROMPT" 2>/dev/null | tr -d '\r' | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' | sed '/^$/d' | head -1)

            # Si claude falla, usar mensaje genérico
            if [ -z "$COMMIT_MSG" ]; then
                COMMIT_MSG="Actualiza $REPO_NAME"
            fi

            # Hacer commit
            git commit -m "$COMMIT_MSG"

            if [ $? -eq 0 ]; then
                notify-send "Config Push" "Commit en $REPO_NAME: $COMMIT_MSG" -u normal -t 3000

                # Hacer push
                PUSH_OUTPUT=$(git push 2>&1)

                if [ $? -eq 0 ]; then
                    notify-send "Config Push" "$REPO_NAME pusheado correctamente" -u normal -t 3000
                else
                    notify-send "Config Push" "Error al pushear $REPO_NAME" -u critical -t 5000
                fi
            else
                notify-send "Config Push" "Error en commit de $REPO_NAME" -u critical -t 5000
            fi
        else
            notify-send "Config Push" "$REPO_NAME sin cambios" -u low -t 2000
        fi
    fi
done

notify-send "Config Push" "Push completado" -u low -t 2000
