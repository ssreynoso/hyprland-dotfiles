# Problemas de drivers NVIDIA

## Hardware
- GPU: NVIDIA GeForce GTX 1060 6GB (Pascal, PCI ID: 10de:1c03)
- Kernel actual: linux 6.19 + linux-lts 6.18 (instalado como fallback)

## Problema (Marzo 2026)

Después de un `pacman -Syu`, el kernel se actualizó a 6.19 y el driver `nvidia-580xx-dkms` dejó de compilar.

### Causa raíz
El kernel 6.19 renombró el campo `__vm_flags` en `struct vm_area_struct` a `vm_flags`, rompiendo la compilación del driver nvidia 580.

### Por qué `nvidia-open-dkms` no sirve
El driver open source de NVIDIA (`nvidia-open`) requiere que la GPU tenga **GSP (GPU System Processor)**, que solo tienen las GPUs Turing (RTX 20xx) en adelante. La GTX 1060 (Pascal) no lo tiene.

## Solución

Instalar `nvidia-580xx-dkms` desde AUR versión 580.142 (tiene parche para kernel 6.18/6.19):

```bash
yay -S nvidia-580xx-dkms
```

Esto reemplaza `nvidia-open-dkms` y `nvidia-utils` por `nvidia-580xx-dkms` y `nvidia-580xx-utils`.

## Estado de mkinitcpio.conf

Los módulos nvidia fueron removidos del initramfs (`MODULES=()`). No son necesarios ahí para este setup.

## Kernels instalados
- `linux` (6.19) — funciona con nvidia-580xx-dkms 580.142
- `linux-lts` (6.18) — instalado como fallback, también funciona

## Notas
- No usar `nvidia-open-dkms` con esta GPU
- Después de cualquier actualización del kernel, verificar con `dkms status` que el módulo esté `installed`
