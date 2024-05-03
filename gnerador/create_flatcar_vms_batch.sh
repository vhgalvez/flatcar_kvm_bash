#!/bin/bash

# Mejora del script para crear múltiples máquinas virtuales KVM con Flatcar Linux

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

# Personalización - EDITAR ESTOS VALORES
BASE_IMAGE="/var/lib/libvirt/images/flatcar_image/flatcar_production_qemu_image.img"
DISK_SIZE="20G"
IGN_DIR="${USER_HOME}/ign"
LOG_FILE="${USER_HOME}/vm_creation.log"  # Archivo de log

# Nombres de las VMs - EDITAR ESTOS VALORES
declare -a VM_NAMES=("maquina-worker-01" "maquina-worker-02" "maquina-worker-03"
"maquina-master-01" "maquina-master-02" "maquina-master-03")

# Crear directorio para logs si no existe
if [ ! -d "$(dirname "$LOG_FILE")" ]; then
    mkdir -p "$(dirname "$LOG_FILE")"
    chmod 755 "$(dirname "$LOG_FILE")"
fi

# Función para verificar existencia de archivos IGN y crear VMs
create_vms() {
    for VM_NAME in "${VM_NAMES[@]}"; do
        VM_DISK_PATH="/var/lib/libvirt/images/${VM_NAME}.qcow2"
        CONFIG_IGN_PATH="${IGN_DIR}/${VM_NAME}-config.ign"
        
        if [ ! -f "$CONFIG_IGN_PATH" ]; then
            handle_error "Archivo de configuración IGN no encontrado para ${VM_NAME}: $CONFIG_IGN_PATH"
            continue
        fi
        
        echo "Creando disco para VM: ${VM_NAME}" >> "$LOG_FILE"
        qemu-img create -f qcow2 -o backing_file="${BASE_IMAGE}" "${VM_DISK_PATH}" "${DISK_SIZE}" || handle_error "Creación de disco para VM ${VM_NAME}"
        
        echo "Creando máquina virtual: ${VM_NAME}" >> "$LOG_FILE"
        virt-install --name "${VM_NAME}" --vcpus 2 --memory 2048 \
        --disk path="${VM_DISK_PATH}",format=qcow2 \
        --os-variant generic --import --network network=default \
        --graphics none --noautoconsole \
        --qemu-commandline="-fw_cfg name=opt/com.coreos/config,file=${CONFIG_IGN_PATH}" || handle_error "Creación de la VM ${VM_NAME}"
        
        echo "Máquina virtual ${VM_NAME} creada exitosamente." | tee -a "$LOG_FILE"
    done
}

# Función para manejar errores
handle_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: $1." >&2
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: $1." >> "$LOG_FILE"
    exit 1
}

# Ejecución de la función principal
create_vms
