#!/bin/bash

# Variables generales
VM_NAME=mv_instancia_flatcar
USER_NAME=core
SSH_DIR=/root/.ssh
KEY_NAME="id_rsa_${VM_NAME}"  # Cambio realizado para usar el nombre personalizado
SSH_PRIVATE_KEY="${SSH_DIR}/${KEY_NAME}"  # Ruta de la clave privada actualizada
YAML_PATH="/root/ign/${VM_NAME}-config.yaml"
IGN_PATH="/root/ign/${VM_NAME}-config.ign"
SSH_EMAIL="vhgalvez@gmail.com"

# Crea el directorio SSH si no existe
mkdir -p "$SSH_DIR"

# Ajusta los permisos del directorio
chmod 700 "$SSH_DIR"

# Genera un nuevo par de claves SSH si no existe
if [ ! -f "$SSH_PRIVATE_KEY" ]; then
    echo "Generando una nueva clave SSH para $VM_NAME..."
    ssh-keygen -t rsa -b 2048 -N '' -f "$SSH_PRIVATE_KEY" -C "$SSH_EMAIL"
    echo "La clave SSH se ha generado correctamente en $SSH_DIR."
else
    echo "La clave SSH ya existe para $VM_NAME en $SSH_DIR."
fi

# Ajusta los permisos de las claves
chmod 600 "$SSH_PRIVATE_KEY"
chmod 644 "${SSH_PRIVATE_KEY}.pub"

# Prepara el archivo YAML con la clave pública
echo "Generando el archivo YAML..."
cat > "$YAML_PATH" <<EOF
variant: flatcar
version: 1.0.0  # Versión ajustada para compatibilidad
passwd:
  users:
    - name: $USER_NAM
      ssh_authorized_keys:
        - $(cat "${SSH_PRIVATE_KEY}.pub")
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

# Muestra el contenido del directorio de las claves SSH
echo "Verificando la generación de las claves SSH para $VM_NAME..."
ls -lha "$SSH_DIR"