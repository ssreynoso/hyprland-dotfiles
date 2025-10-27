# Inventario de Software Instalado

Documentación completa de todos los paquetes instalados en el sistema Arch Linux con Hyprland.

**Última actualización:** 2025-10-27
**Total de paquetes:** 145 (135 oficiales + 10 AUR)

---

## Sistema Base

| Paquete | Versión | Descripción |
|---------|---------|-------------|
| base | 3-2 | Sistema base de Arch Linux |
| base-devel | 1-2 | Herramientas de desarrollo base |
| linux | 6.17.4.arch2-1 | Kernel Linux |
| linux-firmware | 20251021-1 | Firmware para hardware |
| intel-ucode | 20250812-1 | Microcode para CPUs Intel |
| grub | 2:2.12.r418.g6b5c671d-2 | Bootloader GRUB |
| efibootmgr | 18-3 | Gestor de boot EFI |
| zram-generator | 1.2.1-1 | Generador de swap comprimido en RAM |

---

## Hyprland y Entorno Wayland

| Paquete | Versión | Descripción |
|---------|---------|-------------|
| hyprland | 0.51.1-6 | Compositor Wayland dinámico |
| waybar | 0.14.0-3 | Barra de estado personalizable |
| kitty | 0.43.1-1 | Emulador de terminal acelerado por GPU |
| fuzzel | 1.13.1-1 | Lanzador de aplicaciones Wayland |
| wofi | 1.5.1-1 | Lanzador de aplicaciones alternativo |
| dunst | 1.13.0-1 | Demonio de notificaciones |
| swww | 0.11.2-1 | Cambiador de wallpapers animado |
| grim | 1.5.0-2 | Captura de pantalla Wayland |
| slurp | 1.5.0-1 | Selector de región para Wayland |
| wl-clipboard | 1:2.2.1-3 | Utilidades de portapapeles Wayland |
| xdg-desktop-portal-hyprland | 1.3.11-1 | Portal de escritorio para Hyprland |
| xdg-desktop-portal-gnome | 49.0-1 | Portal de escritorio GNOME |
| qt5-wayland | 5.15.17+kde+r57-1 | Soporte Qt5 para Wayland |
| qt6-wayland | 6.10.0-1 | Soporte Qt6 para Wayland |
| uwsm | 0.24.1-1 | Gestor de sesión Wayland universal |
| ly | 1.1.2-1 | Display manager TUI |
| polkit-kde-agent | 6.4.5-1 | Agente de autenticación |

---

## Desarrollo

| Paquete | Versión | Descripción |
|---------|---------|-------------|
| git | 2.51.1-2 | Sistema de control de versiones |
| neovim | 0.11.4-1 | Editor de texto extensible |
| vim | 9.1.1841-1 | Editor de texto Vi mejorado |
| visual-studio-code-bin | 1.105.1-1 | Editor de código de Microsoft (AUR) |
| cmake | 4.1.2-1 | Sistema de construcción multiplataforma |
| ninja | 1.13.1-2 | Sistema de construcción pequeño |
| gdb | 16.3-1 | Depurador GNU |
| docker | 1:28.5.1-1 | Plataforma de contenedores |
| docker-compose | 2.40.2-1 | Herramienta de orquestación de contenedores |
| postman-bin | 11.68.0-1 | Plataforma de API (AUR) |
| msodbcsql | 18.5.1.1-1 | Driver ODBC de Microsoft SQL Server (AUR) |
| mssql-tools | 18.4.1.1-1 | Herramientas de línea de comandos para SQL Server (AUR) |
| unixodbc | 2.3.14-1 | Gestor de drivers ODBC |

---

## Utilidades de Terminal

| Paquete | Versión | Descripción |
|---------|---------|-------------|
| btop | 1.4.5-1 | Monitor de recursos interactivo |
| htop | 3.4.1-1 | Visor de procesos interactivo |
| fzf | 0.66.0-1 | Buscador difuso de línea de comandos |
| nano | 8.6-1 | Editor de texto simple |
| less | 1:685-1 | Paginador de archivos |
| wget | 1.25.0-2 | Descargador de archivos de red |
| tcpdump | 4.99.5-1 | Analizador de paquetes de red |
| warp-terminal | v0.2025.10.22.08.13.stable_01-1 | Terminal moderno |
| brightnessctl | 0.5.1-3 | Control de brillo de pantalla |
| yay | 12.5.2-2 | AUR helper (AUR) |
| yay-debug | 12.5.2-2 | Símbolos de depuración para yay (AUR) |

---

## Aplicaciones de Productividad

| Paquete | Versión | Descripción |
|---------|---------|-------------|
| obsidian | 1.9.14-1 | App de toma de notas y knowledge base |
| dolphin | 25.08.2-1 | Gestor de archivos de KDE |
| nautilus | 49.1-2 | Gestor de archivos de GNOME |
| baobab | 49.0-1 | Analizador de uso de disco |
| simple-scan | 49.1-1 | Aplicación de escaneo |
| papers | 49.1-1 | Gestor de documentos |
| loupe | 49.1-1 | Visor de imágenes de GNOME |
| sushi | 46.0-2 | Vista previa rápida de archivos |

---

## Multimedia y Comunicación

| Paquete | Versión | Descripción |
|---------|---------|-------------|
| pipewire | 1:1.4.9-1 | Servidor multimedia |
| pipewire-alsa | 1:1.4.9-1 | Soporte ALSA para PipeWire |
| pipewire-jack | 1:1.4.9-1 | Soporte JACK para PipeWire |
| pipewire-pulse | 1:1.4.9-1 | Soporte PulseAudio para PipeWire |
| wireplumber | 0.5.12-1 | Gestor de sesión para PipeWire |
| libpulse | 17.0+r88+geee0e8f22-1 | Biblioteca cliente de PulseAudio |
| gst-plugin-pipewire | 1:1.4.9-1 | Plugin GStreamer para PipeWire |
| pavucontrol | 1:6.2-1 | Control de volumen PulseAudio |
| discord | 1:0.0.112-1 | Cliente de chat de voz y texto |
| spotify-launcher | 0.6.3-2 | Launcher para Spotify |
| decibels | 49.0-1 | Reproductor de audio |
| gnome-music | 1:49.1-1 | Reproductor de música de GNOME |
| snapshot | 49.0-1 | Aplicación de cámara |

---

## GNOME Apps y Componentes

| Paquete | Versión | Descripción |
|---------|---------|-------------|
| gnome-shell | 1:49.1-1 | Shell de GNOME |
| gnome-session | 49.1-1 | Gestor de sesión GNOME |
| gnome-settings-daemon | 49.1-1 | Demonio de configuración GNOME |
| gnome-keyring | 1:48.0-1 | Gestor de contraseñas GNOME |
| gnome-tweaks | 49.0-1 | Herramienta de personalización GNOME |
| gnome-calculator | 49.1.1-1 | Calculadora |
| gnome-calendar | 49.0.1-1 | Aplicación de calendario |
| gnome-characters | 49.1-1 | Mapa de caracteres |
| gnome-clocks | 49.0-1 | Relojes y temporizadores |
| gnome-color-manager | 3.36.2-1 | Gestor de perfiles de color |
| gnome-connections | 49.0-1 | Cliente de escritorio remoto |
| gnome-console | 49.1-1 | Terminal de GNOME |
| gnome-contacts | 49.0-1 | Gestor de contactos |
| gnome-disk-utility | 46.1-2 | Utilidad de discos |
| gnome-font-viewer | 49.0-1 | Visor de fuentes |
| gnome-logs | 49.0-1 | Visor de logs del sistema |
| gnome-maps | 49.2-1 | Aplicación de mapas |
| gnome-menus | 3.38.1-1 | Biblioteca de menús GNOME |
| gnome-remote-desktop | 49.1-1 | Servidor de escritorio remoto |
| gnome-software | 49.1-1 | Centro de software |
| gnome-system-monitor | 49.1-1 | Monitor del sistema |
| gnome-text-editor | 49.0-1 | Editor de texto simple |
| gnome-tour | 49.0-1 | Tour de bienvenida |
| gnome-user-docs | 49.1-1 | Documentación de usuario |
| gnome-user-share | 48.1-1 | Compartir archivos en red local |
| gnome-weather | 49.0-1 | Aplicación del clima |
| gnome-backgrounds | 49.0-1 | Fondos de pantalla de GNOME |
| gdm | 49.1-1 | Display manager de GNOME |
| orca | 49.4-1 | Lector de pantalla |
| tecla | 49.0-1 | Teclado en pantalla |
| yelp | 49.0-1 | Visor de ayuda |
| epiphany | 49.1-1 | Navegador web de GNOME |
| showtime | 49.0-1 | Reproductor de video |
| malcontent | 0.13.1-1 | Control parental |

---

## Red y Conectividad

| Paquete | Versión | Descripción |
|---------|---------|-------------|
| networkmanager | 1.54.1-1 | Gestor de red |
| network-manager-applet | 1.36.0-1 | Applet de NetworkManager |
| networkmanager-l2tp | 1.20.20-4 | Plugin L2TP para NetworkManager |
| iwd | 3.10-1 | Daemon inalámbrico de Intel |
| wireless_tools | 30.pre9-4 | Herramientas para redes inalámbricas |
| bluez | 5.84-1 | Stack Bluetooth de Linux |
| bluez-utils | 5.84-1 | Utilidades Bluetooth |
| blueman | 2.4.6-1 | Gestor Bluetooth GTK+ |
| strongswan | 6.0.2-1 | Suite VPN IPsec |
| xl2tpd | 1.3.19-1 | Daemon L2TP |
| remmina | 1:1.4.41-1 | Cliente de escritorio remoto |
| anydesk-bin | 7.1.0-1 | Software de escritorio remoto (AUR) |
| google-chrome | 141.0.7390.122-1 | Navegador web de Google (AUR) |

---

## Hardware y Drivers

| Paquete | Versión | Descripción |
|---------|---------|-------------|
| intel-media-driver | 25.3.4-1 | Driver de medios Intel VAAPI |
| libva-intel-driver | 2.4.1-5 | Driver VA-API para Intel |
| vulkan-intel | 1:25.2.5-1 | Driver Vulkan para Intel |
| vulkan-nouveau | 1:25.2.5-1 | Driver Vulkan para Nouveau |
| vulkan-radeon | 1:25.2.5-1 | Driver Vulkan para AMD |
| xf86-video-amdgpu | 25.0.0-1 | Driver X.org para AMD |
| xf86-video-ati | 1:22.0.0-2 | Driver X.org para ATI |
| xf86-video-nouveau | 1.0.18-1 | Driver X.org para Nouveau |
| sof-firmware | 2025.05.1-1 | Firmware de audio SOF |
| smartmontools | 7.5-1 | Herramientas de monitoreo de discos |
| power-profiles-daemon | 0.30-1 | Gestor de perfiles de energía |

---

## Fuentes

| Paquete | Versión | Descripción |
|---------|---------|-------------|
| ttf-firacode-nerd | 3.4.0-1 | Fuente FiraCode Nerd Font |
| ttf-nerd-fonts-symbols-mono | 3.4.0-1 | Símbolos Nerd Fonts monoespaciados |

---

## Otros

| Paquete | Versión | Descripción |
|---------|---------|-------------|
| gvfs | 1.58.0-2 | Sistema de archivos virtual |
| gvfs-afc | 1.58.0-2 | Backend AFC para GVFS (iOS) |
| gvfs-dnssd | 1.58.0-2 | Backend DNS-SD para GVFS |
| gvfs-goa | 1.58.0-2 | Backend GNOME Online Accounts |
| gvfs-google | 1.58.0-2 | Backend Google Drive |
| gvfs-gphoto2 | 1.58.0-2 | Backend gPhoto2 (cámaras) |
| gvfs-mtp | 1.58.0-2 | Backend MTP (dispositivos Android) |
| gvfs-nfs | 1.58.0-2 | Backend NFS |
| gvfs-onedrive | 1.58.0-2 | Backend OneDrive |
| gvfs-smb | 1.58.0-2 | Backend SMB/Samba |
| gvfs-wsdd | 1.58.0-2 | Backend WSDD |
| grilo-plugins | 1:0.3.18-1 | Plugins para framework Grilo |
| rygel | 1:45.0-1 | Servidor UPnP/DLNA |
| xdg-user-dirs-gtk | 0.14-1 | Herramienta GTK para directorios XDG |
| xdg-utils | 1.2.1-1 | Utilidades de escritorio XDG |
| xorg-server | 21.1.18-2 | Servidor X.Org (compatibilidad) |
| xorg-xinit | 1.4.4-1 | Inicialización de X.Org |
| yp-tools | 4.2.3-6 | Herramientas NIS/YP (AUR) |
| yp-tools-debug | 4.2.3-6 | Símbolos de depuración YP (AUR) |

---

## Comandos Útiles

### Listar paquetes instalados explícitamente
```bash
pacman -Qe
```

### Listar paquetes de AUR
```bash
yay -Qm
```

### Instalar todos los paquetes desde cero
```bash
# Paquetes oficiales
sudo pacman -S $(comm -12 <(pacman -Slq | sort) <(cat INSTALLED.md | grep -E '^\|' | awk -F'|' '{print $2}' | tr -d ' ' | sort))

# Paquetes AUR
yay -S anydesk-bin google-chrome msodbcsql mssql-tools postman-bin visual-studio-code-bin yay yay-debug yp-tools yp-tools-debug
```

### Generar lista actualizada de paquetes
```bash
pacman -Qe > packages.txt
yay -Qm > aur_packages.txt
```

---

**Nota:** Esta lista se genera automáticamente. Para mantenerla actualizada, ejecuta el script `./setup.sh --update-inventory` o regenera manualmente con los comandos de la sección anterior.
