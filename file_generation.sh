#!/bin/bash
# sh file_generation.sh my_instance

# Habilita la impresión de comandos antes de ejecutarlos
set -x

# Verificar que se proporcionó el argumento correcto
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <nombre_de_la_instancia>"
    exit 1
fi

# Establecer variables
VM_NAME="$1"

# Define las variables utilizadas en el script
USER_NAME="core"
SSH_DIR="/.ssh"
SSH_KEY="$SSH_DIR/id_rsa.pub"  # Tu clave pública SSH

YAML_PATH="/ign/config.yaml"
IGN_PATH="/ign/config.ign"

# Crea el directorio .ssh si no existe
mkdir -p "$SSH_DIR"

# Verifica que el archivo SSH_KEY exista
if [ ! -f "$SSH_KEY" ]; then
    echo "El archivo $SSH_KEY no existe"

    # Genera una nueva clave SSH
    echo "Generando clave SSH..."
    ssh-keygen -t rsa -b 2048 -N "" -f "$SSH_DIR/id_rsa"
fi

SSH_PUB_KEY=$(cat "$SSH_KEY")

# Crea el archivo de configuración yaml para Flatcar
cat > "$YAML_PATH" << EOF
variant: flatcar
version: 1.4.0
passwd:
  users:
    - name: $USER_NAME
      ssh_authorized_keys:
        - $SSH_PUB_KEY
EOF

if [ ! -f "$YAML_PATH" ]; then
  echo "Error, el archivo YAML no se generó"
  exit 1
else
  echo "El archivo YAML se generó correctamente"
fi

# Convierte el archivo de configuración de Ignition a un archivo .ign con Butane
butane --pretty --strict "$YAML_PATH" -o "$IGN_PATH"

if [ ! -f "$IGN_PATH" ]; then
  echo "Error, el archivo IGN no se generó"
  exit 1
else
  echo "El archivo IGN se generó correctamente"
fi
