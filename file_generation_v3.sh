#!/bin/bash

# Habilita la impresión de comandos antes de ejecutarlos
set -x

# Define las variables utilizadas en el script
USER_NAME="core"
SSH_DIR="/root/.ssh"
SSH_KEY="$SSH_DIR/id_rsa"

# Rutas para los archivos YAML y IGN
YAML_PATH="/root/ign/mv_instancia_flatcar-config.yaml"
IGN_PATH="/root/ign/mv_instancia_flatcar-config.ign"

# Crea el directorio .ssh si no existe
mkdir -p "$SSH_DIR"

# Verifica que el archivo de la clave pública SSH exista
if [ ! -f "$SSH_KEY.pub" ]; then
    echo "El archivo de clave pública $SSH_KEY.pub no existe. Generando nuevas claves SSH..."
    ssh-keygen -t rsa -b 2048 -N "" -f "$SSH_KEY"
fi

# Captura la clave pública SSH
SSH_PUB_KEY=$(cat "$SSH_KEY.pub")

# Crea el archivo de configuración YAML
cat > "$YAML_PATH" << EOF
variant: flatcar
version: 1.3.0
passwd:
  users:
    - name: $USER_NAME
      ssh_authorized_keys:
        - $SSH_PUB_KEY
EOF

# Utiliza Butane para convertir el YAML a IGN
butane --pretty --strict "$YAML_PATH" -o "$IGN_PATH"

if [ -f "$IGN_PATH" ]; then
    echo "El archivo IGN se ha generado correctamente en $IGN_PATH."
else
    echo "Error, el archivo IGN no se ha generado."
fi
