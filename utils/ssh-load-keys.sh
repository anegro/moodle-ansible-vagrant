#! /bin/bash

#ssh-add ~/.vagrant.d/insecure_private_key

vagrant ssh-config | awk '/IdentityFile/ { print $2 }' | while read KEY
do
	ssh-add "$KEY"
done
