#!/bin/bash

# Script para crear una máquina virtual con virt-install y configuración específica para Flatcar Linux.

# Nombre de la VM
VM_NAME="flatcar-linux1"

# Configuraciones de la VM
RAM=1024
VCPUS=1
# Specify the Flatcar Linux variant here (replace with your desired version)
OS_VARIANT="flatcar"  # Example: flatcar-stable

# Asegúrate de ajustar la ruta de la imagen aquí
DISK_PATH="/var/lib/libvirt/images/flatcar_image/flatcar_production_qemu_image.img"
DISK_FORMAT="qcow2"
DISK_BUS="virtio"
CONFIG_FILE="/var/lib/libvirt/flatcar-linux/$VM_NAME/provision.ign"

# Crear la máquina virtual
echo "Creando la máquina virtual $VM_NAME..."
sudo mkdir -p /var/lib/libvirt/flatcar-linux/$VM_NAME/
sudo cp -R  /root/ign/mv_instancia_flatcar-config.ign /var/lib/libvirt/flatcar-linux/$VM_NAME/provision.ign
virt-install --connect qemu:///system \
--import \
--name "$VM_NAME" \
--ram $RAM --vcpus $VCPUS \
--os-variant $OS_VARIANT \
--disk path=$DISK_PATH,format=$DISK_FORMAT,bus=$DISK_BUS \
--vnc --noautoconsole \
--qemu-commandline="-fw_cfg name=opt/org.flatcar-linux/config,file=$CONFIG_FILE"

echo "Máquina virtual $VM_NAME creada exitosamente."