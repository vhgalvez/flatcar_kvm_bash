#!/bin/bash

set -x

USER_NAME="core"
SSH_DIR="/home/victory/ssh_dir" # Cambia el directorio de las claves SSH al deseado
SSH_KEY="$SSH_DIR/id_rsa" # Usa el archivo de clave privada para la generación
SSH_PUB_KEY="$SSH_KEY.pub" # Define el archivo de clave pública

IGN_PATH="$SSH_DIR/config.ign"
YAML_PATH="$SSH_DIR/config.yaml"

# Crea el directorio si no existe
mkdir -p "$SSH_DIR"

# Comprueba si la clave SSH existe, si no, la genera
if [ ! -f "$SSH_PUB_KEY" ]; then
    echo "La clave SSH no existe. Generando una nueva clave SSH..."
    ssh-keygen -t rsa -b 2048 -N "" -f "$SSH_KEY"
fi

# Usa correctamente la clave pública en el archivo YAML
cat > "$YAML_PATH" << EOF
variant: flatcar
version: 1.4.0
passwd:
  users:
    - name: $USER_NAME
      ssh_authorized_keys:
        - $(cat "$SSH_PUB_KEY")
EOF

# Convierte YAML a formato IGN con Butane
butane "$YAML_PATH" -o "$IGN_PATH"

# Verificación final
if [ -f "$IGN_PATH" ]; then
    echo "El archivo IGN se ha generado correctamente."
else
    echo "Error, el archivo IGN no se ha generado."
fi
