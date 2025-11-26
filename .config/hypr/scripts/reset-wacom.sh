
#!/bin/bash
# Script para resetear la tableta Wacom al mapeo completo por defecto en Hyprland

# Borrar cualquier región configurada (vec2 con coma)
hyprctl keyword input:tablet:region_size "0, 0"
hyprctl keyword input:tablet:region_position "0, 0"
hyprctl keyword input:tablet:absolute_region_position 0

# Volver a output por defecto (auto / todos los monitores)
hyprctl keyword input:tablet:output ""

# Volver a modo absoluto normal, sin transformaciones raras
hyprctl keyword input:tablet:relative_input 0
hyprctl keyword input:tablet:left_handed 0
hyprctl keyword input:tablet:transform -1

# Usar TODA el área activa de la tableta (mm) – también vec2 con coma
hyprctl keyword input:tablet:active_area_size "0, 0"
hyprctl keyword input:tablet:active_area_position "0, 0"

notify-send "Wacom" "Tablet reseteada al mapeo completo por defecto" -t 2000 -u low
