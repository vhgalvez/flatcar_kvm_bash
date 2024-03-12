#!/bin/bash

# Script para gestionar claves SSH

# Configuramos opciones de salida para el script
set -e
set -o errexit  # Finaliza el script si un comando falla
set -o nounset  # Finaliza el script si se usa una variable no declarada

# Definimos variables
SSH_DIR="/root/.ssh"
SSH_PRIVATE_KEY="$SSH_DIR/id_rsa"
log_file="/var/log/ssh_keygen.log"

# Función para manejar errores
handle_error() {
    echo "$(date) - Error: $1 falló" >&2
    echo "$(date) - Error: $1 falló" >> "$log_file"
    dmesg >> "$log_file"
    exit 1
}

# Crea el directorio para las claves SSH si no existe
create_ssh_dir() {
    mkdir -p "$SSH_DIR" || handle_error "Creación del directorio SSH"
    chmod 700 "$SSH_DIR" || handle_error "Ajuste de permisos del directorio SSH"
}

# Genera un nuevo par de claves SSH si no existe
generate_ssh_keys() {
    if [ ! -f "$SSH_PRIVATE_KEY" ]; then
        echo "Generando un nuevo par de claves SSH..."
        ssh-keygen -t rsa -b 2048 -N "" -f "$SSH_PRIVATE_KEY" >> "$log_file" || handle_error "Generación de claves SSH"
        echo "Par de claves SSH generado correctamente en $SSH_DIR."
    else
        echo "Ya existe un par de claves SSH en $SSH_DIR."
    fi
}

# Ajusta los permisos de las claves
adjust_key_permissions() {
    chmod 600 "$SSH_PRIVATE_KEY" || handle_error "Ajuste de permisos de la clave privada"
    chmod 644 "$SSH_PRIVATE_KEY.pub" || handle_error "Ajuste de permisos de la clave pública"
}

# Función principal
main() {
    create_ssh_dir
    generate_ssh_keys
    adjust_key_permissions
    echo "Gestión de claves SSH completada correctamente."
}

# Ejecutamos la función principal
main

# Finalizamos el script
exit 0
