#!/bin/bash

set -x

USER_NAME="core"
SSH_DIR="/home/victory/ssh_dir"  # Directorio específico para las claves SSH
SSH_KEY="$SSH_DIR/id_rsa"  # Archivo de la clave privada

# Crea el directorio SSH si no existe
mkdir -p "$SSH_DIR"

# Genera una nueva clave SSH si no existe
if [ ! -f "$SSH_KEY" ]; then
    echo "Generando una nueva clave SSH..."
    ssh-keygen -t rsa -b 2048 -N "" -f "$SSH_KEY"
fi

# Asegúrate de que las rutas a IGN_PATH y YAML_PATH sean correctas para tu entorno
IGN_PATH="$SSH_DIR/config.ign"
YAML_PATH="$SSH_DIR/config.yaml"

# Crea el archivo de configuración YAML
cat > "$YAML_PATH" << EOF
variant: flatcar
version: 1.4.0
passwd:
  users:
    - name: $USER_NAME
      ssh_authorized_keys:
        - $(cat "$SSH_KEY.pub")
EOF

# Convierte el archivo YAML a formato IGN con Butane
butane "$YAML_PATH" -o "$IGN_PATH"

# Verifica si el archivo IGN se ha generado correctamente
if [ -f "$IGN_PATH" ]; then
    echo "El archivo IGN se ha generado correctamente en $IGN_PATH."
else
    echo "Error, el archivo IGN no se ha generado."
fi
