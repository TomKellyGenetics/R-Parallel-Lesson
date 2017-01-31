#!/bin/bash
#SBATCH -A uoo00010
#SBATCH -J array_job_name
#SBATCH --array="${@:2}" #comma or dash separated list e.g., 1-4,6,8,10
#SBATCH --mail-type=ALL
#SBATCH --mail-user=kelsi602@student.otago.ac.nz
#SBATCH --ntasks $1  #number of cores
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mem-per-cpu=2G
module load R/3.3.0-intel-2015a #load R

echo "arguments passed to slurm"
echo $@
echo "1st argument"
echo $1 "cores"
echo "remaining arguments"
echo "$2" "samples"

srun Rscript loop_script_Rstudio_generic.R "$@"