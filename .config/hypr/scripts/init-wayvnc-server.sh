echo "Iniciando wayvnc en puerto 5900..." 
WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/1000 wayvnc -o HDMI-A-1 0.0.0.0 5900
echo "wayvnc terminó con código: $?"
