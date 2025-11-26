
#!/bin/bash
# Script para mapear la tableta Wacom al área de la ventana activa en Hyprland
# Uso sugerido: bind = SUPER_SHIFT, W, exec, ~/.local/bin/wacom-map-active-window.sh

########################################
# CONFIG
########################################

# 0 = usar toda la ventana (sin respetar aspect ratio)
# 1 = respetar el aspect ratio de la Wacom, usando TODO el ancho de la ventana
#     y centrando verticalmente (aunque se recorte por arriba/abajo)
KEEP_ASPECT=1

# Dimensiones de la Wacom Intuos S (en mm)
TABLET_WIDTH_MM=152
TABLET_HEIGHT_MM=95

########################################
# 1. Info de la ventana activa
########################################

window_info=$(hyprctl activewindow)

window_x=$(echo "$window_info" | grep -E "^\s*at:"   | awk '{print $2}' | cut -d',' -f1)
window_y=$(echo "$window_info" | grep -E "^\s*at:"   | awk '{print $2}' | cut -d',' -f2)
window_width=$(echo "$window_info"  | grep -E "^\s*size:" | awk '{print $2}' | cut -d'x' -f1)
window_height=$(echo "$window_info" | grep -E "^\s*size:" | awk '{print $2}' | cut -d'x' -f2)

if [ -z "$window_width" ] || [ -z "$window_height" ]; then
    notify-send "Wacom" "Error: no se pudo obtener información de la ventana activa" -t 2000 -u low
    exit 1
fi

########################################
# 2. Calcular región según modo
########################################

# Por defecto: usar toda la ventana
region_x="$window_x"
region_y="$window_y"
region_w="$window_width"
region_h="$window_height"

if [ "$KEEP_ASPECT" -eq 1 ]; then
    # Queremos SIEMPRE que el ancho de la región sea el ancho de la ventana
    region_w="$window_width"

    # Alto necesario para mantener el aspect ratio de la Wacom
    # region_h = width * (tablet_h / tablet_w)
    region_h=$(awk -v w="$window_width" -v tw="$TABLET_WIDTH_MM" -v th="$TABLET_HEIGHT_MM" \
        'BEGIN { printf "%d", w * th / tw }')

    # Horizontalmente coincide con la ventana
    region_x="$window_x"

    # Centrado vertical:
    # - Si region_h <= window_height: queda completamente dentro (letterbox)
    # - Si region_h  > window_height: sobresale y se recorta, pero queda centrada
    if [ "$region_h" -le "$window_height" ]; then
        offset_y=$(awk -v wh="$window_height" -v rh="$region_h" \
            'BEGIN { printf "%d", (wh - rh) / 2 }')
        region_y=$((window_y + offset_y))
    else
        offset_y=$(awk -v wh="$window_height" -v rh="$region_h" \
            'BEGIN { printf "%d", (rh - wh) / 2 }')
        region_y=$((window_y - offset_y))
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

# Sin output fijo, posición absoluta en el layout
hyprctl keyword input:tablet:output ""
hyprctl keyword input:tablet:absolute_region_position 1

# vec2 con coma
hyprctl keyword input:tablet:region_position "${region_x}, ${region_y}"
hyprctl keyword input:tablet:region_size "${region_w}, ${region_h}"

########################################
# 5. Notificación (para debug visual rápido)
########################################

window_title=$(echo "$window_info" | grep "title:" | sed 's/.*title: //' | cut -c1-40)
notify-send "Wacom" "Mapeada a: $window_title (${region_w}x${region_h}px) [KEEP_ASPECT=${KEEP_ASPECT}]" -t 2000 -u low
