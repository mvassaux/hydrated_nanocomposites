#!/bin/bash

#SBATCH --job-name=Eq
#SBATCH --nodes=6
#SBATCH --ntasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --time=2-0

#SBATCH --account=e723-werner2
#SBATCH --partition=standard
#SBATCH --qos=long

module load lammps/13Feb2024

export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK
export SLURM_CPU_FREQ_REQ=2250000

start_time="$(date -u +%s.%n)"

srun --distribution=block:block --hint=nomultithread lmp -partition 2x384 -i input.dat

end_time="$(date -u +%s.%n)"
elapsed="$(bc <<<"$end_time-$start_time")"
echo -e "\n\nTotal Executing Time = $elapsed seconds\n"
