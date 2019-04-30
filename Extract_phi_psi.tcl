# VMD TCL script to print Frame number and Phi Psi values
#
#  Authour:  ANJI BABU KAPAKAYALA
#	   IIT KAnpur, India
#
#  USAGE: source Extract_phi_psi.tcl    (in tk console of vmd)
#
#	OUTPUT FILES: Q.dat, C5-C5.dat, CL-CL.dat
#			Minima_Q.pdb, Minima_C5-C5.pdb, Minima_CL-CL.pdb  
#
# Procedure to remove repeated numbers
#-------------------------------------------#
proc list_unique {list} {
    array set included_arr [list]
    set unique_list [list]
    foreach item $list {
        if { ![info exists included_arr($item)] } {
            set included_arr($item) ""
            lappend unique_list $item
        }
    }
    unset included_arr
    return $unique_list
}
#-------------------------------------------#
set sel1 "backbone"
set sel [atomselect top $sel1]
set nf [molinfo top get numframes ]
set nn [llength [$sel get {phi psi} ]]
set N [$sel get {resname}]
#-------------------------------------------#
# Opening Output Files
set file1 [open "Q.dat" w ]
set file2 [open "C5-C5.dat" w ]
set file3 [open "CL-CL.dat" w ]
set pdb1 [open "Minima_Q.pdb" w]
set pdb2 [open "Minima_C5-C5.pdb" w]
set pdb3 [open "Minima_CL-CL.pdb" w]
#-------------------------------------------#

#nputs "$N"
#----------PRINTING GIVEN INPUT DATA------_#
puts " \n Total frames found : $nf"
puts " Atom selection : $sel1\n "
puts $file1 " \n Total frames found : $nf"
puts $file1 " Atom selection : $sel1\n "
puts $file2 " \n Total frames found : $nf"
puts $file2 " Atom selection : $sel1\n "
puts $file3 " \n Total frames found : $nf"
puts $file3 " Atom selection : $sel1\n "
#-------------------------------------------#
#  Cycle over Trajectory
for {set i 0} {$i <= $nf} { incr i } {
set sel [ atomselect top "backbone" frame $i]
#------------------------------------#
# Extracting Phi
set list1  [$sel get { phi }] 
set unique [list_unique $list1]
#puts "$unique"
set phi1 [lindex $unique 0]
set phi2 [lindex $unique 1]
if {$phi2 eq ""} {
#puts "phi2 is empty"
set phi2 $phi1
	}
#------------------------------------#
# Extracting Psi
set list2  [$sel get { psi }] 
set unique2 [list_unique $list2]
#puts "$unique2"
set psi1 [lindex $unique2 0]
set psi2 [lindex $unique2 1]
if {$psi2 eq ""} {
#puts "psi2 is empty"
set psi2 $psi1
	}
#------------------------------------#
# Ref for the Ranges
# https://www.google.com/url?q=https://pubs.acs.org/doi/pdf/10.1021/jp013952f&sa=D&source=hangouts&ust=1556714782711000&usg=AFQjCNGCli-MGWQ23gtcru87RLe9T0m_ew
#puts "Frame: $i  Phi1: $phi1   Phi2: $phi2 Psi1: $psi1   Psi2: $psi2" 
#------------------------------------#
# Searching for Minima Q
	if {($phi1 >= -92.00 && $phi1 <= -61.00) && ($phi2 >= -92.00 && $phi2 <= -61.00)} {
	   if {($psi1 >= -41.00 && $psi1 <= -5.00) && ($psi2 >= -41.00 && $psi2 <= -5.00)} {

puts $file1 [format " Frame: %6d  Phi1: %8.5f  Phi2: %8.5f Psi1: %8.5f  Psi2: %8.5f " $i  $phi1  $phi2  $psi1  $psi2]
puts "minima-Q: Frame: $i  Phi1: $phi1   Phi2: $phi2 Psi1: $psi1   Psi2: $psi2 " 
[atomselect top "all" frame $i] writepdb Q$i.pdb
exec cat Q$i.pdb >> Minima_Q.pdb
exec rm Q$i.pdb
}
}
#------------------------------------#
# Searching for C5-C5 Configuration
	if {($phi1 >= -168.00 && $phi1 <= -156.00) && ($phi2 >= -168.00 && $phi2 <= -156.00)} {
	   if {($psi1 >= 159.00 && $psi1 <= 171.00) && ($psi2 >= 159.00 && $psi2 <= 171.00)} {

puts $file2 [format " Frame: %6d  Phi1: %8.5f  Phi2: %8.5f Psi1: %8.5f  Psi2: %8.5f " $i  $phi1  $phi2  $psi1  $psi2]
puts "C5-C5: Frame: $i  Phi1: $phi1   Phi2: $phi2 Psi1: $psi1   Psi2: $psi2" 
[atomselect top "all" frame $i] writepdb B$i.pdb
exec cat B$i.pdb >> Minima_C5-C5.pdb
exec rm B$i.pdb
}
}
#------------------------------------#
# Searching for CL-CL Configuration
	if {($phi1 >= 63.00 && $phi1 <= 70.00) && ($phi2 >= 63.00 && $phi2 <= 70.00)} {
	   if {($psi1 >= 19.00 && $psi1 <= 41.00) && ($psi2 >= 19.00 && $psi2 <= 41.00)} {

puts $file3 [format " Frame: %6d  Phi1: %8.5f  Phi2: %8.5f Psi1: %8.5f  Psi2: %8.5f " $i  $phi1  $phi2  $psi1  $psi2]
puts "CL-CL: Frame: $i  Phi1: $phi1   Phi2: $phi2 Psi1: $psi1   Psi2: $psi2" 
[atomselect top "all" frame $i] writepdb A$i.pdb
exec cat A$i.pdb >> Minima_CL-CL.pdb
exec rm A$i.pdb
}
}
#------------------------------------#
}
#------------------------------------#
# Closing files
close $file1
close $file2
close $file3
close $pdb1
close $pdb2
close $pdb3
puts " Corresponding Structures are stored as PDB files."
#---------------------------------------------------------------------------#
puts "\n\n @$		Written By ANJI BABU KAPAKAYALA		$@\n\n"
#---------------------------------------------------------------------------#
