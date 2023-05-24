#!/bin/ash



redis-server --daemonize yes

test=$(head -c  400000000 /dev/urandom | base64 | tr -d '[:space:]')

kbyte=${test:0:10240000}

i=0

k=10 

sleep 1

redis-cli config set stop-writes-on-bgsave-error no

while true 

do



	while [ "$i" -lt "$k" ];

        do

		sizei=${#i}

		sizevar=1



	       	echo -e -n "*3\r\n\$3\r\nSET\r\n\$${sizei}\r\n${i}\r\n\$${sizevar}\r\na\r\n" 

		i=$(( i + 1 ))

        done | redis-cli --pipe

	i=$(( i + 10 ))

	k=$(( k + 10 ))

done

