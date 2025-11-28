#!/bin/bash

# Script para montar automáticamente los discos al inicio del sistema
# Monta sdd2 (Disco Grande) y sdd3 (Disco Chico) en /mnt/disks

DISK_LARGE="/dev/sdd2"
DISK_SMALL="/dev/sdd3"
MOUNT_POINT_LARGE="/mnt/disks/disco-grande"
MOUNT_POINT_SMALL="/mnt/disks/disco-chico"

# Función para verificar si un disco existe
disk_exists() {
    [ -b "$1" ]
}

# Función para verificar si un disco ya está montado
is_mounted() {
    mountpoint -q "$1"
}

# Función para montar un disco
mount_disk() {
    local device="$1"
    local mount_point="$2"

    if ! disk_exists "$device"; then
        echo "⚠️  El disco $device no existe"
        return 1
    fi

    if is_mounted "$mount_point"; then
        echo "✓ $device ya está montado en $mount_point"
        return 0
    fi

    # Verificar que el punto de montaje existe
    if [ ! -d "$mount_point" ]; then
        echo "✓ Creando directorio $mount_point"
        sudo mkdir -p "$mount_point"
        sudo chown ssreynoso:ssreynoso "$mount_point"
    fi

    # Montar el disco
    if sudo mount "$device" "$mount_point"; then
        echo "✓ $device montado exitosamente en $mount_point"
        return 0
    else
        echo "✗ Error al montar $device en $mount_point"
        return 1
    fi
}

echo "=== Iniciando montaje de discos ==="
echo ""

# Listar discos disponibles
echo "Discos disponibles:"
lsblk -o NAME,LABEL,FSAVAIL,FSUSE%,SIZE,MODEL
echo ""

# Montar Disco Grande (sdd2)
echo "Montando Disco Grande..."
mount_disk "$DISK_LARGE" "$MOUNT_POINT_LARGE"
echo ""

# Montar Disco Chico (sdd3)
echo "Montando Disco Chico..."
mount_disk "$DISK_SMALL" "$MOUNT_POINT_SMALL"
echo ""

echo "=== Montaje completado ==="
