#!/bin/bash

# Argumentos y variables
VM_NAME=$1
USER_NAME=${2:-core}
SSH_DIR=${3:-/root/.ssh}
SSH_EMAIL=${4:-"example@example.com"}
IGN_DIR=${5:-"/root/ign"}

# Variables internas
KEY_NAME="id_rsa_${VM_NAME}"
SSH_PRIVATE_KEY="${SSH_DIR}/${KEY_NAME}" 
SSH_PUBLIC_KEY="${SSH_DIR}/${KEY_NAME}.pub"
YAML_PATH="${IGN_DIR}/${VM_NAME}-config.yaml"
IGN_PATH="${IGN_DIR}/${VM_NAME}-config.ign"

# Crear directorios si no existen
mkdir -p "$SSH_DIR"
mkdir -p "$IGN_DIR"

# Genera claves SSH si no existen
if [ ! -f "$SSH_PRIVATE_KEY" ]; then
    echo "Generando clave SSH para $VM_NAME..."
    ssh-keygen -t rsa -b 2048 -N '' -f "$SSH_PRIVATE_KEY" -C "$SSH_EMAIL"
else
    echo "Clave SSH ya existe para $VM_NAME."
fi

# Prepara archivo YAML con clave pública
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

# Convierte YAML a IGN con Butane (o ct, dependiendo de tu entorno)
butane --pretty --strict "$YAML_PATH" -o "$IGN_PATH" || { echo "Error convirtiendo a IGN"; exit 1; }

echo "Archivo IGN generado: $IGN_PATH"
