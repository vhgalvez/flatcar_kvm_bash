#!/bin/bash

set -x

USER_NAME="core"
SSH_DIR="/root/.ssh"
SSH_KEY="$SSH_DIR/id_rsa"  # Cambiado a la clave privada para generar la clave pública correcta.
YAML_PATH="/root/ign/${VM_NAME}-config.yaml"
IGN_PATH="/root/ign/${VM_NAME}-config.ign"

# Crea el directorio SSH si no existe
mkdir -p "$SSH_DIR"
mkdir -p "$(dirname "$YAML_PATH")"

# Genera una nueva clave SSH si no existe
if [ ! -f "$SSH_KEY" ]; then
    echo "Generando una nueva clave SSH..."
    ssh-keygen -t rsa -b 2048 -N "" -f "$SSH_KEY"
fi

# Asegúrate de que la clave pública exista para la inserción en el YAML
SSH_PUB_KEY=$(cat "$SSH_KEY.pub")

# Crea el archivo de configuración YAML
cat > "$YAML_PATH" << EOF
variant: flatcar
version: 1.4.0
passwd:
  users:
    - name: $USER_NAME
      ssh_authorized_keys:
        - $SSH_PUB_KEY
EOF

# Convierte el archivo YAML a formato IGN con Butane
butane --pretty --strict "$YAML_PATH" -o "$IGN_PATH"

# Verifica si el archivo IGN se ha generado correctamente
if [ -f "$IGN_PATH" ]; then
    echo "El archivo IGN se ha generado correctamente en $IGN_PATH."
else
    echo "Error, el archivo IGN no se ha generado."
    exit 1
fi