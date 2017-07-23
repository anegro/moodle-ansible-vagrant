#! /bin/bash

function usage {
	echo "Usage: $0 {mount|unmount} host"
}

if [ $# != 2 ]; then
	usage
	exit
fi

ACTION=$1
HOST=$2

case $ACTION in
    mount)
        echo "Mounting..."
        
        IP=`vagrant ssh-config $HOST | awk '/HostName/ {print $2}'`
        PORT=`vagrant ssh-config $HOST | awk '/Port/ {print $2}'`
        
        [ ! -d mnt/$HOST ] && mkdir mnt/$HOST
		sshfs -p $PORT root@$IP:/ mnt/$HOST
        ;;

    unmount)
        echo "Unmounting..."
		fusermount -u mnt/$HOST
        ;;

    *)
		usage
        ;;
esac



