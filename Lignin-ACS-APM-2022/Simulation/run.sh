#!/bin/bash
#SBATCH -C v100
#SBATCH -A user
#SBATCH --array=0-9%1
#SBATCH --gres=gpu:2
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --time=4:0:0 
#SBATCH --mail-type=ALL
#SBATCH --mail-user=user-email

cd $SLURM_SUBMIT_DIR
#modules are loaded automatically by the NAMD module.

module load NAMD/3.0a9-gpu
NUM=`ls run*dcd | wc -l`
PRINTNUM=`printf "%03d" $NUM`
srun namd3 ++ppn 2 +devices 0,1 run.namd > run-${PRINTNUM}.log
