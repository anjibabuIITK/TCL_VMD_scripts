# TCL VMD Script for Calculating Distance Beteen Two Given Atoms (METHOD 2 )
#
# Authuour : ANJI BABU KAPAKAYALA
#            IIT KANPUR, INDIA.
# 
# OUTPUT   : Distance.dat 
#
#mol new file.gro type gro first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor all
#mol addfile file.xtc type xtc first 0 last -1 step 20 filebonds 1 autobonds 1 waitfor all
set outfile [open "Distance.dat" w]
set n [molinfo top get numframes] 
set sum 0
for {set i 0} {$i <= $n} {incr i} {
set atom1 [atomselect top "serial 2557" frame $i] 
set atom2 [atomselect top "serial 446" frame $i] 
set com1 [measure center $atom1 weight mass]
set com2 [measure center $atom2 weight mass]
#set nextdata($i.r) [veclength [vecsub $com3 $com4]]
set dis [veclength [vecsub $com1 $com2]]
set sum [expr $sum + $dis]
#puts $outfile "$i $nextdata($i.r)"
puts  $outfile "$i  $dis"
}
#puts "Sum : $sum"
set Avg_dis [expr $sum/$n]
puts $outfile "Avg Distance : $Avg_dis "
puts  "Avg Distance : $Avg_dis "
$atom1 delete
$atom2 delete
close $outfile 
#quit 
#puts "Completed Sucessfully"
#=============================================#
#   Written By ANJI BABU KAPAKAYALA           #
#=============================================#
#USAGE : vmd -e script.tcl
# Though VMD without launching the GUI:
# vmd -dispdev text -e scripttcl 
#=============================================#

