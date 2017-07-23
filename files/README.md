Colocar aquí los archivos necesarios para instalar Moodle:

- Paquete principal
- Paquetes de idioma
- Plugins
- Parches
- Etcétera

Por ejemplo, este directorio podría contener lo siguiente:

~~~
./backup/moodledata.tar.gz
./backup/moodle_db.sql
./backup/config.php

./moodle27/mysqli_native_moodle_database.php.patched
./moodle27/moodle-2.7.tgz
./moodle27/es.zip

./moodle30/moodle-3.0.10.tgz
./moodle30/es.zip

./moodle33/moodle-latest-33.tgz
./moodle33/es.zip

./plugins/report_coursesize_moodle31_2016051600.zip
./plugins/format_onetopic_moodle27_2014092802.zip
./plugins/report_coursesize_moodle30_2011081300.zip
./plugins/format_onetopic_moodle32_2016071402.zip
~~~

En el directorio `backup` es donde se colocan, por defecto, las copias de seguridad realizadas con el playbook suministrado.
