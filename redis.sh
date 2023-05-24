#!/bin/ash



redis-server --daemonize yes

test=$(head -c  400000000 /dev/urandom | base64 | tr -d '[:space:]')

kbyte=${test:0:102400000}

i=0

k=10000

sleep 1

redis-cli config set stop-writes-on-bgsave-error no

while true 

do



	while [ "$i" -le "$k" ];

        do

                #echo "i is $i and k is $k"

	       	echo "set $i $kbyte" | redis-cli 

		i=$(( i + 1 ))

        done 

	k=$(( k + 10000 ))

	i=$(( i + 10000 ))

	#for i in 'seq 1 10000'

       	#do

	#	echo set key $i ${test:RANDOM:1024}

	#done | redis-cli --pipe

	#echo "set one a set two b set three c" | redis-cli --pipe

	#redis-cli set one a

	#redis-cli set two b

	#redis-cli set three c

	#echo "get one get two get three" | redis-cli --pipe

	#redis-cli get one

	#redis-cli get two

	#redis-cli get three

	#echo "del one del two del three" | redis-cli --pipe

	#redis-cli del one

	#redis-cli del two

	#redis-cli del three

done

