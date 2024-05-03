# Documento Técnico: Configuración de Herramientas y Redes para CEFAS Local Server

## Instalación de Herramientas

### Butane

1. **Instalación**:

   ```bash
   sudo dnf install -y butane
   ```

   ```bash
   butane --version
   ```

Container Linux Config Transpiler (ct)

Descarga de ct:

```bash
sudo curl -L -o /usr/local/bin/ct https://github.com/flatcar/container-linux-config-transpiler/releases/download/v0.9.4/ct-v0.9.4-x86_64-unknown-linux-gnu
```

Hacer ct Ejecutable:

```bash
sudo chmod +x /usr/local/bin/ct
```

Verificación:

```bash
ct --version
```

Ejemplos de Uso de ct

Convertir configuración YAML en Ignition JSON:

```bash
./ct -in-file /ruta/a/tu/config.yaml -out-file /ruta/a/tu/config.ign
```

Configuración de Red Virtual

Definición de Red con XML:

```xml
<network>
  <name>default</name>
  <forward mode="nat"/>
  <bridge name="virbr0" />
  <ip address="192.168.122.1" netmask="255.255.255.0">
    <dhcp>
      <range start="192.168.122.2" end="192.168.122.254"/>
    </dhcp>
  </ip>
</network>
```

Crear y Iniciar la Red:

```bash
sudo virsh net-define default_network.xml
sudo virsh net-start default
sudo virsh net-autostart default
```

Este documento proporciona una guía clara sobre cómo instalar y configurar herramientas esenciales en un entorno Linux, junto con la configuración de una red virtual usando virsh.
