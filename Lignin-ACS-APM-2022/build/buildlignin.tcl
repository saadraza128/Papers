#Optimal arrangement for lignin 2 is [78 69 15 56 11  8 87 97] 4.403816702232033 2910.7821876108646
#Optimal arrangement for lignin 1 is [ 3 62 70 77 45 47 39 16] 1.3972256446641598 4202.379870951176

package require solvate
package require pbctools
package require topotools
package require autoionize
mol load psf sds.psf pdb sds.pdb
set sdssel [atomselect top "all"]
set sdsmass [vecsum [$sdssel get mass]]
foreach lignin [list lignin1 lignin2] birchids [list [list 3 62 70 77 45 47 39 16] [list 78 69 15 56 11  8 87 97]] {
	set molidlist [list ]
	foreach birchid $birchids {
		lappend molidlist [mol new LigninStructures/Birch-L$birchid.js]
	}
	set mol [::TopoTools::mergemols $molidlist]
	set sel [atomselect $mol "all"]
	set ligninmass [vecsum [$sel get mass]]
	set numsds [expr {int($ligninmass / $sdsmass)}]
	puts $numsds
	set scale 30
	for { set frag 0 } { $frag < 8 } { incr frag } {
		set fsel [atomselect $mol "fragment $frag"]
		set vector [list [expr { -1 + 2 * ($frag % 2)}] [expr { -1 + 2 * (($frag % 4)/ 2)}] [expr { -1 + 2 * ($frag / 4)}]]
		$fsel moveby [vecscale $scale $vector]
	}
	animate write psf ${lignin}.psf
	animate write pdb ${lignin}.pdb
	set x [expr {2*$scale}]
	set y [expr {$x / 3.0}]
	$sel moveby [list $x $x $x]
	pbc set [vecscale 3.8 [list $scale $scale $scale]]
	animate write gro ${lignin}forsds.gro
	set newmollist [list $mol]
	for { set i 0 } { $i < $numsds } { incr i } {
		lappend newmollist 0
	}
	set sdsmol [::TopoTools::mergemols $newmollist]
	animate write psf ${lignin}sds.psf
	exec  -ignorestderr gmx insert-molecules -f ${lignin}forsds.gro -ci sds.pdb -o ${lignin}sds.pdb -nmol $numsds -try 1000
	mol load psf ${lignin}sds.psf pdb ${lignin}sds.pdb
	set sel [atomselect top "all"]
	$sel moveby [list -$x -$x -$x]
	$sel writepdb ${lignin}sds.pdb
	
	foreach surf [list "" sds] {
		solvate $lignin$surf.psf $lignin$surf.pdb -minmax [list [list -$x -$x -$x] [list $x $x $x]] -o water${lignin}${surf}
		set watsel [atomselect top "water"]
		set ligsel [atomselect top "not water"]
		puts [expr {[vecsum [$watsel get mass]] / [vecsum [$ligsel get mass]]}]
		solvate $lignin$surf.psf $lignin$surf.pdb -s ET -minmax [list [list -$x -$x -$x] [list $x $x $x]] -o ethanol${lignin}${surf} -spdb /tank/BuildSolventBoxes/eqsolv/etoh.pdb -spsf /tank/BuildSolventBoxes/eqsolv/etoh.psf -stop /home/josh/toppar_c36_jul20/top_all36_cgenff.rtf -ks "name C1" -ws 45.438
		solvate $lignin$surf.psf $lignin$surf.pdb -s ET -minmax [list [list -$x -$x -$y] [list $x $x $y]] -o tmp -spdb /tank/BuildSolventBoxes/eqsolv/etoh.pdb -spsf /tank/BuildSolventBoxes/eqsolv/etoh.psf -stop /home/josh/toppar_c36_jul20/top_all36_cgenff.rtf -ks "name C1" -ws 45.438
		solvate tmp.psf tmp.pdb -minmax [list [list -$x -$x -$x] [list $x $x -$y]] -o tmp2
		solvate tmp2.psf tmp2.pdb -s WA -minmax [list [list -$x -$x $y] [list $x $x $x]] -o water+ethanol${lignin}${surf}
		autoionize -psf water+ethanol${lignin}${surf}.psf -pdb water+ethanol${lignin}${surf}.pdb -neutralize -o water+ethanol${lignin}${surf}
		autoionize -psf water${lignin}${surf}.psf -pdb water${lignin}${surf}.pdb -neutralize -o water${lignin}${surf}
		autoionize -psf ethanol${lignin}${surf}.psf -pdb ethanol${lignin}${surf}.pdb -neutralize -o ethanol${lignin}${surf}
	}
}

exit