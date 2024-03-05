#!/bin/bash

VM_NAME=mv_instancia_flatcar
USER_NAME=core
SSH_DIR=/root/.ssh
SSH_KEY=$SSH_DIR/id_rsa
YAML_PATH=/root/ign/${VM_NAME}-config.yaml
IGN_PATH=/root/ign/${VM_NAME}-config.ign

# Crea el directorio SSH si no existe
mkdir -p "$SSH_DIR"

# Genera un nuevo par de claves SSH si no existe
if [ ! -f "$SSH_KEY" ]; then
    echo "Generando una nueva clave SSH..."
    ssh-keygen -t rsa -b 2048 -N '' -f "$SSH_KEY"
else
    echo "La clave SSH ya existe."
fi

# Prepara el archivo YAML con la clave pública
echo "Generando el archivo YAML..."
cat > "$YAML_PATH" <<EOF
variant: flatcar
version: 1.4.0
passwd:
  users:
    - name: $USER_NAME
      ssh_authorized_keys:
        - $(cat "$SSH_KEY.pub")
EOF

# Convierte el archivo YAML a formato IGN con Butane
echo "Convirtiendo YAML a formato IGN..."
butane --pretty --strict "$YAML_PATH" -o "$IGN_PATH"

# Verifica si el archivo IGN se ha generado correctamente
if [ -f "$IGN_PATH" ]; then
    echo "El archivo IGN se ha generado correctamente en $IGN_PATH."
else
    echo "Error, el archivo IGN no se ha generado."
    exit 1
fi
