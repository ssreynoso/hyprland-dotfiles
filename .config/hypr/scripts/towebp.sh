#!/usr/bin/env sh

# Uso: towebp input.mov output.webp
# Convierte un .mov (por ejemplo ProRes/DNxHR exportado desde DaVinci) a WebP animado apto para stickers.

set -eu

if [ "$#" -ne 2 ]; then
  echo "Uso: towebp <input.mov> <output.webp>"
  exit 1
fi

INPUT="$1"
OUTPUT="$2"

if [ ! -f "$INPUT" ]; then
  echo "Error: el archivo de entrada no existe: $INPUT"
  exit 1
fi

# Validar extensión (simple, por nombre)
case "$INPUT" in
  *.mov|*.MOV) : ;;
  *)
    echo "Error: el input debe ser .mov (recibí: $INPUT)"
    exit 1
    ;;
esac

case "$OUTPUT" in
  *.webp|*.WEBP) : ;;
  *)
    echo "Error: el output debe terminar en .webp (recibí: $OUTPUT)"
    exit 1
    ;;
esac

# Validar que ffmpeg exista
if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "Error: no se encontró 'ffmpeg' en el PATH. Instalalo y reintentá."
  exit 1
fi

# Validar que el archivo tenga stream de video
if ! ffprobe -v error -select_streams v:0 -show_entries stream=codec_type -of csv=p=0 "$INPUT" 2>/dev/null | grep -q "video"; then
  echo "Error: el archivo no tiene un stream de video válido: $INPUT"
  exit 1
fi

# Conversión a WebP animado para WhatsApp:
# - Escala max 512x512 manteniendo aspecto
# - FPS 15 (buen balance calidad/peso)
# - Sin audio
# - Loop infinito
ffmpeg -y -hide_banner -loglevel error -i "$INPUT" \
  -an \
  -vf "scale=512:512:force_original_aspect_ratio=decrease,fps=15" \
  -loop 0 \
  "$OUTPUT"

echo "OK: creado $OUTPUT"
