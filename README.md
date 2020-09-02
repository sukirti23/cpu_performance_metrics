# cpu_performance_metrics
Collection of various CPU Performance Metrics using Linux perf utility (Shell Script) 

1) Give the execute permission to body_track.sh file using command chmod +x body_track.sh

2) Complile the randomize_function using command
                  gcc randomize_function.c

3) Run the script using command
		  ./body_track.sh perf-result
where perf-result is argument passed to this script file.


4) Check the two output files-
	results_bodyTrack.csv file provides data as comma separated values
	total_output_bodyTrack.txt provides data to verify output of csv file
 total_output_bodyTrack.txt to store the output.
 
 
 The same process can be repeated for fluidanimate.sh and h264dec.sh files.
