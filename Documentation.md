
sudo dnf install -y butane
butane --version

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
