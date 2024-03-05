#!/bin/bash

# Script para crear una máquina virtual con virt-install y configuración específica para Flatcar Linux.

# Nombre de la VM
VM_NAME="flatcar-linux1"

# Configuraciones de la VM
RAM=1024
VCPUS=1
OS_TYPE="generic"
# Asegúrate de ajustar la ruta de la imagen aquí
DISK_PATH="/var/lib/libvirt/images/flatcar_image/flatcar_production_qemu_image.img"
DISK_FORMAT="qcow2"
DISK_BUS="virtio"
CONFIG_FILE="/var/lib/libvirt/flatcar-linux/$VM_NAME/provision.ign"

# Crear la máquina virtual
virt-install --connect qemu:///system \
             --import \
             --name "$VM_NAME" \
             --ram $RAM --vcpus $VCPUS \
             --os-type=$OS_TYPE \
             --disk path=$DISK_PATH,format=$DISK_FORMAT,bus=$DISK_BUS \
             --vnc --noautoconsole \
             --qemu-commandline="-fw_cfg name=opt/org.flatcar-linux/config,file=$CONFIG_FILE"

echo "Máquina virtual $VM_NAME creada exitosamente."
