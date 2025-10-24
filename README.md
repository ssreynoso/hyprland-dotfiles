# Dotfiles

Repositorio de configuraciones personales para Arch Linux con Hyprland.

## Contenido

### Configuraciones incluidas

- **Hyprland** - Compositor Wayland
- **Waybar** - Barra de estado
- **Kitty** - Emulador de terminal
- **Fuzzel** - Lanzador de aplicaciones
- **Neovim** - Editor de texto
- **btop** - Monitor de sistema
- **bashrc** - Configuración de Bash

## Instalación

### Prerequisitos

Asegúrate de tener instalados los siguientes paquetes:

```bash
sudo pacman -S hyprland waybar kitty fuzzel neovim btop
```

### Restaurar configuraciones

1. Clona este repositorio:
```bash
git clone <url-del-repo> ~/dotfiles
cd ~/dotfiles
```

2. Haz backup de tus configuraciones actuales (si las tienes):
```bash
mv ~/.config/hypr ~/.config/hypr.backup
mv ~/.config/waybar ~/.config/waybar.backup
mv ~/.config/kitty ~/.config/kitty.backup
mv ~/.config/fuzzel ~/.config/fuzzel.backup
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.config/btop ~/.config/btop.backup
mv ~/.bashrc ~/.bashrc.backup
```

3. Copia las configuraciones:
```bash
cp -r .config/* ~/.config/
cp home/.bashrc ~/.bashrc
```

O si prefieres usar symlinks (recomendado):
```bash
ln -sf ~/dotfiles/.config/hypr ~/.config/hypr
ln -sf ~/dotfiles/.config/waybar ~/.config/waybar
ln -sf ~/dotfiles/.config/kitty ~/.config/kitty
ln -sf ~/dotfiles/.config/fuzzel ~/.config/fuzzel
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.config/btop ~/.config/btop
ln -sf ~/dotfiles/home/.bashrc ~/.bashrc
```

4. Recarga la configuración de bash:
```bash
source ~/.bashrc
```

## Actualizar configuraciones

Para guardar cambios en tus configuraciones:

```bash
cd ~/dotfiles
git add .
git commit -m "Descripción de los cambios"
git push
```

## Notas

- Si usas symlinks, los cambios que hagas en `~/.config/` se reflejarán automáticamente en el repositorio
- Recuerda hacer commits regularmente para mantener un historial de tus cambios
- Puedes subir este repositorio a GitHub/GitLab para tener un backup en la nube

## Estructura del repositorio

```
dotfiles/
├── .config/
│   ├── hypr/
│   ├── waybar/
│   ├── kitty/
│   ├── fuzzel/
│   ├── nvim/
│   └── btop/
├── home/
│   └── .bashrc
└── README.md
```
