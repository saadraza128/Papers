#!/bin/bash
for lignin in lignin1 lignin2
do
	for solvent in water ethanol water+ethanol
	do
			dirname=${solvent}_${lignin}_sds
			cd $dirname
			sbatch run.sh
			cd ..
			dirname=${solvent}_${lignin}
			cd $dirname
			sbatch run.sh
			cd ..
	done
done
