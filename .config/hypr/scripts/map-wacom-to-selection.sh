#!/bin/bash
# Script para mapear la Wacom a un área seleccionada manualmente con slurp
# Uso sugerido: bind = SUPER_SHIFT, E, exec, ~/.config/hypr/scripts/wacom-map-selection.sh

########################################
# CONFIG
########################################

# 0 = usar exactamente el rectángulo que selecciones (sin respetar aspect ratio)
# 1 = respetar el aspect ratio de la Wacom, usando TODO el ancho de la selección
#     y centrando verticalmente (aunque se recorte por arriba/abajo)
KEEP_ASPECT=0

# Dimensiones de la Wacom Intuos S (en mm)
TABLET_WIDTH_MM=152
TABLET_HEIGHT_MM=95

########################################
# 1. Seleccionar área con slurp
########################################

# slurp devuelve algo tipo: "x,y widthxheight", por ejemplo: "320,180 1280x720"
geom=$(slurp) || exit 1

# Separar en "pos" y "size"
pos_part=${geom%% *}      # "x,y"
size_part=${geom##* }     # "widthxheight"

sel_x=${pos_part%%,*}
sel_y=${pos_part##*,}

sel_w=${size_part%x*}
sel_h=${size_part#*x}

if [ -z "$sel_w" ] || [ -z "$sel_h" ]; then
    notify-send "Wacom" "Error: selección inválida" -t 2000 -u low
    exit 1
fi

########################################
# 2. Calcular región según modo
########################################

# Por defecto: usar el rectángulo tal cual lo seleccionaste
region_x="$sel_x"
region_y="$sel_y"
region_w="$sel_w"
region_h="$sel_h"

if [ "$KEEP_ASPECT" -eq 1 ]; then
    # Queremos SIEMPRE que el ancho de la región sea el ancho de la selección
    region_w="$sel_w"

    # Alto necesario para mantener el aspect ratio de la Wacom:
    # region_h = width * (tablet_h / tablet_w)
    region_h=$(awk -v w="$region_w" -v tw="$TABLET_WIDTH_MM" -v th="$TABLET_HEIGHT_MM" \
        'BEGIN { printf "%d", w * th / tw }')

    # Horizontalmente coincide con la selección
    region_x="$sel_x"

    # Centrado vertical respecto a la SELECCIÓN (no a toda la pantalla)
    # Si la altura ajustada es mayor, se “sale” por arriba/abajo de lo que marcaste.
    if [ "$region_h" -le "$sel_h" ]; then
        offset_y=$(awk -v sh="$sel_h" -v rh="$region_h" \
            'BEGIN { printf "%d", (sh - rh) / 2 }')
        region_y=$((sel_y + offset_y))
    else
        offset_y=$(awk -v sh="$sel_h" -v rh="$region_h" \
            'BEGIN { printf "%d", (rh - sh) / 2 }')
        region_y=$((sel_y - offset_y))
    fi
fi

########################################
# 3. Limpiar cosas raras del tablet (por las dudas)
########################################

hyprctl keyword input:tablet:relative_input 0
hyprctl keyword input:tablet:left_handed 0
hyprctl keyword input:tablet:transform -1
hyprctl keyword input:tablet:active_area_size "0, 0"
hyprctl keyword input:tablet:active_area_position "0, 0"

########################################
# 4. Config base y región
########################################

# Sin output fijo, posición absoluta en el layout de monitores
hyprctl keyword input:tablet:output ""
hyprctl keyword input:tablet:absolute_region_position 1

# vec2 con coma
hyprctl keyword input:tablet:region_position "${region_x}, ${region_y}"
hyprctl keyword input:tablet:region_size "${region_w}, ${region_h}"

########################################
# 5. Notificación
########################################

notify-send "Wacom" "Mapeada a selección (${region_w}x${region_h}px) [KEEP_ASPECT=${KEEP_ASPECT}]" -t 2000 -u low
