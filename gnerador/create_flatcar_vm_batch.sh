#!/bin/bash

# Configuramos opciones de salida seguras para el script
set -e
set -o errexit
set -o nounset
set -o pipefail

# Determinar el directorio home del usuario real, incluso cuando se ejecuta con sudo
if [[ ! -z "${SUDO_USER}" ]]; then
    USER_HOME=$(getent passwd "${SUDO_USER}" | cut -d: -f6)
else
    USER_HOME=$HOME
fi

# Definición de variables para personalización - EDITAR ESTOS VALORES
VM_NAME="nombre_vm"
BASE_IMAGE="/var/lib/libvirt/images/flatcar_image/flatcar_production_qemu_image.img"
VM_DISK_PATH="/var/lib/libvirt/images/${VM_NAME}.qcow2"
DISK_SIZE="20G"
IGN_DIR="${USER_HOME}/ign"  # Cambiado para usar el directorio home del usuario
CONFIG_IGN_PATH="${IGN_DIR}/${VM_NAME}-config.ign"
LOG_FILE="${USER_HOME}/vm_creation.log"  # Archivo de log

# Crear directorio para logs si no existe
if [ ! -d "$(dirname "$LOG_FILE")" ]; then
    mkdir -p "$(dirname "$LOG_FILE")"
    chmod 755 "$(dirname "$LOG_FILE")"
fi

# Función para verificar existencia del archivo IGN
check_ign_file() {
    if [ ! -f "$CONFIG_IGN_PATH" ]; then
        handle_error "Archivo de configuración IGN no encontrado: $CONFIG_IGN_PATH. Asegúrate de haber ejecutado el script de generación de archivos IGN."
    fi
}

# Función para crear disco para la VM
create_vm_disk() {
    echo "Creando disco para VM: $VM_DISK_PATH" >> "$LOG_FILE"
    qemu-img create -f qcow2 -o backing_file="${BASE_IMAGE}" "${VM_DISK_PATH}" "${DISK_SIZE}" || handle_error "Creación de disco para VM"
}

# Función para crear la VM
create_vm() {
    echo "Creando máquina virtual: $VM_NAME" >> "$LOG_FILE"
    virt-install --name "${VM_NAME}" --vcpus 2 --memory 2048 \
    --disk path="${VM_DISK_PATH}",format=qcow2 \
    --os-variant generic --import --network network=default \
    --graphics none --noautoconsole \
    --qemu-commandline="-fw_cfg name=opt/com.coreos/config,file=${CONFIG_IGN_PATH}" || handle_error "Creación de la VM"
}

# Función para manejar errores
handle_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: $1." >&2
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: $1." >> "$LOG_FILE"
    exit 1
}

# Ejecución de las funciones principales
check_ign_file
create_vm_disk
create_vm

echo "Máquina virtual ${VM_NAME} creada exitosamente." | tee -a "$LOG_FILE"
