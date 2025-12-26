#!/usr/bin/env sh

# Uso: tomp4 input.mov output.mp4
# Convierte un .mov a .mp4 usando h264 para video y AAC para audio.

set -eu

if [ "$#" -ne 2 ]; then
  echo "Uso: tomp4 <input.mov> <output.mp4>"
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
  *.mp4|*.MP4) : ;;
  *)
    echo "Error: el output debe terminar en .mp4 (recibí: $OUTPUT)"
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

# Conversión a MP4 con h264:
# - Video: libx264 con preset medium y CRF 23 (buena calidad)
# - Audio: AAC a 192k
# - Pixel format yuv420p (máxima compatibilidad)
ffmpeg -y -hide_banner -loglevel error -i "$INPUT" \
  -c:v libx264 \
  -preset medium \
  -crf 23 \
  -pix_fmt yuv420p \
  -c:a aac \
  -b:a 192k \
  "$OUTPUT"

echo "OK: creado $OUTPUT"
