#!/bin/bash

set -x

USER_NAME="core"
SSH_DIR="/home/victory/ssh_dir" # Directorio personalizado para las claves SSH
SSH_KEY="$SSH_DIR/id_rsa.pub"

IGN_PATH="/home/victory/ssh_dir/config.ign" # Actualiza con la ruta deseada
YAML_PATH="/home/victory/ssh_dir/config.yaml" # Actualiza con la ruta deseada

mkdir -p "$SSH_DIR"

if [ ! -f "$SSH_KEY" ]; then
    echo "El archivo $SSH_KEY no existe. Generando una nueva clave SSH..."
    ssh-keygen -t rsa -b 2048 -N "" -f "$SSH_DIR/id_rsa"
fi

cat > "$YAML_PATH" << EOF
variant: flatcar
version: 1.4.0
passwd:
  users:
    - name: $USER_NAME
      ssh_authorized_keys:
        - $(cat "$SSH_KEY")
EOF

butane "$YAML_PATH" > "$IGN_PATH"

if [ -f "$IGN_PATH" ]; then
    echo "El archivo IGN se ha generado correctamente."
else
    echo "Error, el archivo IGN no se ha generado."
fi