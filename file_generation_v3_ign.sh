#!/bin/bash

# Variables generales
VM_NAME=mv_instancia_flatcar
USER_NAME=core
SSH_DIR=/root/.ssh

# Aquí utilizamos la variable VM_NAME para personalizar el nombre de las claves
KEY_NAME="id_rsa_${VM_NAME}"
SSH_PRIVATE_KEY="${SSH_DIR}/${KEY_NAME}"  # Ruta de la clave privada actualizada correctamente
SSH_PUBLIC_KEY="${SSH_DIR}/${KEY_NAME}.pub"  # Definición explícita de la ruta de la clave pública
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
    echo "La clave SSH se ha generado correctamente en $SSH_DIR para $VM_NAME."
else
    echo "La clave SSH ya existe para $VM_NAME en $SSH_DIR."
fi

# Ajusta los permisos de las claves
chmod 600 "$SSH_PRIVATE_KEY"
chmod 644 "$SSH_PUBLIC_KEY"

# Prepara el archivo YAML con la clave pública
echo "Generando el archivo YAML para $VM_NAME..."
cat > "$YAML_PATH" <<EOF
variant: flatcar
version: 1.1.0  # Ajusta la versión si es necesario para tu entorno específico
passwd:
  users:
    - name: $USER_NAME
      ssh_authorized_keys:
        - $(cat "$SSH_PUBLIC_KEY")
EOF

# Convierte el archivo YAML a formato IGN con Butane
echo "Convirtiendo YAML a formato IGN para $VM_NAME..."
butane --pretty --strict "$YAML_PATH" -o "$IGN_PATH"

# Verifica si el archivo IGN se ha generado correctamente
if [ -f "$IGN_PATH" ]; then
    echo "El archivo IGN se ha generado correctamente en $IGN_PATH para $VM_NAME."
else
    echo "Error, el archivo IGN no se ha generado para $VM_NAME."
    exit 1
fi

# Muestra el contenido del directorio de las claves SSH
echo "Verificando la generación de las claves SSH para $VM_NAME..."
ls -lha "$SSH_DIR"