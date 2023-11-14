#!/bin/bash

#PBS -N trimmomatic.$PBS_JOBID
#PBS -l nodes=1:ppn=8
#PBS -o $PBS_JOBID.trimmomatic.stdout						
#PBS -e $PBS_JOBID.trimmomatic_1.stderr
#PBS -l walltime=0:30:00
#PBS -m abe
#PBS -M pieter.asselman@ugent.be


# Data Paths

ILLUMINA_RAWDATA=/<path to your>/rawdata #take notice of the file extension names different options '.fq.gz' '.fastq.gz'
ILLUMINA_ADAPTERS=/<path to your>/adapters

# output directories qc
#TRIMMOMATIC_OUT=/user/gent/433/vsc43352/scratch_vo/genomes/WMKJ_SRX7128323/rawdata/out_trimmomatic_$(date +"%Y-%m-%d_%H-%M-%S")
TRIMMOMATIC_OUT=/<path to your>/out_trimmomatic


# QC directories
mkdir $TRIMMOMATIC_OUT

# Create sampleslist to itterate, serves as input for itteration process in trimmomatic
for f in $ILLUMINA_RAWDATA/*_1.fastq.gz
 do
  echo "$(basename "$f" "_1.fastq.gz")" #check if your files have the same extension layout! Adjust if necessary.
done > $ILLUMINA_RAWDATA/samples.txt &&


# Load modules
module load Trimmomatic/0.39-Java-11

### Run trimmomatic SE OR PE reads #-out what you don't need!

while read p
do 

### ACTIVATE FOR SE data
#java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar SE -phred33 -trimlog $TRIMMOMATIC_OUT/$p".log" $ILLUMINA_RAWDATA/$p"_R1.fastq.gz" $TRIMMOMATIC_OUT/$p"_R1_trimmed.fastq" ILLUMINACLIP:$ILLUMINA_ADAPERS/alladapterstrimmomatic.fa:2:30:10:1:TRUE SLIDINGWINDOW:5:20

### ACTIVATE FOR PE data
java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar PE -phred33 -trimlog $TRIMMOMATIC_OUT/$p".log" \
      $ILLUMINA_RAWDATA/$p"_1.fastq.gz" \
      $ILLUMINA_RAWDATA/$p"_2.fastq.gz" \
      $TRIMMOMATIC_OUT/$p"_1_trimmed_paired.fastq" \
      $TRIMMOMATIC_OUT/$p"_1_trimmed_unpaired.fastq" \
      $TRIMMOMATIC_OUT/$p"_2_trimmed_paired.fastq" \
      $TRIMMOMATIC_OUT/$p"_2_trimmed_unpaired.fastq" \
      ILLUMINACLIP:$ILLUMINA_ADAPTERS/alladapterstrimmomatic.fa:2:30:10:1:TRUE SLIDINGWINDOW:5:20
  
done < $ILLUMINA_RAWDATA/samples.txt
