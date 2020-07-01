#!/bin/bash
#
#$ -N trimmomatic	   	# Job name
#$ -S /bin/bash         # Set shell to bash
#
#$ -l h_vmem=4G         # Request Max. Virt. Mem. (this is per core, see -pe option below)
#
#$ -q all.q@C146	# choose the queue (do just '-q all.q' if you don't have the node C146 reserved)
#$ -cwd                 # Change to current working directory
#$ -V                   # Export environment variables into script
#$ -pe smp 1    	# Select the parallel environment and specify the number of cores you want to reserve
#
#$ -o log.$JOB_NAME.$JOB_ID.out      # SGE-Output File
#$ -e log.$JOB_NAME.$JOB_ID.err      # SGE-Error File

#print some info to log
echo "Running under shell '${SHELL}' in directory '`pwd`' using $NSLOTS slots"
echo "Host: $HOSTNAME"
echo "Job: $JOB_ID"

#get going

echo -e "\n[$(date)] .. Starting ..\n"

singularity run docker://chrishah/trimmomatic-docker:0.38 \
trimmomatic PE -phred33 -trimlog trimmomatic.log -threads $NSLOTS \
../NGS-data/Illumina/full/full.1.fastq.gz ../NGS-data/Illumina/full/full.2.fastq.gz \
genomic_trimmomatic_paired_1.fastq.gz genomic_trimmomatic_orphan_1.fastq.gz \
genomic_trimmomatic_paired_2.fastq.gz genomic_trimmomatic_orphan_2.fastq.gz \
ILLUMINACLIP:/usr/src/Trimmomatic/0.38/Trimmomatic-0.38/adapters/TruSeq3-PE-2.fa:2:30:10 \
LEADING:30 TRAILING:30 SLIDINGWINDOW:5:20 MINLEN:100

echo -e "\n[$(date)] .. Done !\n"
