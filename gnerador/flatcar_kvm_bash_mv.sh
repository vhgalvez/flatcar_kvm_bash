#!/bin/bash

# Asegúrate de haber ejecutado key_generation_and_config.sh primero.

# Argumentos y variables
VM_NAME=$1
BASE_IMAGE="/var/lib/libvirt/images/flatcar_image/flatcar_production_qemu_image.img"
VM_DISK_PATH="/var/lib/libvirt/images/${VM_NAME}.qcow2"
DISK_SIZE="20G"
IGN_DIR="/root/ign"
CONFIG_IGN_PATH="${IGN_DIR}/${VM_NAME}-config.ign"

# Crear disco para la VM
qemu-img create -f qcow2 -o backing_file=${BASE_IMAGE} ${VM_DISK_PATH} ${DISK_SIZE}

# Crear la VM
virt-install --name ${VM_NAME} --vcpus 2 --memory 2048 --disk path=${VM_DISK_PATH},format=qcow2 \
    --os-variant generic --import --network network=default --graphics none --noautoconsole \
    --qemu-commandline="-fw_cfg name=opt/com.coreos/config,file=${CONFIG_IGN_PATH}"

echo "Máquina virtual ${VM_NAME} creada exitosamente."
