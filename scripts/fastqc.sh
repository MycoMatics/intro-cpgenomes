#!/usr/bin/bash                                
# Line 1 is a she-bang that indicates that this is a Bash script.

#PBS -N fastqc.$PBS_JOBID                 #  Line 3-7 inform the scheduler about the resources required by this job:
#PBS -l nodes=1:ppn=all                                    # singe node (nodes=1) all core (ppn=all)
#PBS -o stdout.$PBS_JOBNAME.$PBS_JOBID                     # redirect sterr stdout to separate files 
#PBS -e stderr.$PBS_JOBNAME.$PBS_JOBID          
#PBS -l walltime=01:00:00                                  # run for at most 2 minutes (walltime=00:02:00 max is 72hours)
#PBS -m abe                                                # send mail when job (a)bort (b)egin (e)nd
#PBS -M <youremailaddresshere>                             # specify your email address here


#Request software

ml FastQC/0.11.9-Java-11
ml ml MultiQC/1.14-foss-2022

#Stage in data: Go to your current working directory and make sure both your data and scrit is there
cd $PBS_O_WORKDIR

#Software commands
fastqc *.fq.gz -o . &&	# run fastqc on all present fq.gz files
multiqc .								# run multiqc on all fastqc output && in previous command prevents from starting multiqc early
