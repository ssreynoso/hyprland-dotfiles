#!/bin/bash

# Script para ver el estado de todos los repositorios de configuración
# Genera un resumen con claude --print al final

# Cargar repositorios desde archivo de configuración
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
REPOS=()
while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    REPOS+=("$line")
done < "$SCRIPT_DIR/repos.conf"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Arrays para almacenar info de repos
declare -a DIRTY_REPOS
declare -a CLEAN_REPOS

# Acumulador para el resumen de Claude
FULL_STATUS=""

# Primera pasada: recolectar info de todos los repos
for REPO in "${REPOS[@]}"; do
    if [ -d "$REPO/.git" ]; then
        REPO_NAME=$(basename "$REPO")
        cd "$REPO" || continue

        # Branch actual
        BRANCH=$(git branch --show-current)

        # Cambios locales
        STAGED=$(git diff --cached --numstat | wc -l)
        UNSTAGED=$(git diff --numstat | wc -l)
        UNTRACKED=$(git ls-files --others --exclude-standard | wc -l)

        # Commits adelante/atrás del remote
        git fetch --quiet 2>/dev/null
        AHEAD=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
        BEHIND=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")

        # Último commit
        LAST_COMMIT=$(git log -1 --format="%s" 2>/dev/null)
        LAST_DATE=$(git log -1 --format="%ar" 2>/dev/null)

        # Stashes
        STASH_COUNT=$(git stash list | wc -l)

        # Construir output del repo
        OUTPUT="${YELLOW}▶ $REPO_NAME${NC}\n"
        OUTPUT+="  ${BLUE}Path:${NC} $REPO\n"
        OUTPUT+="  ${BLUE}Branch:${NC} $BRANCH\n"

        if [ "$STAGED" -gt 0 ] || [ "$UNSTAGED" -gt 0 ] || [ "$UNTRACKED" -gt 0 ]; then
            OUTPUT+="  ${BLUE}Cambios:${NC} ${RED}staged=$STAGED unstaged=$UNSTAGED untracked=$UNTRACKED${NC}\n"
        else
            OUTPUT+="  ${BLUE}Cambios:${NC} ${GREEN}limpio${NC}\n"
        fi

        if [ "$AHEAD" -gt 0 ] || [ "$BEHIND" -gt 0 ]; then
            OUTPUT+="  ${BLUE}Sync:${NC} ${YELLOW}↑$AHEAD ↓$BEHIND${NC}\n"
        else
            OUTPUT+="  ${BLUE}Sync:${NC} ${GREEN}sincronizado${NC}\n"
        fi

        OUTPUT+="  ${BLUE}Último commit:${NC} $LAST_COMMIT (${LAST_DATE})\n"

        if [ "$STASH_COUNT" -gt 0 ]; then
            OUTPUT+="  ${BLUE}Stashes:${NC} ${YELLOW}$STASH_COUNT${NC}\n"
        fi

        # Determinar si tiene cambios pendientes
        if [ "$STAGED" -gt 0 ] || [ "$UNSTAGED" -gt 0 ] || [ "$UNTRACKED" -gt 0 ] || [ "$AHEAD" -gt 0 ] || [ "$BEHIND" -gt 0 ]; then
            DIRTY_REPOS+=("$OUTPUT")
        else
            CLEAN_REPOS+=("$OUTPUT")
        fi

        # Agregar al resumen para Claude
        FULL_STATUS+="$REPO_NAME: branch=$BRANCH, staged=$STAGED, unstaged=$UNSTAGED, untracked=$UNTRACKED, ahead=$AHEAD, behind=$BEHIND, stashes=$STASH_COUNT, último_commit='$LAST_COMMIT' ($LAST_DATE)
"
    else
        REPO_NAME=$(basename "$REPO")
        DIRTY_REPOS+=("${RED}✗ $REPO_NAME - No es un repositorio git${NC}\n")
        FULL_STATUS+="$REPO_NAME: NO ES REPOSITORIO GIT
"
    fi
done

# Mostrar resultados ordenados
echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}                    STATUS DE REPOSITORIOS                    ${NC}"
echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
echo ""

# Primero los repos con cambios
if [ ${#DIRTY_REPOS[@]} -gt 0 ]; then
    for OUTPUT in "${DIRTY_REPOS[@]}"; do
        echo -e "$OUTPUT"
    done
fi

# Separador y repos limpios
if [ ${#CLEAN_REPOS[@]} -gt 0 ]; then
    if [ ${#DIRTY_REPOS[@]} -gt 0 ]; then
        echo -e "${BLUE}──────────────────────────────────────────────────────────────${NC}"
        echo -e "${BLUE}                     REPOSITORIOS LIMPIOS                     ${NC}"
        echo -e "${BLUE}──────────────────────────────────────────────────────────────${NC}"
        echo ""
    fi
    for OUTPUT in "${CLEAN_REPOS[@]}"; do
        echo -e "$OUTPUT"
    done
fi

echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}                      RESUMEN (Claude)                        ${NC}"
echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
echo ""

PROMPT="Analiza el estado de estos repositorios y dame un resumen muy breve y directo en español. Indica cuáles necesitan atención (push, pull, cambios sin commitear) y cuáles están bien. Máximo 5 líneas:

$FULL_STATUS"

RESUMEN=$(claude --print "$PROMPT" 2>/dev/null | tr -d '\r' | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g')

if [ -n "$RESUMEN" ]; then
    echo -e "${GREEN}$RESUMEN${NC}"
else
    echo -e "${YELLOW}No se pudo generar resumen con Claude${NC}"
fi

echo ""
