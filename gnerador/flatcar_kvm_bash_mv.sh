#!/bin/bash

# Script para crear máquinas virtuales KVM con Flatcar Linux

# Configuramos opciones de salida seguras para el script
set -e
set -o errexit
set -o nounset
set -o pipefail

# Personalización - EDITAR ESTOS VALORES
VM_NAME="nombre_vm"
BASE_IMAGE="/var/lib/libvirt/images/flatcar_image/flatcar_image/flatcar_production_qemu_image.img"
VM_DISK_PATH="/var/lib/libvirt/images/${VM_NAME}.qcow2"
DISK_SIZE="20G"
IGN_DIR="/root/ign"
CONFIG_IGN_PATH="${IGN_DIR}/${VM_NAME}-config.ign"

# Verificar existencia de archivo IGN
if [ ! -f "$CONFIG_IGN_PATH" ]; then
    echo "Archivo de configuración IGN no encontrado: $CONFIG_IGN_PATH"
    echo "Asegúrate de haber ejecutado el script de generación de archivos IGN."
    exit 1
fi

# Crear disco para la VM
echo "Creando disco para VM: $VM_DISK_PATH"
qemu-img create -f qcow2 -o backing_file="${BASE_IMAGE}" "${VM_DISK_PATH}" "${DISK_SIZE}"

# Crear la VM
echo "Creando máquina virtual: $VM_NAME"
virt-install --name "${VM_NAME}" --vcpus 2 --memory 2048 \
    --disk path="${VM_DISK_PATH}",format=qcow2 \
    --os-variant generic --import --network network=default \
    --graphics none --noautoconsole \
    --qemu-commandline="-fw_cfg name=opt/com.coreos/config,file=${CONFIG_IGN_PATH}"

echo "Máquina virtual ${VM_NAME} creada exitosamente."
