#!/bin/bash



duration=$1

ip=$2

node=$3

emptyjsonlogs="mv  ~/.apptainer/instances/app/ukko3-${node}.local.cs.helsinki.fi/*/* /wrk-vakka/users/*/temp"
deletelogs="rm -r  ~/.apptainer/instances/app/ukko3-${node}.local.cs.helsinki.fi/*/*"

num=1

num2=100


rm mem.txt

rm cpu.txt

rm pingmeasures/*

rm powerconsumed.txt

rm poweralloc.txt

ssh @svm-30.cs.helsinki.fi rm powerconsumed.txt

ssh @svm-30.cs.helsinki.fi rm poweralloc.txt

ssh @svm-30.cs.helsinki.fi python3 script.py $node



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

              pingcmd="singularity exec instance://$i ping $ip -c 10 && singularity exec instance://$i ping $ip > /dev/null 2>&1"

              singularity instance start alpine_latest.sif $i

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

        ssh @svm-30.cs.helsinki.fi python3 script.py $node
        eval $emptyjsonlogs
        let "num=num+100"

        let "num2=num2+100"

done
scp @svm-30.cs.helsinki.fi:/home/**powerconsumed.txt .
scp @svm-30.cs.helsinki.fi:/home/**/poweralloc.txt .
sleep 60
cd /wrk-vakka/users/*/temp
for x in $(seq 1 $duration); do
        mv `ls | head -100` ~/.apptainer/instances/app/ukko3-${node}.local.cs.helsinki.fi/*
        singularity instance stop --all
done

