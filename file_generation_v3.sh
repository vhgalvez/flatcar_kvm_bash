#!/bin/bash

set -x

USER_NAME="core"
SSH_DIR="/home/victory/ssh_dir"  # Directorio específico para las claves SSH
SSH_KEY="$SSH_DIR/id_rsa.pub"

IGN_PATH="$SSH_DIR/config.ign"  # Ubicación del archivo IGN
YAML_PATH="$SSH_DIR/config.yaml"  # Ubicación del archivo YAML

# Crea el directorio SSH si no existe
mkdir -p "$SSH_DIR"

# Genera una nueva clave SSH si no existe
if [ ! -f "$SSH_KEY" ]; then
    echo "El archivo $SSH_KEY no existe. Generando una nueva clave SSH..."
    ssh-keygen -t rsa -b 2048 -N "" -f "$SSH_DIR/id_rsa"
fi

# Crea el archivo de configuración YAML
cat > "$YAML_PATH" << EOF
variant: flatcar
version: 1.4.0
passwd:
  users:
    - name: $USER_NAME
      ssh_authorized_keys:
        - $(cat "$SSH_KEY")
EOF

# Convierte YAML a IGN con Butane
butane "$YAML_PATH" > "$IGN_PATH"

# Verifica si el archivo IGN se generó correctamente
if [ -f "$IGN_PATH" ]; then
    echo "El archivo IGN se ha generado correctamente."
else
    echo "Error, el archivo IGN no se ha generado."
fi
