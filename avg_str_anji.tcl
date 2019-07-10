# TCL VMD Script to measure average strucure from given frames
# Usage  : avg_str <molid> <atom selection>
#
# Example : avg_str 0 "protein"
# Example : avg_str 1 "backbone"
#
proc avg_str {id sel} {
set nframes [molinfo $id get numframes]
puts " No. of frames : $nframes"
#--------------------#
# ----------Atom selection
set sel1 [atomselect $id $sel]
set avgpos [measure avpos $sel1]
# Moves the selected atoms to the average positions computed
 $sel1 set {x y z} $avgpos 
# Write into pdb
$sel1 writepdb Avg-Pos-$id.pdb
menu graphics on
#mol delrep replica_number Mol_number
mol delrep 0 $id 
mol new Avg-Pos-$id.pdb
mol addrep top
mol representation CPK
#mol default
mol selection [atomselect top $sel]
#mol drawframes top 0 1
#mol modcolor 0 top 1
puts "\n ********** KAPAKAYALA ANJI BABU **********$ "
}








