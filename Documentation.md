
sudo dnf install -y butane
butane --version

 butane --version
Butane 0.18.0

sudo chmod +x file_generation_v3.sh

ct, o Container Linux Config Transpiler, es una herramienta utilizada para convertir archivos de configuración legibles por humanos en archivos de configuración de Ignition que CoreOS Container Linux y Flatcar Container Linux pueden procesar durante el inicio del sistema. Ignition ejecuta estas configuraciones solo una vez durante el primer inicio del sistema.

Aquí te muestro cómo puedes descargar e instalar ct versión v0.9.4 en un sistema Linux x86_64, siguiendo el enlace que proporcionaste:

Descarga el Binario:
Primero, necesitas descargar el binario de ct desde los lanzamientos en GitHub. Puedes hacerlo usando curl o wget. Aquí utilizo curl:

bash
Copy code
sudo curl -L -o /usr/local/bin/ct https://github.com/flatcar/container-linux-config-transpiler/releases/download/v0.9.4/ct-v0.9.4-x86_64-unknown-linux-gnu
Este comando descarga ct y lo coloca en /usr/local/bin, que es un directorio común para ejecutables accesibles a todos los usuarios en el sistema.

Haz que ct sea Ejecutable:
Después de descargar el archivo, necesitas hacerlo ejecutable para poder correrlo. Usa el siguiente comando para cambiar los permisos del archivo y hacerlo ejecutable:

bash
Copy code
sudo chmod +x /usr/local/bin/ct
Verifica la Instalación:
Para asegurarte de que ct se instaló correctamente y está listo para usar, puedes verificar su versión con:

bash
Copy code
ct --version
Este comando debería imprimir la versión de ct que has descargado, confirmando que la herramienta está correctamente instalada y lista para ser utilizada.

Ahora que ct está instalado en tu sistema, puedes comenzar a convertir archivos de configuración de Container Linux (YAML) en archivos de configuración de Ignition (JSON) adecuados para CoreOS Container Linux y Flatcar Container Linux.

Recuerda ajustar la ruta de descarga en el paso 1 si estás utilizando una arquitectura diferente o si necesitas una versión diferente de ct.

./ct -in-file /ruta/a/tu/config.yaml -out-file /ruta/a/tu/config.ign



/root/ign/mv_instancia_flatcar-config.ign

./ct -in-file /ruta/a/tu/config.yaml -out-file /root/ign/mv_instancia_flatcar-config.ign

mv_instancia_flatcar-config.yaml


./ct -in-file /root/ign/mv_instancia_flatcar-config.yaml -out-file /root/ign/mv_instancia_flatcar-config.ign


Crea un archivo XML para definir la red. Puedes usar el siguiente ejemplo como base:
xml
Copy code
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

Guarda este contenido en un archivo, por ejemplo, default_network.xml.

Crea la red utilizando el comando virsh net-define:

bash
Copy code
sudo virsh net-define default_network.xml
Inicia la red recién definida:
bash
Copy code
sudo virsh net-start default
Una vez que hayas creado la red 'default', intenta ejecutar nuevamente el script para crear la máquina virtual.


https://medium.com/@technbd/multi-hosts-container-networking-a-practical-guide-to-open-vswitch-vxlan-and-docker-overlay-70ec81432092#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6IjA4YmY1YzM3NzJkZDRlN2E3MjdhMTAxYmY1MjBmNjU3NWNhYzMyNmYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTYyOTYwMzU4MzQtazFrNnFlMDYwczJ0cDJhMmphbTRsamRjbXMwMHN0dGcuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTY5NDk0NzM0MDQxODU2NTA3NTciLCJlbWFpbCI6InZoZ2FsdmV6QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYmYiOjE3MDk4NzMzMjksIm5hbWUiOiJWaWN0b3IgaHVnbyBnYWx2ZXogc2FzdG9xdWUiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUNnOG9jS0FoZ3hxdUp1NDJNLVROYXl4M09lWlRnOUROdzZGU3hiMy1zRFM4WjAzcWY5Nj1zOTYtYyIsImdpdmVuX25hbWUiOiJWaWN0b3IgaHVnbyIsImZhbWlseV9uYW1lIjoiZ2FsdmV6IHNhc3RvcXVlIiwibG9jYWxlIjoiZXMtNDE5IiwiaWF0IjoxNzA5ODczNjI5LCJleHAiOjE3MDk4NzcyMjksImp0aSI6ImI0OGJkMThhMjEzYWE3MzJhZmJiYzM1YmFiZTQ1NDgxYWEzYzU0MjAifQ.Fp4nNVACfw8OCqABM3ND3OIvrc4SfZm0xUtr4gaaeuNxygtXBIy27frt-8aaFFvNaoFTsYWzZo-4igbtJybNcZeWvOJcWoPYBTKmt6PuUB8ZMZzEdw7EV4WQA2RhUCg36KC2gxdd_wZ8VSZNTHpwYX76G-4QWepMrK43oKjEroieNR2zgOP6Uj7sLyXKYYkF0jq13iG1GKtFsMmOLhVoKSumK3H5RaEC3Jd4U0hAsP-53dN5ihoqRfb3s43TKiRds1EZB-QJXcvbCNV91wooEKLxFSaSKiSVvVbEelZh1oLDAVQI0jE_c9RoaumJHP3MkcO1MReIAjmLVxZdlZ2wzw