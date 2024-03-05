#!/bin/bash

# Define el directorio donde se guardarán las claves SSH
SSH_DIR="/root/.ssh"
# Define un nombre base para el par de claves SSH, modificable para diferentes proyectos
KEY_NAME="id_rsa_projectname"  # Cambiar "projectname" por el nombre del proyecto deseado
# Define el nombre del archivo para la clave privada basado en KEY_NAME
SSH_PRIVATE_KEY="$SSH_DIR/${KEY_NAME}"
# Define el correo electrónico para asociar con la clave SSH
SSH_EMAIL="vhgalvez@gmail.com"  # Modificar según sea necesario

# Crea el directorio para las claves SSH si no existe
mkdir -p "$SSH_DIR"

# Ajusta los permisos del directorio
chmod 700 "$SSH_DIR"

# Verifica si ya existe un par de claves SSH con el nombre base especificado y genera uno nuevo si no existe
if [ ! -f "$SSH_PRIVATE_KEY" ]; then
    echo "Generando un nuevo par de claves SSH para $KEY_NAME..."
    ssh-keygen -t rsa -b 2048 -N "" -f "$SSH_PRIVATE_KEY" -C "$SSH_EMAIL"
    echo "Par de claves SSH generado correctamente para $KEY_NAME en $SSH_DIR."
else
    echo "Ya existe un par de claves SSH para $KEY_NAME en $SSH_DIR."
fi

# Ajusta los permisos de las claves
chmod 600 "$SSH_PRIVATE_KEY"
chmod 644 "${SSH_PRIVATE_KEY}.pub"

# Muestra el contenido del directorio de las claves SSH
echo "Verificando la generación de las claves SSH..."
ls -lha "$SSH_DIR"
