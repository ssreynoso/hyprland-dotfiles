#!/usr/bin/env sh

# Uso: tomov input.mp4 output.mov

if [ "$#" -ne 2 ]; then
  echo "Uso: tomov <input_video> <output_video>"
  exit 1
fi

INPUT="$1"
OUTPUT="$2"

if [ ! -f "$INPUT" ]; then
  echo "Error: el archivo de entrada no existe: $INPUT"
  exit 1
fi

ffmpeg -y -i "$INPUT" \
  -c:v dnxhd \
  -profile:v dnxhr_hq \
  -pix_fmt yuv422p \
  -r 30 \
  -c:a pcm_s16le \
  "$OUTPUT"
