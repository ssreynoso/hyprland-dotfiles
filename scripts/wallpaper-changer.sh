#!/bin/bash

# Directorio donde están tus wallpapers
WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Tiempo de espera entre cambios (en segundos)
# Por defecto: 300 segundos = 5 minutos
INTERVAL=${1:-300}

# Efectos de transición disponibles en swww
TRANSITIONS=("fade" "wipe" "grow" "outer" "random")

# Variables para control de cache y rotación
WALLPAPER_CACHE=()
WALLPAPER_INDEX=0
TRANSITION_SHUFFLED=()
TRANSITION_INDEX=0
CACHE_REFRESH_COUNT=0
CACHE_REFRESH_INTERVAL=50  # Refrescar cache cada 50 cambios de wallpaper

# Función para barajar wallpapers usando shuf
shuffle_wallpapers() {
    echo "Barajando lista de wallpapers..."
    local temp_file=$(mktemp)
    printf "%s\n" "${WALLPAPER_CACHE[@]}" > "$temp_file"
    mapfile -t WALLPAPER_CACHE < <(shuf "$temp_file")
    rm "$temp_file"
    WALLPAPER_INDEX=0
}

# Función para barajar transiciones
shuffle_transitions() {
    local temp_file=$(mktemp)
    printf "%s\n" "${TRANSITIONS[@]}" > "$temp_file"
    mapfile -t TRANSITION_SHUFFLED < <(shuf "$temp_file")
    rm "$temp_file"
    TRANSITION_INDEX=0
}

# Función para cargar y barajar la lista de wallpapers
load_wallpapers() {
    echo "Cargando lista de wallpapers..."
    mapfile -t WALLPAPER_CACHE < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \))

    if [ ${#WALLPAPER_CACHE[@]} -eq 0 ]; then
        echo "No se encontraron wallpapers en $WALLPAPER_DIR"
        return 1
    fi

    # Barajar el array
    shuffle_wallpapers
    echo "Cargados ${#WALLPAPER_CACHE[@]} wallpapers"
    return 0
}

# Cargar wallpapers inicial
load_wallpapers || exit 1

# Barajar transiciones inicial
shuffle_transitions

# Loop infinito para cambiar wallpapers
while true; do
    # Verificar si necesitamos refrescar el cache (para detectar nuevos wallpapers)
    if [ $CACHE_REFRESH_COUNT -ge $CACHE_REFRESH_INTERVAL ]; then
        load_wallpapers || exit 1
        CACHE_REFRESH_COUNT=0
    fi

    # Si llegamos al final de la lista de wallpapers, volver a barajar
    if [ $WALLPAPER_INDEX -ge ${#WALLPAPER_CACHE[@]} ]; then
        shuffle_wallpapers
        echo "Lista de wallpapers completada, barajando de nuevo..."
    fi

    # Si llegamos al final de las transiciones, volver a barajar
    if [ $TRANSITION_INDEX -ge ${#TRANSITION_SHUFFLED[@]} ]; then
        shuffle_transitions
        echo "Lista de transiciones completada, barajando de nuevo..."
    fi

    # Obtener wallpaper y transición actuales
    WALLPAPER="${WALLPAPER_CACHE[$WALLPAPER_INDEX]}"
    TRANSITION="${TRANSITION_SHUFFLED[$TRANSITION_INDEX]}"

    # Cambiar el wallpaper con swww
    swww img "$WALLPAPER" \
        --transition-type "$TRANSITION" \
        --transition-duration 1.2 \
        --transition-fps 60 \
        --resize fit

    echo "Wallpaper cambiado a: $(basename "$WALLPAPER") con transición: $TRANSITION"

    # Incrementar índices
    ((WALLPAPER_INDEX++))
    ((TRANSITION_INDEX++))
    ((CACHE_REFRESH_COUNT++))

    # Esperar el intervalo especificado
    sleep "$INTERVAL"
done
