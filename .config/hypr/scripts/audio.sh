
#!/usr/bin/env bash
# switch-audio.sh
# Requiere: wpctl, pw-dump (PipeWire), jq, fzf
set -euo pipefail

MOVE_STREAMS=false
if [[ "${1-}" == "-m" || "${1-}" == "--move" ]]; then
  MOVE_STREAMS=true
fi

# Verifica dependencias
command -v wpctl   >/dev/null 2>&1 || { echo "wpctl no encontrado. PipeWire/WirePlumber es requerido."; exit 1; }
command -v pw-dump >/dev/null 2>&1 || { echo "pw-dump no encontrado. PipeWire es requerido."; exit 1; }
command -v jq      >/dev/null 2>&1 || { echo "jq no encontrado. Instalalo (sudo pacman -S jq)."; exit 1; }
command -v fzf     >/dev/null 2>&1 || { echo "fzf no encontrado. Instalalo (sudo pacman -S fzf)."; exit 1; }

# Lista nodos Audio/Sink reales (excluye Audio/Sink/Internal que falla con wpctl set-default)
mapfile -t sinks < <(
  pw-dump | jq -r '
    .[]
    | select(.type == "PipeWire:Interface:Node")
    | select(.info.props["media.class"] == "Audio/Sink")
    | "\(.id)\t\(.info.props["node.description"] // .info.props["node.nick"] // .info.props["node.name"])"
  '
)

if [[ "${#sinks[@]}" -eq 0 ]]; then
  echo "No se encontraron dispositivos de salida."
  exit 1
fi

# Selector con fzf (muestra "ID  Nombre")
selection="$(printf "%s\n" "${sinks[@]}" | awk -F'\t' '{printf "%-5s %s\n", $1, $2}' | \
  fzf --prompt="Elegí dispositivo de salida: " --height=40% --reverse --border)"

[[ -z "$selection" ]] && exit 0

# Obtiene el ID (primer campo)
sink_id="$(awk '{print $1}' <<< "$selection")"

# Cambia el default global
wpctl set-default "$sink_id"

# Mueve streams actuales al nuevo sink (opcional)
if $MOVE_STREAMS; then
  # Captura IDs de "Sink endpoints" (streams de salida actuales)
  mapfile -t stream_ids < <(
    wpctl status | awk '
      /Sink endpoints:/ { in_endp=1; next }
      in_endp && (/Source endpoints:/ || /Video/ || /Filters:/ || /^$/) { exit }
      in_endp {
        if (match($0, /([0-9]+)\./, m)) {
          print m[1]
        }
      }
    '
  )
  for sid in "${stream_ids[@]}"; do
    wpctl move-stream "$sid" "$sink_id" || true
  done
fi

# Feedback
new_name="$(printf "%s\n" "${sinks[@]}" | awk -F'\t' -v id="$sink_id" '$1==id{print $2}')"
echo "✔ Dispositivo por defecto: [$sink_id] $new_name"
$MOVE_STREAMS && echo "✔ Streams movidos al nuevo sink"
