#!/bin/bash

# Mejora del script para generar archivos IGN a partir de claves SSH para VMs

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
USER_NAME="core"
SSH_DIR="${USER_HOME}/.ssh"  # Uso del directorio home del usuario para SSH
SSH_EMAIL="example@example.com"
IGN_DIR="${USER_HOME}/ign"  # Uso del directorio home del usuario para IGN
LOG_FILE="${USER_HOME}/ign_generation.log"  # Archivo de log

# Variables internas
KEY_NAME="id_rsa_${VM_NAME}"
SSH_PRIVATE_KEY="${SSH_DIR}/${KEY_NAME}"
SSH_PUBLIC_KEY="${SSH_PRIVATE_KEY}.pub"
YAML_PATH="${IGN_DIR}/${VM_NAME}-config.yaml"
IGN_PATH="${IGN_DIR}/${VM_NAME}-config.ign"

# Crear directorio para logs si no existe
if [ ! -d "$(dirname "$LOG_FILE")" ]; then
  mkdir -p "$(dirname "$LOG_FILE")"
  chmod 755 "$(dirname "$LOG_FILE")"
fi

# Función para crear directorios SSH e IGN si no existen
create_directories() {
    mkdir -p "$SSH_DIR"
    mkdir -p "$IGN_DIR"
}

# Función para generar claves SSH si no existen
generate_ssh_keys() {
    if [ ! -f "$SSH_PRIVATE_KEY" ]; then
        echo "Generando clave SSH para $VM_NAME..."
        ssh-keygen -t rsa -b 2048 -N '' -f "$SSH_PRIVATE_KEY" -C "$SSH_EMAIL"
        echo "Clave SSH generada: $SSH_PRIVATE_KEY"
    else
        echo "La clave SSH ya existe para $VM_NAME: $SSH_PRIVATE_KEY"
    fi
}

# Función para preparar archivo YAML con clave pública
prepare_yaml() {
    echo "Preparando archivo YAML: $YAML_PATH"
    cat > "$YAML_PATH" <<EOF
variant: flatcar
version: 1.1.0
passwd:
  users:
    - name: $USER_NAME
      ssh_authorized_keys:
        - $(cat "$SSH_PUBLIC_KEY")
EOF
    echo "Archivo YAML generado: $YAML_PATH"
}

# Función para convertir YAML a IGN con Butane
convert_to_ign() {
    echo "Convirtiendo YAML a IGN..."
    butane --pretty --strict "$YAML_PATH" -o "$IGN_PATH" || handle_error "Error convirtiendo a IGN"
    echo "Archivo IGN generado: $IGN_PATH"
}

# Función para manejar errores
handle_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: $1." >&2
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: $1." >> "$LOG_FILE"
    exit 1
}

# Ejecución de las funciones principales
create_directories
generate_ssh_keys
prepare_yaml
convert_to_ign

echo "Generación de archivos IGN completada correctamente." | tee -a "$LOG_FILE"