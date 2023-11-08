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

rm powerconsumed.txt

rm poweralloc.txt

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



memory=$(free --mega| awk '/Mem/{print $3}')

printf "%s," $memory >> mem.txt

swap=$(free --mega| awk '/Swap/{print $3}')

printf "%s," $swap >> swap.txt



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

	      pingcmd="singularity exec instance://$i /./redis.sh > /dev/null 2>&1"

	      singularity instance start alpined.sif $i

	      eval $pingcmd &	      

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

	ssh rleeuwen@svm-30.cs.helsinki.fi python3 script.py $node
	let "num=num+10"

	let "num2=num2+10"

done
scp rleeuwen@svm-30.cs.helsinki.fi:/home/rleeuwen/powerconsumed.txt .
scp rleeuwen@svm-30.cs.helsinki.fi:/home/rleeuwen/poweralloc.txt .
singularity instance stop --all
