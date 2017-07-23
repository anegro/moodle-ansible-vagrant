# Moodle-ansible-vagrant


## Descripción

Conjunto de archivos de configuración de Ansible y Vagrant con el objetivo de poder desplegar un escenario de pruebas completo y funcional para la instalación y administración de Moodle. Se incluyen *playbooks* para:

- Instalar Moodle, incluyendo paquetes de idioma, plugins y parches.
- Actualizar Moodle.
- Hacer copias de seguridad.
- Restaurar copias de seguridad.


## Requisitos

Este escenario ha sido desarrollado y probado utilizando las siguientes herramientas:

- **Vagrant 1.8.6**
- **Ansible 2.3.1.0**


## Utilización básica

### 1) Definir las máquinas virtuales del escenario

Lo normal es editar el archivo `Vagrantfile`, pero está escrito en **Ruby** y es algo complicado a la hora de describir escenarios multi-máquina. Como alternativa, en esta plantilla se utiliza una `Vagrantfile` modificado que obtiene la descripción del escenario de un archivo en formato **YAML**, de modo que solo tendremos que editar el archivo `Vagrantfile.yml` donde realizaremos la descripción del escenario. Una posible descripción puede ser la siguiente:

~~~
---
prefix: 'moodle'

servers:
  - name: server1
    box: ubuntu/xenial64
    ram: 512
    ip: 172.31.0.11
    mask: 255.255.0.0
~~~


### 2) Desplegar el escenario con Vagrant

Utilizar **Vagrant** para poner en marcha las máquinas virtuales con el siguiente comando:

~~~
vagrant up
~~~


### 3) Generar el archivo de inventario de Ansible

Para ello podemos editar manualmente el archivo `hosts` y adaptarlo a nuestras necesidades:

~~~
# inventory file for local development

[default]
server1 ansible_ssh_host=127.0.0.1 ansible_ssh_port=2222 ansible_ssh_user=vagrant
server2 ansible_ssh_host=127.0.0.1 ansible_ssh_port=2200 ansible_ssh_user=vagrant
~~~

También podemos utilizar un *script* (una vez desplegado el escenario con Vagrant) para generarlo de forma automática:

~~~
./utils/generate-hosts.sh
~~~


### 4) Cargar las claves criptográficas para acceder por SSH

Por defecto se suele utilizar la misma clave criptográfica en todas las *Vagrant boxes* (lo cual es inseguro):

~~~
ssh-add ~/.vagrant.d/insecure_private_key
~~~

Si no está definida la opción `config.ssh.insert_key = false` en el `Vagrantfile`, la clave insegura será sustituida automáticamente por una nueva clave segura y única para cada máquina virtual.

Podemos utilizar un *script* para cargar automáticamente las claves de todas las máquinas virtuales de nuestro escenario (ya sean nuevas o por defecto):

~~~
./utils/ssh-load-keys.sh
~~~


### 5) Gestionar la configuración con Ansible

Editaremos el archivo `site.yml` donde escribiremos un *playbook* de **Ansible** que nos permita aplicar la configuración deseada en cada una de las máquinas virtuales. Seguidamente, ejecutamos el *playbook*:

~~~
ansible-playbook site.yml
~~~


## Uso avanzado

### Configuración

Editar el archivo `vars/main.yml` y especificar los parámetros para una instalación personalizada:

~~~.yml
---
# Configuración global de los playbooks


# Apache
server_name: "webserver"
server_admin: "admin@iesluisvelez.org"
document_root: "/var/www/"


# Base de datos
db_name: "moodle_db"
db_user: "moodle_usr"
db_pass: "moodle_pass"
db_create_tables: yes


# Directorios de Moodle
moodle_dir: "/var/www/moodle"
moodle_dir_owner: "root"
moodle_dir_group: "root"
moodle_dir_permissions_dirs: "0755"
moodle_dir_permissions_files: "0644"

moodle_data: "/var/moodledata"
moodle_data_owner: "www-data"
moodle_data_group: "www-data"
moodle_data_permissions_dirs: "0700"
moodle_data_permissions_files: "0600"


# Copias de seguridad
backup_dir: "/vagrant/files/backup"


# Configuración de la plataforma
moodle_hostname: "127.0.0.1"
moodle_wwwroot: "http://{{ moodle_hostname }}/moodle"
moodle_admin: "admin"
moodle_password: "entrar"
moodle_email: "{{ server_admin }}"

moodle_sitefullname: "Plataforma Educativa"
moodle_siteshortname: "Moodle"
moodle_sitesummary: "<p>Materiales educativos</p>"

moodle_config_php_options:
  - name: 'wwwroot'
    value: "http://' . (isset($_SERVER['HTTP_HOST'])?$_SERVER['HTTP_HOST']:'127.0.0.1') . '/moodle"
  - name: 'lang'
    value: 'es'


# Instalación de los archivos de la aplicación
#moodle_version: 2.7
#moodle_tarball: "moodle27/moodle-2.7.tgz"
#moodle_langpack: "moodle27/es.zip"
#moodle_langdir: "es"
#moodle_install_plugins:
#  - type: 'course/format'
#    directory: 'onetopic'
#    package: 'plugins/format_onetopic_moodle27_2014092802.zip'
#  - type: 'report'
#    directory: 'coursesize'
#    package: 'plugins/report_coursesize_moodle30_2011081300.zip'
#moodle_install_patches:
#  # https://tracker.moodle.org/browse/MDL-50633
#  - source: 'moodle27/mysqli_native_moodle_database.php.patched'
#    target: 'lib/dml/mysqli_native_moodle_database.php'

#moodle_version: 3.0
#moodle_tarball: "moodle30/moodle-3.0.10.tgz"
#moodle_langpack: "moodle30/es.zip"
#moodle_langdir: "es"
#moodle_install_plugins:
#  - type: 'course/format'
#    directory: 'onetopic'
#    package: 'plugins/format_onetopic_moodle30_2016020501.zip'
#  - type: 'report'
#    directory: 'coursesize'
#    package: 'plugins/report_coursesize_moodle31_2016051600.zip'

moodle_version: 3.3
moodle_tarball: "moodle33/moodle-latest-33.tgz"
moodle_langpack: "moodle33/es.zip"
moodle_langdir: "es"
moodle_install_plugins:
  - type: 'course/format'
    directory: 'onetopic'
    package: 'plugins/format_onetopic_moodle32_2016071402.zip'
  - type: 'report'
    directory: 'coursesize'
    package: 'plugins/report_coursesize_moodle31_2016051600.zip'
~~~

También es posible incluir ajustes personalizados para la configuración de los roles `mysql`, `php` y `apache`. Consultar el correspondiente archivo `defaults/main.yml` de valores por defecto de cada rol.

### Instalación de Moodle

Para instalar Moodle en un servidor limpio, podemos ejecutar:

~~~
ansible-playbook site.yml
~~~

Esto instalará y configurará Apache, MySQL y PHP. Seguidamente se realizarán las siguientes operaciones específicas para Moodle:

- Descomprimir los archivos de la aplicación web en `/var/www`.
- Descomprimir paquetes de idoma (opcional).
- Descomprimir plugins (opcional).
- Aplicar parches (opcional).
- Ajustar los permisos del directorio de la aplicación web.
- Preparar directorio `moodledata`.
- Preparar la base de datos para Moodle (base de datos vacía, usuario, privilegios).
- Crear el archivo de configuración `config.php` con los ajustes necesarios.
- Instalar Moodle en modo desatendido, creando todas las tablas necesarias en la base de datos (opcional).

En caso de que el servidor ya tenga instalado el software de base, podemos pasar a ejecutar directamente:

~~~
ansible-playbook moodle-install.yml
~~~

### Realizar copia de seguridad

Es posible realizar una copia de seguridad de una instalación de Moodle. Para ello podemos utilizar el *playbook* `moodle-backup.yml` que realizará lo siguiente:

- Crear un volcado de la base de datos de Moodle: `moodle_db.sql`.
- Crear una copia de seguridad de `moodledata`: `moodledata.tar.gz`.
- Guardar una copia del archivo `config.php` con todos los ajustes que contenga.

Por defecto, estos archivos son copiados en el directorio `/vagrant/files/backups` de la máquina virtual, con lo cual deberían aparecer en el directorio `files/backups` del anfitrión.

### Restaurar copia de seguridad

Para restaurar una copia de seguridad de una instalación de Moodle podemos utilizar el *playbook* `moodle-restore.yml` que realizará lo siguiente:

- Importa un volcado de la base de datos de Moodle: `moodle_db.sql`.
- Restaura el directorio `moodledata` a partir de una copia: `moodledata.tar.gz`.
- Restaura el archivo `config.php` con todos los ajustes.

Por defecto, la ubicación de los archivos de la copia de seguridad debe ser `files/backups` (en el anfitrión).

### Actualizar Moodle

Para actualizar una instalación de Moodle a una versión más moderna podemos utilizar el *playbook* `moodle-upgrade.yml`. El proceso de actualización se asemeja al de instalación, pero no se creará la base de datos ni el directorio `moodledata`. Concretamente, se realizará lo siguiente:

- Crear una copia de seguridad de `config.php`.
- Activar el **modo mantenimiento** de la aplicación.
- Eliminar los archivos de la versión antigua de la aplicación.
- Descomprimir los archivos de nueva versión.
- Descomprimir paquetes de idoma (opcional).
- Descomprimir plugins (opcional).
- Aplicar parches (opcional).
- Ajustar los permisos del directorio de la aplicación web.
- Restaurar el archivo de configuración `config.php` con los ajustes originales.
- Ejecutar el script de actualización de Moodle en modo desatendido.
- Desactivar el **modo mantenimiento** de la aplicación.

### Activar mensajes de error de PHP

En ocasiones nos puede interesar activar o desactivar los mensajes de error de PHP. Para ello podemos utilizar el *playbook* `debug-php.yml`:

~~~
# Mostrar errores de PHP
ansible-playbook debug-php.yml --tags enable

# Ocultar errores de PHP
ansible-playbook debug-php.yml --tags disable
~~~

moodle-restore.yml
moodle-upgrade.yml

## Referencias

- [HCPSS/ansible-role-moodle](https://github.com/HCPSS/ansible-role-moodle)
- [geerlingguy/ansible-role-apache](https://github.com/geerlingguy/ansible-role-apache)
- [geerlingguy/ansible-role-mysql](https://github.com/geerlingguy/ansible-role-mysql)
- [geerlingguy/ansible-role-php](https://github.com/geerlingguy/ansible-role-php)
