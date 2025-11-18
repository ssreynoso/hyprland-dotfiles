#!/usr/bin/env bash
# audio-device.sh
# Muestra el dispositivo de salida de audio por defecto
set -euo pipefail

# Verifica que wpctl esté disponible
command -v wpctl >/dev/null 2>&1 || { echo '{"text":"❌","tooltip":"wpctl no encontrado"}'; exit 1; }

# Obtiene el ID del sink por defecto (marcado con *)
default_sink_id=$(wpctl status | awk '
  /Sinks:/ { in_sinks=1; next }
  in_sinks && (/Sources:/ || /Filters:/ || /Video/ || /^$/) { exit }
  in_sinks && /\*/ {
    if (match($0, /([0-9]+)\./, m)) {
      print m[1]
      exit
    }
  }
')

if [[ -z "$default_sink_id" ]]; then
  echo '{"text":"🔇","tooltip":"No hay dispositivo por defecto"}'
  exit 0
fi

# Obtiene el nombre del dispositivo
device_name=$(wpctl status | awk -v id="$default_sink_id" '
  /Sinks:/ { in_sinks=1; next }
  in_sinks && (/Sources:/ || /Filters:/ || /Video/ || /^$/) { exit }
  in_sinks {
    if (match($0, /([0-9]+)\.\s+(.*)\s+\[vol:/, m)) {
      if (m[1] == id) {
        # Limpia el nombre (quita asterisco si existe)
        name = m[2]
        gsub(/^\*?\s*/, "", name)
        gsub(/\s+$/, "", name)
        print name
        exit
      }
    }
  }
')

# Acorta el nombre si es muy largo
short_name="$device_name"
if [[ ${#device_name} -gt 25 ]]; then
  short_name="${device_name:0:22}..."
fi

# Retorna JSON para Waybar
echo "{\"text\":\"🔊 $short_name\",\"tooltip\":\"$device_name\",\"class\":\"audio-device\"}"
