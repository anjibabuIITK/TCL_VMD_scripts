#TCL VMD Script to get distance between two Given Atoms
#
#Authour : KAPAKAYALA ANJI BABU
#          IIT KANPUR, INDIA.
# OUTPUT : distance.dat ; contains frame number v/s distance per frame
#
set outfile [open distance.dat w ]
set n [molinfo top get numframes] 
#set form {%6.2 g}
set sum 0
 for  {set i 0}  {$i <= $n}  {incr i}  {
       set atom1 [atomselect top "resid 28 and name CA" frame $i ] 
       set atom1_posi [ lindex [ $atom1 get "x y z"] 0 ] 
       puts "Atom1 Positions : $atom1_posi"
       puts ""
       $atom1 delete
       set atom2 [atomselect top "resid 176 and name CA" frame $i ] 
       set atom2_posi [ lindex [ $atom2 get "x y z"]  0 ]
       puts "Atom2 Positions : $atom2_posi"
       puts ""
       $atom2 delete 
       set dist [ vecdist $atom1_posi $atom2_posi ] 
       puts $outfile  "$i\t  $dist"
       puts  "Frame : $i\t Distance : $dist " 
       puts "================================================="
      set sum [expr $sum + $dist]
    }
#   puts "Total Sum : $sum"
   set Avg_dist [expr $sum/$n]
   puts ""
   puts $outfile "Avg. Distance : $Avg_dist "
   puts  "Avg. Distance : $Avg_dist "
#   puts  [ format $form "$Avg_dist"  ]
   puts ""
   puts "================================================="
   puts "   Written By ANJI BABU KAPAKAYALA              #"
   puts "================================================="
   close $outfile
#quit
#==================================#
# Written by ANJI BABU KAPKAYALA
#==================================#
