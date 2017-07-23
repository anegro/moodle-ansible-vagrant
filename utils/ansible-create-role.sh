#! /bin/bash

########################################################################
#
# Comprobar argumentos
#
########
if [ $# != 1 ]; then
	echo "Usage: $0 rolename"
	exit
fi


#mkdir -p roles/$1/{files,templates,tasks,handlers,vars,defaults,meta}

ansible-galaxy -p roles/ init $1
