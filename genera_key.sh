#!/bin/bash

# Define el directorio donde se guardarán las claves SSH
SSH_DIR="/root/.ssh"
# Define el nombre del archivo para la clave privada
SSH_PRIVATE_KEY="$SSH_DIR/id_rsa"

# Crea el directorio para las claves SSH si no existe
mkdir -p "$SSH_DIR"

# Ajusta los permisos del directorio
chmod 700 "$SSH_DIR"

# Verifica si ya existe un par de claves SSH y genera uno nuevo si no existe
if [ ! -f "$SSH_PRIVATE_KEY" ]; then
    echo "Generando un nuevo par de claves SSH..."
    ssh-keygen -t rsa -b 2048 -N "" -f "$SSH_PRIVATE_KEY"
    echo "Par de claves SSH generado correctamente en $SSH_DIR."
else
    echo "Ya existe un par de claves SSH en $SSH_DIR."
fi

# Ajusta los permisos de las claves
chmod 600 "$SSH_PRIVATE_KEY"
chmod 644 "$SSH_PRIVATE_KEY.pub"
