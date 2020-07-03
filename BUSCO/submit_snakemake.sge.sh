#!/bin/bash
#
#$ -N sn-CH	   	# Job name
#$ -S /bin/bash         # Set shell to bash
#
#$ -l h_vmem=4G         # Request Max. Virt. Mem. (this is per core, see -pe option below)
#
#$ -q all.q	# choose the queue (do just '-q all.q' if you don't have the node C146 reserved)
#$ -cwd                 # Change to current working directory
#$ -V                   # Export environment variables into script
#$ -pe smp 3    	# Select the parallel environment and specify the number of cores you want to reserve
#
#$ -o log.$JOB_NAME.$JOB_ID.out      # SGE-Output File
#$ -e log.$JOB_NAME.$JOB_ID.err      # SGE-Error File

#print some info to log
echo "Running under shell '${SHELL}' in directory '`pwd`' using $NSLOTS slots"
echo "Host: $HOSTNAME"
echo "Job: $JOB_ID"

#get going

echo -e "\n[$(date)] .. Starting ..\n"

snakemake \
--use-singularity --singularity-args "-B $(pwd)/../ -B /usr/people/EDVZ/hahnc/AMEB_2020_practical/BUSCO/" \
-j 6 -p \
--config \
dir=/usr/people/EDVZ/hahnc/AMEB_2020_practical/BUSCO/ \
ingroup="$(pwd)/ingroup.txt" outgroup="$(pwd)/outgroup.txt" \
files="$(cat my_subset.txt | tr '\n' ' ' | sed 's/ $//')"

echo -e "\n[$(date)] .. Done !\n"
