#!/bin/bash

# the script accepts one argument file for storing the readings of performance events temporarily for each iteration of for loop in perf_inst function. 
# e.g., ./body_track.sh perf-result
# this script also creates a csv file and appends the required output data in that csv file
# This script also creates a total_output_bodyTrack.txt  where the perf results are appended to verify csv output file and deletes the original argument file.

csvFile="results_bodyTrack.csv"
echo "ins_per_cycle,execution_time,l1d_cache_loads,l1d_cache_miss,l1d_cache_miss_rate,l2_rqsts_all_demand_data_rd,l2_rqsts_dd_rd_miss,LLC-loads,LLC-load-misses,LLC-cache-miss-rate" >> $csvFile

outputFile=$1

# a function perf_inst has been created to get data readings of various performance events. A function to clear cache is run between consecutive perf statements to clear cache.
# The required number of threads and cores are passed to this function by the for loops following the function.
# The statements following the perf statement picks the required data from output using grep and awk utilities to append the required output in csv file.

perf_inst()
{
    threads=$1
    cores=$2
    echo "=== test run with $threads threads ===" >> $csvFile
    echo "=== test run with $threads threads ===" >> $outputFile
    for j in 1 2 3
    do
    	perf stat -e instructions,cycles -o  $outputFile --append taskset -c $cores ./bodytrack sequenceB_261 4 20 4000 5 2 $threads 4
	ins_per_cyc=`cat $outputFile | grep insn | awk '{print $4}'`
	exe_time=`cat $outputFile | grep elapsed | awk '{print $1}' | sed 's/,//g'`
	./a.out
	perf stat -e L1-dcache-loads,L1-dcache-load-misses -o $outputFile  --append taskset -c $cores ./bodytrack sequenceB_261 4 20 4000 5 2 $threads 4
	l1d_cache_loads=`cat $outputFile | grep L1-dcache-loads | awk '{print $1}' | sed 's/,//g'`
	l1d_cache_miss=`cat $outputFile | grep L1-dcache-load-misses | awk '{print $1}' | sed 's/,//g'`	
	l1d_cache_miss_rate=`cat $outputFile | grep L1-dcache-load-misses | awk '{print $4}' | sed 's/,//g'`
	./a.out
	perf stat -e rE124,r2124 -o $outputFile --append taskset -c $cores   ./bodytrack sequenceB_261 4 20 4000 5 2 $threads 4
	l2_rqsts_all_dd_rd=`cat $outputFile | grep rE124 | awk '{print $1}' | sed 's/,//g'`
	l2_rqsts_dd_rd_miss=`cat $outputFile | grep r2124 | awk '{print $1}' | sed 's/,//g'`	
	./a.out	
	perf stat -e LLC-loads,LLC-load-misses -o $outputFile --append taskset -c $cores   ./bodytrack sequenceB_261 4 20 4000 5 2 $threads 4	
	llc_loads=`cat $outputFile | grep LLC-loads | awk '{print $1}' | sed 's/,//g'`
	llc_miss=`cat $outputFile | grep LLC-load-misses | awk '{print $1}' | sed 's/,//g'`
	llc_cache_miss_rate=`cat $outputFile | grep LL-cache | awk '{print $4}' | sed 's/,//g'`	    
	./a.out
		
	
	
	echo "$ins_per_cyc,$exe_time,$l1d_cache_loads,$l1d_cache_miss,$l1d_cache_miss_rate,$l2_rqsts_all_dd_rd,$l2_rqsts_dd_rd_miss,$llc_loads,$llc_miss,$llc_cache_miss_rate" >> $csvFile
	cat $outputFile >> total_output_bodyTrack.txt
	rm -f $outputFile
    done 
    
      
}

echo "====Test run with hyperthreading===" >> $csvFile
echo "=== Test run with hyperthreading ===" >> $outputFile

# This for loop is used to pass the number of cores and threads to perf_inst function for various cases of hyperthreading.
# The cores passed are two logical cores that share same physical core.

for i in 2 4 8 16
do
        if [ $i == 2 ]
        then                
           perf_inst $i 4,10  

        fi


       if [ $i == 4 ]
       then		
	   perf_inst $i 4,10,1,11   
       fi
	
       if [ $i == 8 ]
        then
            perf_inst $i 4,10,1,11,2,12,3,13   
        fi


        if [ $i == 16 ]
        then                
            perf_inst $i 4,10,1,11,2,12,3,13,0,14,5,15,6,16,7,17  
        fi

done
      
echo "====Test run without hyperthreading===" >> $csvFile
echo "=== Test run without hyperthreading ===" >> $outputFile

# This for loop is used to pass the number of cores and threads to perf_inst function for various cases of without-hyperthreading.
# The cores passed are two logical cores that does not share same physical core.

for i in 1 2 4 8
do
        if [ $i == 1 ]
        then                
           perf_inst $i 4

        fi


       if [ $i == 2 ]
       then		
	   perf_inst $i 4,1 
       fi
	
       if [ $i == 4 ]
        then
            perf_inst $i 4,1,12,13   
        fi


        if [ $i == 8 ]
        then                
            perf_inst $i 4,1,12,13,0,5,6,7  
        fi

done




  
        
