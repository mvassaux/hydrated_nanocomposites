#!/bin/bash

#SBATCH --job-name=E-S-01.0
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --time=1-0

#SBATCH --account=e723-werner2
#SBATCH --partition=standard
#SBATCH --qos=standard

module load lammps/13Feb2024

export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK
export SLURM_CPU_FREQ_REQ=2250000

srun --distribution=block:block --hint=nomultithread lmp -partition 1x384 -i input-pt1.dat
