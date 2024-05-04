#!/bin/bash

# Variables generales
PROJECT_NAME="cluster_openshift"
VM_NAME="key_cluster_openshift"
USER_NAME="core"
SSH_DIR="/root/.ssh/${PROJECT_NAME}/${VM_NAME}"
CONFIG_DIR="/root/.ssh/${PROJECT_NAME}/ignition"  # Ruta personalizada para configuración
TFVARS_DIR="/root/.ssh/${PROJECT_NAME}/terraform/" # Ruta al directorio de Terraform

# Nombres de archivo personalizados
YAML_TMPL_NAME="config.yaml.tmpl"
IGN_FILE_NAME="${VM_NAME}-config.ign"
TFVARS_FILE_NAME="terraform.tfvars"
YAML_TMPL_PATH="${CONFIG_DIR}/${YAML_TMPL_NAME}"
IGN_PATH="${CONFIG_DIR}/${IGN_FILE_NAME}"
TFVARS_PATH="${TFVARS_DIR}/${TFVARS_FILE_NAME}"

# Claves SSH
KEY_NAME="id_rsa_${VM_NAME}"
SSH_PRIVATE_KEY="${SSH_DIR}/${KEY_NAME}"
SSH_PUBLIC_KEY="${SSH_DIR}/${KEY_NAME}.pub"
SSH_EMAIL="vhgalvez@gmail.com"

# Crear directorios necesarios
mkdir -p "$SSH_DIR"
mkdir -p "$CONFIG_DIR"
mkdir -p "$TFVARS_DIR"
chmod 700 "$SSH_DIR"
chmod 700 "$CONFIG_DIR"
chmod 700 "$TFVARS_DIR"

# Generación de claves SSH
if [ ! -f "$SSH_PRIVATE_KEY" ]; then
    echo "Generando una nueva clave SSH para $VM_NAME..."
    ssh-keygen -t rsa -b 2048 -N '' -f "$SSH_PRIVATE_KEY" -C "$SSH_EMAIL"
    echo "La clave SSH se ha generado correctamente en $SSH_DIR para $VM_NAME."
else
    echo "La clave SSH ya existe para $VM_NAME en $SSH_DIR."
fi

chmod 600 "$SSH_PRIVATE_KEY"
chmod 644 "$SSH_PUBLIC_KEY"

# Preparación del archivo de plantilla YAML
echo "Generando el archivo de plantilla YAML para $VM_NAME en $YAML_TMPL_PATH..."
cat > "$YAML_TMPL_PATH" <<EOF
---
passwd:
  users:
    - name: core
      ssh_authorized_keys: \${ssh_keys}

storage:
  files:
    - path: /etc/hostname
      filesystem: "root"
      mode: 0644
      contents:
        inline: \${host_name}
    - path: /home/core/works
      filesystem: root
      mode: 0755
      contents:
        inline: |
          #!/bin/bash
          set -euo pipefail
          echo My name is \${name} and the hostname is \${host_name}
EOF

# Generación del archivo terraform.tfvars
echo "Generando el archivo terraform.tfvars en $TFVARS_PATH..."
cat > "$TFVARS_PATH" <<EOF
ssh_keys       = ["$(cat "$SSH_PUBLIC_KEY")"]
EOF

echo "El archivo terraform.tfvars se ha generado correctamente en $TFVARS_PATH."

# Verificación de las claves SSH
echo "Verificando la generación de las claves SSH para $VM_NAME..."
ls -lha "$SSH_DIR"
