for lignin in lignin1 lignin2
do
	for solvent in water ethanol water+ethanol
	do
			echo "$lignin $solvent $surf"
			dirname=${solvent}_${lignin}_sds
			echo $dirname
			mkdir -p $dirname
			cd $dirname
			ln -s ../eq.namd .
			ln -s ../run.namd .
			ln -s ../run.sh .
			ln -s ../../Build/${solvent}${lignin}sds.psf system.psf
			ln -s ../../Build/${solvent}${lignin}sds.pdb system.pdb
			cd ..
			dirname=${solvent}_${lignin}
			mkdir -p $dirname
			cd $dirname
			ln -s ../eq.namd .
			ln -s ../run.namd .
			ln -s ../run.sh .
			ln -s ../../Build/${solvent}${lignin}.psf system.psf
			ln -s ../../Build/${solvent}${lignin}.pdb system.pdb
			cd ..
	done
done
