#!/bin/bash

# Script para sincronizar repositorios de configuración
# Ejecutar a mano: ~/.config/hypr/scripts/sync-configs.sh

# Cargar repositorios desde archivo de configuración
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
REPOS=()
while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    REPOS+=("$line")
done < "$SCRIPT_DIR/repos.conf"

echo "==> Iniciando sincronización de configs..."
echo ""

for REPO in "${REPOS[@]}"; do
    if [ -d "$REPO/.git" ]; then
        REPO_NAME=$(basename "$REPO")
        cd "$REPO" || { echo "[ERROR] No se pudo entrar a $REPO"; continue; }

        echo "--- $REPO_NAME ---"

        # Verificar si hay cambios (staged, unstaged o untracked)
        if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
            echo "[!] $REPO_NAME tiene cambios sin commitear. Hacé commit o descartá los cambios primero."
            echo ""
            continue
        fi

        # Hacer pull
        echo "    Pulling desde origin/main..."
        PULL_OUTPUT=$(git pull origin main 2>&1)
        PULL_EXIT=$?

        if [ $PULL_EXIT -ne 0 ]; then
            echo "[ERROR] Falló el pull en $REPO_NAME:"
            echo "$PULL_OUTPUT"
        elif echo "$PULL_OUTPUT" | grep -q "Already up to date"; then
            echo "    Ya está actualizado, no hay nada nuevo."
        elif echo "$PULL_OUTPUT" | grep -q "Updating\|Fast-forward"; then
            echo "    Actualizado correctamente!"
        else
            echo "[ERROR] Respuesta inesperada al hacer pull en $REPO_NAME:"
            echo "$PULL_OUTPUT"
        fi

        echo ""
    else
        echo "[!] $REPO no es un repositorio git válido, saltando..."
        echo ""
    fi
done

echo "==> Sincronización completada."
