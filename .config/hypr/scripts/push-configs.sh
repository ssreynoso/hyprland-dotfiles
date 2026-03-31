#!/bin/bash

# Script para pushear repositorios de configuración
# Usa claude --print para generar mensajes de commit

# Cargar repositorios desde archivo de configuración
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
REPOS=()
while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    REPOS+=("$line")
done < "$SCRIPT_DIR/repos.conf"

echo "==> Iniciando push de configs..."
echo ""

for REPO in "${REPOS[@]}"; do
    if [ -d "$REPO/.git" ]; then
        REPO_NAME=$(basename "$REPO")
        cd "$REPO" || { echo "[ERROR] No se pudo entrar a $REPO"; continue; }

        echo "--- $REPO_NAME ---"

        # Verificar si hay cambios (staged, unstaged o untracked)
        if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
            echo "    Procesando cambios..."

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
                echo "    Commit: $COMMIT_MSG"

                # Hacer push
                PUSH_OUTPUT=$(git push 2>&1)

                if [ $? -eq 0 ]; then
                    echo "    Pusheado correctamente!"
                else
                    echo "[ERROR] Falló el push en $REPO_NAME:"
                    echo "$PUSH_OUTPUT"
                fi
            else
                echo "[ERROR] Falló el commit en $REPO_NAME"
            fi
        else
            echo "    Sin cambios, nada que pushear."
        fi

        echo ""
    else
        echo "[!] $REPO no es un repositorio git válido, saltando..."
        echo ""
    fi
done

echo "==> Push completado."
