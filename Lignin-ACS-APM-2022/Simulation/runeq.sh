#!/bin/bash
for lignin in lignin1 lignin2
do
	for solvent in water ethanol water+ethanol
	do
			dirname=${solvent}_${lignin}_sds
			cd $dirname
			namd3 +p24 eq.namd | tee eq.log
			cd ..
			dirname=${solvent}_${lignin}
			cd $dirname
			namd3 +p24 eq.namd | tee eq.log
			cd ..
	done
done