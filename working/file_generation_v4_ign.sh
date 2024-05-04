#!/bin/bash

# Variables generales
PROJECT_NAME="cluster_openshift"
VM_NAME="key_cluster_openshift"
USER_NAME="core"
SSH_DIR="/root/.ssh/${PROJECT_NAME}/${VM_NAME}"
CONFIG_DIR="/root/.ssh/${PROJECT_NAME}/Ignition"  # Ruta personalizada para configuración

# Nombres de archivo personalizados
YAML_FILE_NAME="${VM_NAME}-config.yaml"
IGN_FILE_NAME="${VM_NAME}-config.ign"
YAML_PATH="${CONFIG_DIR}/${YAML_FILE_NAME}"
IGN_PATH="${CONFIG_DIR}/${IGN_FILE_NAME}"

# Claves SSH
KEY_NAME="id_rsa_${VM_NAME}"
SSH_PRIVATE_KEY="${SSH_DIR}/${KEY_NAME}"
SSH_PUBLIC_KEY="${SSH_DIR}/${KEY_NAME}.pub"
SSH_EMAIL="vhgalvez@gmail.com"

# Crear directorios necesarios
mkdir -p "$SSH_DIR"
mkdir -p "$CONFIG_DIR"
chmod 700 "$SSH_DIR"
chmod 700 "$CONFIG_DIR"

# Generación de claves SSH
if [ ! -f "$SSH_PRIVATE_KEY" ]; then
    echo "Generando una nueva clave SSH para $VM_NAME..."
    ssh-keygen -t rsa -b 2048 -N '' -f "$SSH_PRIVATE_KEY" -C "$SSH_EMAIL"
    echo "La clave SSH se ha generado correctamente en $SSH_DIR para $VM_NAME."
else
    echo "La clave SSH ya existe para $VM_NAME en $SSH_DIR."
fi

chmod 600 "$SSH_PRIVATE_KEY"
chmod 644 "$SSH_PUBLIC_KEY"

# Preparación del archivo YAML con la clave pública
echo "Generando el archivo YAML para $VM_NAME en $YAML_PATH..."
cat > "$YAML_PATH" <<EOF
variant: flatcar
version: 1.1.0
passwd:
  users:
    - name: $USER_NAME
      ssh_authorized_keys:
        - $(cat "$SSH_PUBLIC_KEY")
EOF

# Conversión de YAML a formato IGN con Butane
echo "Convirtiendo YAML a formato IGN para $VM_NAME..."
butane --pretty --strict "$YAML_PATH" -o "$IGN_PATH"

# Verificación de la generación del archivo IGN
if [ -f "$IGN_PATH" ]; then
    echo "El archivo IGN se ha generado correctamente en $IGN_PATH para $VM_NAME."
else
    echo "Error, el archivo IGN no se ha generado para $VM_NAME."
    exit 1
fi

# Verificación de las claves SSH
echo "Verificando la generación de las claves SSH para $VM_NAME..."
ls -lha "$SSH_DIR"
