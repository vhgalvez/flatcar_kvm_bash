#!/bin/bash
# Uso: sh file_generation.sh <nombre_de_la_instancia>

set -x

if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <nombre_de_la_instancia>"
    exit 1
fi

VM_NAME="$1"
USER_NAME="core"
SSH_DIR="$HOME/.ssh"
SSH_KEY="$SSH_DIR/id_rsa.pub"

YAML_PATH="$HOME/ign/$VM_NAME-config.yaml"
IGN_PATH="$HOME/ign/$VM_NAME-config.ign"

mkdir -p "$SSH_DIR"
mkdir -p "$(dirname "$YAML_PATH")"

if [ ! -f "$SSH_KEY" ]; then
    echo "El archivo $SSH_KEY no existe. Generando una nueva clave SSH..."
    ssh-keygen -t rsa -b 2048 -N "" -f "$SSH_KEY"
fi

SSH_PUB_KEY=$(cat "$SSH_KEY")

cat > "$YAML_PATH" << EOF
variant: flatcar
version: 1.3.0  # Asegúrate de usar la versión correcta de Butane aquí
passwd:
  users:
    - name: $USER_NAME
      ssh_authorized_keys:
        - $SSH_PUB_KEY
EOF

if [ ! -f "$YAML_PATH" ]; then
  echo "Error, el archivo YAML no se generó."
  exit 1
else
  echo "El archivo YAML se generó correctamente en $YAML_PATH"
fi

butane --pretty --strict "$YAML_PATH" -o "$IGN_PATH"

if [ ! -f "$IGN_PATH" ]; then
  echo "Error, el archivo IGN no se generó."
  exit 1
else
  echo "El archivo IGN se generó correctamente en $IGN_PATH"
fi
