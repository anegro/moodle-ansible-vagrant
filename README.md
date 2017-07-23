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
- name: server1
  box: ubuntu/xenial64
  ram: 512
  ip: 172.31.0.11
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

!!! Nota
	Puede que primero necesitemos dar permiso de ejecución a los *scripts*. Para ello podemos hacer lo siguiente: `chmod a+x *.sh`.


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

!!! Advertencia
	Ninguno de los directorios en la ruta hasta llegar al *playbook* puede contener espacios en blanco ni caracteres extraños.
