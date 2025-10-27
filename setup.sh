#!/bin/bash

###############################################################################
# Dotfiles Setup Script
# Script interactivo para configurar el entorno Hyprland desde cero
###############################################################################

set -e  # Exit on error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables globales
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
DRY_RUN=false
INSTALL_PACKAGES=false
CREATE_SYMLINKS=true

###############################################################################
# Funciones de utilidad
###############################################################################

print_header() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║           Dotfiles Setup - Hyprland Environment               ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${GREEN}==>${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC}  $1"
}

print_error() {
    echo -e "${RED}✗${NC}  $1"
}

print_success() {
    echo -e "${GREEN}✓${NC}  $1"
}

confirm() {
    local prompt="$1"
    local default="${2:-n}"
    local response

    if [[ "$default" == "y" ]]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi

    read -p "$prompt" response
    response=${response:-$default}

    [[ "$response" =~ ^[Yy]$ ]]
}

###############################################################################
# Verificaciones del sistema
###############################################################################

check_system() {
    print_step "Verificando sistema..."

    # Verificar que es Arch Linux
    if [[ ! -f /etc/arch-release ]]; then
        print_error "Este script está diseñado para Arch Linux"
        exit 1
    fi

    # Verificar que estamos en el directorio correcto
    if [[ ! -f "$DOTFILES_DIR/README.md" ]]; then
        print_error "No se encuentra en el directorio de dotfiles correcto"
        exit 1
    fi

    # Verificar git (necesario para clonar el repo)
    if ! command -v git &> /dev/null; then
        print_error "Git no está instalado. Instálalo con: sudo pacman -S git"
        exit 1
    fi

    # Verificar que .local/bin está en el PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        print_warning "~/.local/bin no está en tu PATH"
        print_warning "Agrega esto a tu .bashrc o .bash_profile:"
        echo '  export PATH="$HOME/.local/bin:$PATH"'
    fi

    print_success "Sistema verificado (Arch Linux)"
}

###############################################################################
# Instalación de paquetes
###############################################################################

install_packages() {
    print_step "Instalación de paquetes"

    if ! confirm "¿Deseas instalar/verificar los paquetes necesarios?" "n"; then
        print_warning "Saltando instalación de paquetes"
        return
    fi

    print_step "Actualizando base de datos de paquetes..."
    if [[ "$DRY_RUN" == false ]]; then
        sudo pacman -Sy
    fi

    # Paquetes esenciales para Hyprland
    local essential_packages=(
        "hyprland"
        "waybar"
        "kitty"
        "fuzzel"
        "btop"
        "htop"
        "swww"
        "grim"
        "slurp"
        "wl-clipboard"
        "brightnessctl"
        "pipewire"
        "pipewire-pulse"
        "wireplumber"
        "networkmanager"
        "network-manager-applet"
        "bluez"
        "bluez-utils"
        "blueman"
        "git"
        "neovim"
        "fzf"
        "wofi"
        "dunst"
        "polkit-kde-agent"
    )

    # Detectar qué paquetes ya están instalados
    local to_install=()
    local already_installed=()

    for pkg in "${essential_packages[@]}"; do
        if pacman -Qi "$pkg" &> /dev/null; then
            already_installed+=("$pkg")
        else
            to_install+=("$pkg")
        fi
    done

    if [[ ${#already_installed[@]} -gt 0 ]]; then
        print_success "Ya instalados (${#already_installed[@]}):"
        printf '  ✓ %s\n' "${already_installed[@]}"
        echo ""
    fi

    if [[ ${#to_install[@]} -eq 0 ]]; then
        print_success "Todos los paquetes esenciales ya están instalados"
    else
        print_step "Paquetes a instalar (${#to_install[@]}):"
        printf '  - %s\n' "${to_install[@]}"
        echo ""

        if confirm "¿Continuar con la instalación?" "y"; then
            if [[ "$DRY_RUN" == false ]]; then
                if sudo pacman -S --needed --noconfirm "${to_install[@]}"; then
                    print_success "Paquetes instalados correctamente"
                else
                    print_error "Error al instalar paquetes"
                    return 1
                fi
            else
                print_warning "[DRY RUN] Se instalarían ${#to_install[@]} paquetes"
            fi
        fi
    fi

    # AUR Helper (yay)
    if ! command -v yay &> /dev/null; then
        echo ""
        print_warning "yay no está instalado (necesario para paquetes AUR)"
        if confirm "¿Deseas instalar yay (AUR helper)?" "y"; then
            install_yay
        fi
    else
        print_success "yay ya está instalado"
    fi
}

install_yay() {
    print_step "Instalando yay..."

    # Verificar que base-devel esté instalado
    if ! pacman -Qi base-devel &> /dev/null; then
        print_warning "base-devel no está instalado (necesario para compilar paquetes AUR)"
        if confirm "¿Instalar base-devel?" "y"; then
            if [[ "$DRY_RUN" == false ]]; then
                sudo pacman -S --needed base-devel
            fi
        else
            print_error "No se puede instalar yay sin base-devel"
            return 1
        fi
    fi

    if [[ "$DRY_RUN" == false ]]; then
        local temp_dir=$(mktemp -d)
        local original_dir="$PWD"

        if cd "$temp_dir"; then
            if git clone https://aur.archlinux.org/yay.git; then
                if cd yay; then
                    if makepkg -si --noconfirm; then
                        cd "$original_dir"
                        rm -rf "$temp_dir"
                        print_success "yay instalado correctamente"
                        return 0
                    fi
                fi
            fi
        fi

        # Si llegamos acá, algo falló
        cd "$original_dir"
        rm -rf "$temp_dir"
        print_error "Error al instalar yay"
        return 1
    else
        print_warning "[DRY RUN] Se instalaría yay"
    fi
}

###############################################################################
# Backup de configuraciones existentes
###############################################################################

create_backups() {
    print_step "Creando backups de configuraciones existentes..."

    local configs=(
        ".config/hypr"
        ".config/waybar"
        ".config/kitty"
        ".config/fuzzel"
        ".config/btop"
        ".config/htop"
        ".bashrc"
        ".bash_profile"
        ".profile"
        ".gitconfig"
    )

    local backed_up=0
    local backup_needed=false

    # Primero verificar si hay algo que respaldar
    for config in "${configs[@]}"; do
        local source="$HOME/$config"
        if [[ -e "$source" ]] && [[ ! -L "$source" ]]; then
            backup_needed=true
            backed_up=$((backed_up + 1))
        fi
    done

    if [[ "$backup_needed" == false ]]; then
        print_warning "No se encontraron archivos para respaldar (todo OK o ya son symlinks)"
        return 0
    fi

    print_warning "Se encontraron $backed_up archivos/directorios para respaldar"

    if ! confirm "¿Crear backups antes de continuar?" "y"; then
        print_warning "Saltando backups (¡cuidado!)"
        return 0
    fi

    if [[ "$DRY_RUN" == false ]]; then
        mkdir -p "$BACKUP_DIR"
        print_success "Directorio de backup: $BACKUP_DIR"
    fi

    backed_up=0

    for config in "${configs[@]}"; do
        local source="$HOME/$config"
        local target="$BACKUP_DIR/$config"

        if [[ -e "$source" ]] && [[ ! -L "$source" ]]; then
            if [[ "$DRY_RUN" == false ]]; then
                mkdir -p "$(dirname "$target")"
                if cp -r "$source" "$target" 2>/dev/null; then
                    print_success "✓ $config"
                    backed_up=$((backed_up + 1))
                else
                    print_error "✗ Error respaldando $config"
                fi
            else
                print_warning "[DRY RUN] Se haría backup de: $config"
                backed_up=$((backed_up + 1))
            fi
        fi
    done

    if [[ $backed_up -gt 0 ]]; then
        print_success "Backups completados: $backed_up archivos"
    fi
}

###############################################################################
# Creación de symlinks
###############################################################################

create_symlinks() {
    print_step "Creando enlaces simbólicos..."

    # Symlinks para .config
    local config_dirs=(
        "hypr"
        "waybar"
        "kitty"
        "fuzzel"
        "btop"
        "htop"
    )

    for dir in "${config_dirs[@]}"; do
        local source="$DOTFILES_DIR/.config/$dir"
        local target="$HOME/.config/$dir"

        if [[ ! -d "$source" ]]; then
            print_warning "No existe: $source"
            continue
        fi

        if [[ -L "$target" ]]; then
            print_warning "Symlink ya existe: $target"
            continue
        fi

        if [[ -e "$target" ]]; then
            if confirm "¿Eliminar $target existente y crear symlink?" "y"; then
                if [[ "$DRY_RUN" == false ]]; then
                    rm -rf "$target"
                fi
            else
                print_warning "Saltando: $target"
                continue
            fi
        fi

        if [[ "$DRY_RUN" == false ]]; then
            ln -sf "$source" "$target"
            print_success "Symlink creado: $target -> $source"
        else
            print_warning "[DRY RUN] Se crearía symlink: $target -> $source"
        fi
    done

    # Symlinks para archivos en home
    local home_files=(
        ".bashrc"
        ".bash_profile"
        ".profile"
        ".gitconfig"
    )

    for file in "${home_files[@]}"; do
        local source="$DOTFILES_DIR/home/$file"
        local target="$HOME/$file"

        if [[ ! -f "$source" ]]; then
            print_warning "No existe: $source"
            continue
        fi

        if [[ -L "$target" ]]; then
            print_warning "Symlink ya existe: $target"
            continue
        fi

        if [[ -e "$target" ]]; then
            if confirm "¿Reemplazar $target con symlink?" "y"; then
                if [[ "$DRY_RUN" == false ]]; then
                    rm -f "$target"
                fi
            else
                print_warning "Saltando: $target"
                continue
            fi
        fi

        if [[ "$DRY_RUN" == false ]]; then
            ln -sf "$source" "$target"
            print_success "Symlink creado: $target -> $source"
        else
            print_warning "[DRY RUN] Se crearía symlink: $target -> $source"
        fi
    done

    # Crear directorio para scripts si no existe
    if [[ ! -d "$HOME/.local/bin" ]]; then
        if [[ "$DRY_RUN" == false ]]; then
            mkdir -p "$HOME/.local/bin"
            print_success "Directorio creado: ~/.local/bin"
        fi
    fi

    # Symlinks para scripts
    if [[ -d "$DOTFILES_DIR/scripts" ]]; then
        for script in "$DOTFILES_DIR/scripts"/*.sh; do
            if [[ -f "$script" ]]; then
                local script_name=$(basename "$script")
                local target="$HOME/.local/bin/$script_name"

                if [[ "$DRY_RUN" == false ]]; then
                    ln -sf "$script" "$target"
                    chmod +x "$script"
                    print_success "Script instalado: $script_name"
                else
                    print_warning "[DRY RUN] Se instalaría script: $script_name"
                fi
            fi
        done
    fi
}

###############################################################################
# Post-instalación
###############################################################################

post_install() {
    print_step "Configuración post-instalación..."

    # Verificar y habilitar servicios esenciales
    local services=(
        "NetworkManager:Gestor de red"
        "bluetooth:Bluetooth"
    )

    echo ""
    print_step "Verificando servicios del sistema..."

    for service_info in "${services[@]}"; do
        local service="${service_info%%:*}"
        local desc="${service_info##*:}"

        if systemctl is-enabled "$service" &> /dev/null; then
            if systemctl is-active "$service" &> /dev/null; then
                print_success "$desc ($service) - activo"
            else
                print_warning "$desc ($service) - habilitado pero no activo"
                if confirm "¿Iniciar $service ahora?" "y"; then
                    if [[ "$DRY_RUN" == false ]]; then
                        sudo systemctl start "$service"
                    fi
                fi
            fi
        else
            print_warning "$desc ($service) - no habilitado"
            if confirm "¿Habilitar e iniciar $service?" "y"; then
                if [[ "$DRY_RUN" == false ]]; then
                    sudo systemctl enable --now "$service"
                    print_success "$service habilitado e iniciado"
                else
                    print_warning "[DRY RUN] Se habilitaría $service"
                fi
            fi
        fi
    done

    # Verificar que scripts tengan permisos de ejecución
    echo ""
    if [[ -d "$DOTFILES_DIR/scripts" ]]; then
        print_step "Verificando permisos de scripts..."
        if [[ "$DRY_RUN" == false ]]; then
            chmod +x "$DOTFILES_DIR"/scripts/*.sh 2>/dev/null
            print_success "Permisos de ejecución configurados en scripts"
        fi
    fi

    # Información final
    echo ""
    print_step "Información importante:"
    echo "  - Recarga tu shell: source ~/.bashrc"
    echo "  - Backups en: $BACKUP_DIR"
    echo "  - Scripts disponibles en: ~/.local/bin/"

    if [[ -L "$HOME/.config/hypr/hyprland.conf" ]]; then
        echo "  - Config Hyprland: ~/dotfiles/.config/hypr/"
    fi
}

###############################################################################
# Función principal
###############################################################################

show_usage() {
    echo "Uso: $0 [OPCIONES]"
    echo ""
    echo "Opciones:"
    echo "  -h, --help           Mostrar esta ayuda"
    echo "  -d, --dry-run        Modo simulación (no hace cambios reales)"
    echo "  -p, --packages       Instalar paquetes automáticamente"
    echo "  -s, --skip-symlinks  No crear symlinks"
    echo "  --update-inventory   Actualizar INSTALLED.md con paquetes actuales"
    echo ""
}

main() {
    # Parse argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -d|--dry-run)
                DRY_RUN=true
                print_warning "Modo DRY RUN activado"
                shift
                ;;
            -p|--packages)
                INSTALL_PACKAGES=true
                shift
                ;;
            -s|--skip-symlinks)
                CREATE_SYMLINKS=false
                shift
                ;;
            --update-inventory)
                update_inventory
                exit 0
                ;;
            *)
                print_error "Opción desconocida: $1"
                show_usage
                exit 1
                ;;
        esac
    done

    print_header

    check_system

    echo ""
    print_step "Configuración:"
    echo "  Dotfiles dir: $DOTFILES_DIR"
    echo "  Backup dir:   $BACKUP_DIR"
    echo "  Dry run:      $DRY_RUN"
    echo ""

    if ! confirm "¿Continuar con la configuración?" "y"; then
        print_warning "Instalación cancelada"
        exit 0
    fi

    echo ""

    # Ejecutar pasos
    if [[ "$INSTALL_PACKAGES" == true ]] || confirm "¿Instalar paquetes necesarios?" "n"; then
        install_packages
        echo ""
    fi

    create_backups
    echo ""

    if [[ "$CREATE_SYMLINKS" == true ]]; then
        create_symlinks
        echo ""
    fi

    post_install
    echo ""

    print_success "¡Configuración completada!"
    echo ""
    echo "Próximos pasos:"
    echo "  1. Cierra sesión y selecciona Hyprland en tu display manager"
    echo "  2. O ejecuta: exec Hyprland (si usas startx)"
    echo "  3. Los backups están en: $BACKUP_DIR"
    echo ""
}

###############################################################################
# Función para actualizar inventario
###############################################################################

update_inventory() {
    print_step "Actualizando INSTALLED.md..."

    if [[ "$DRY_RUN" == false ]]; then
        pacman -Qe > /tmp/pacman_packages.txt
        yay -Qm > /tmp/aur_packages.txt 2>/dev/null || echo "" > /tmp/aur_packages.txt

        print_success "Inventario actualizado en /tmp/"
        print_warning "Regenera INSTALLED.md manualmente con estos archivos"
    else
        print_warning "[DRY RUN] Se actualizaría el inventario"
    fi
}

# Ejecutar script
main "$@"
