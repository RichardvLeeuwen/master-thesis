#!/bin/bash



duration=$1

node=$2

emptyjsonlogs="mv  ~/.apptainer/instances/app/ukko3-${node}.local.cs.helsinki.fi/rleeuwen/* /wrk-vakka/users/rleeuwen/temp"
deletelogs="rm -r  ~/.apptainer/instances/app/ukko3-${node}.local.cs.helsinki.fi/rleeuwen/*"

num=1

num2=10


rm mem.txt

rm swap.txt

rm cpu.txt

rm dl.txt

rm powerconsumed.txt

rm poweralloc.txt
rm pingmeasures/*
ssh rleeuwen@svm-30.cs.helsinki.fi rm powerconsumed.txt

ssh rleeuwen@svm-30.cs.helsinki.fi rm poweralloc.txt

ssh rleeuwen@svm-30.cs.helsinki.fi python3 script.py $node



read -r -a allCPU < <(head -n1 /proc/stat)

total=0

for i in ${allCPU[@]:1}; do

	let total+=$i

done

idle=${allCPU[4]}

unset allCPU

sleep 1

read -r -a allCPU < <(head -n1 /proc/stat)

totaln=0

for i in ${allCPU[@]:1}; do

	let totaln+=$i

done

idlen=${allCPU[4]}

cpudiff=$((totaln-total))

idlediff=$((idlen-idle))

idlepercent=$(echo "($idlediff*100)/$cpudiff" | bc -l )

cpuusage=$(echo "100-$idlepercent" | bc -l)

printf "%s," $cpuusage >> cpu.txt

unset allCPU

dl=$(curl -o /dev/null https://www.helsinki.fi/en &> /dev/stdout  | awk 'FNR ==3 {print $19}')

printf "%s," $dl >> dl.txt

memory=$(free --mega| awk '/Mem/{print $3}')

printf "%s," $memory >> mem.txt

swap=$(free --mega| awk '/Swap/{print $3}')

printf "%s," $swap >> swap.txt

pingcmd="singularity exec instance://0 redis-server --daemonize yes && singularity exec instance://0 redis-benchmark -c 10 -n 10 -t get,set -q "

singularity instance start alpined.sif 0

eval $pingcmd >> pingmeasures/0

singularity instance stop --all

for i in $(seq 1 $duration)

do	

	read -r -a allCPU < <(head -n1 /proc/stat)

	total=0

	for i in ${allCPU[@]:1}; do

		let total+=$i

	done

	idle=${allCPU[4]}



	unset allCPU



	for i in $(seq $num $num2)

	do

	      pingcmd="singularity exec instance://$i redis-server --daemonize yes && singularity exec instance://$i redis-benchmark -c 10  -t get,set -q -n 10 && singularity exec instance://$i redis-benchmark -c 10 -t get,set -n 10 -l > /dev/null 2>&1"

	      singularity instance start alpined.sif $i

	      eval $pingcmd >> pingmeasures/$i &	      

        done



	sleep 1

	read -r -a allCPU < <(head -n1 /proc/stat)

	totaln=0

	for i in ${allCPU[@]:1}; do

        	let totaln+=$i

	done

	idlen=${allCPU[4]}

	cpudiff=$((totaln-total))

	idlediff=$((idlen-idle))

	idlepercent=$(echo "($idlediff*100)/$cpudiff" | bc -l )

	cpuusage=$(echo "100-$idlepercent" | bc -l)

	printf "%s," $cpuusage >> cpu.txt

	unset allCPU

	memory=$(free --mega| awk '/Mem/{print $3}')

        printf "%s," $memory >> mem.txt
	
	swap=$(free --mega| awk '/Swap/{print $3}')

	printf "%s," $swap >> swap.txt
	dl=$(curl -o /dev/null https://www.helsinki.fi/en &> /dev/stdout  | awk 'FNR ==3 {print $19}')
	printf "%s," $dl >> dl.txt


	ssh rleeuwen@svm-30.cs.helsinki.fi python3 script.py $node
	let "num=num+10"

	let "num2=num2+10"

done
scp rleeuwen@svm-30.cs.helsinki.fi:/home/rleeuwen/powerconsumed.txt .
scp rleeuwen@svm-30.cs.helsinki.fi:/home/rleeuwen/poweralloc.txt .
singularity instance stop --all
