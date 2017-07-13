#TCL VMD script to calculate Avg No. of HBonds for given Acceptor and Donor groups in protein 
#
#Authour : KAPAKAYALA ANJI BABU
#          IIT KANPUR, INDIA.
#
#USAGE   : Open VMD/Extensions - Tk console then execute script as " source script.tcl"
#
#OUTPUT Files ::   hbonds-details_new.dat  ; which contains details of all given Donor & Acceptor atoms.
#                  hbonds.dat              ; Which contains Frame vs No.of Hbonds (You can plot this data as Frames v/s No. of Hbonds)
#
set outfile [open "hbonds-details.dat" w]
set hbfile [open "hbonds.dat" w]
set n [ molinfo top get numframes]
set sum 0
for {set i 0} {$i <= $n} {incr i} {
set D [atomselect top "protein and name N" frame $i] 
set A [atomselect top "protein and name O" frame $i]
set D_list [$D get {resname type serial }]
set A_list [$A get {resname type serial }]
set lists [measure hbonds 3.5 30 $D $A]
set atoms [lindex $lists 0]
set Num [llength $atoms]  
#---------Writing OUTPUT----------------------#
puts $outfile  "========================================"
puts $outfile  "Frame :: $i "
puts $outfile  "DONARS_list ::\n$D_list"
puts $outfile  ""
puts $outfile  "Acceptors_list ::\n$A_list"
puts $outfile  ""
#puts "Hbonds List :: $lists"
#set HBnum [llength $lists ]
puts ""
#puts "No. of Hbonds :: $HBnum"
puts $outfile "HB Atoms:: $atoms"
puts $outfile ""
puts $outfile "No. of Hbonds::  $Num"
puts $hbfile "$i   $Num"
puts  "$i  :: No. of Hbonds =  $Num"
#------------------Calculating Avg HBonds--------#
set sum [expr $sum + $Num ]
#puts "Sum :: $sum"
}
set Hbavg [expr $sum/$i]
puts $hbfile "Ang Hbonds :: $Hbavg"
puts "===================================="
puts "Ang Hbonds :: $Hbavg"
puts "===================================="
puts " hbonds.dat        :: Contains Frames v/s No. Of Hbonds"
puts ""
puts "hbonds-details.dat :: Details of Acceptor & Donor & Hbonds residues "
$D delete
$A delete
close $outfile
close $hbfile
#lsort -unique [$sel get resname]
#==========================================================#
#       Written By ANJI BABU KAPAKAYALA                    #
#==========================================================#
