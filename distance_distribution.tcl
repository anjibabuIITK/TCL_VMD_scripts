#TCL VMD Script to get distance between two Given Atoms
#
#Authour : KAPAKAYALA ANJI BABU
#          IIT KANPUR, INDIA.
# OUTPUT : distance.dat ; contains frame number v/s distance per frame
#
set outfile [open distance.dat w ]
set hist_file [open histogram.dat w]
set n [molinfo top get numframes] 
#set form {%6.2 g}
set nbin 101
puts " Nbins = 101 "
set sum 0
 for  {set i 0}  {$i <= $n}  {incr i}  {
       set atom1 [atomselect top "resid 28 and name CA" frame $i ] 
       set atom1_posi [ lindex [ $atom1 get "x y z"] 0 ] 
#       puts "Atom1 Positions : $atom1_posi"
#       puts ""
       $atom1 delete
       set atom2 [atomselect top "resid 176 and name CA" frame $i ] 
       set atom2_posi [ lindex [ $atom2 get "x y z"]  0 ]
#       puts "Atom2 Positions : $atom2_posi"
#       puts ""
       $atom2 delete 
       set dist [ vecdist $atom1_posi $atom2_posi ] 
      puts $outfile  "$i\t  $dist"
 #      puts  "Frame : $i\t Distance : $dist " 
#       puts "================================================="
      set sum [expr $sum + $dist]
# Storing in distance array
      set distance($i.r) $dist
    }
#
set dist_min $distance(0.r)
set dist_max $distance(0.r)
#
for {set i 0} {$i < $n} {incr i} {
#if {$distance($i.r) < $nbin} {
#set dist_tmp $distance($i.r)
#}
#if {$dist_tmp < $dist_min} {set dist_min $dist_tmp}
#if {$dist_tmp > $dist_max} {set dist_max $dist_tmp}
if {$distance($i.r) < $dist_min } {set dist_min $distance($i.r)}
if {$distance($i.r) > $dist_max } {set dist_max $distance($i.r)}
}
puts " Minimum = $dist_min "
puts " Maximum = $dist_max "
#
# Calculating Bin_width
set bin_width [expr ($dist_max - $dist_min) / ($nbin -1)]   
puts " Bin Width = $bin_width"
#
# Initilaization
for {set k 0} {$k < $nbin} {incr k} {
set distribution($k) 0
}
#
for {set i 0} {$i < $n} {incr i} {
set k [expr int(($distance($i.r) - $dist_min) / $bin_width)]
incr distribution($k)
}
#
for {set k 0} {$k < $nbin} {incr k} {
#bin = distance - dist_min / bin_width 
# distance = bin*bin_width + dist_min
puts $hist_file " [expr $dist_min+$k*$bin_width ]  $distribution($k) "
puts  " [expr $dist_min+$k*$bin_width ]  $distribution($k) "
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
  close $hist_file
#quit
#==================================#
# Written by ANJI BABU KAPKAYALA
#==================================#
