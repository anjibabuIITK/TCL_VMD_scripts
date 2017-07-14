#TCL VMD SCRIPT TO CALUCULATE ANGLE BETWEEN ANY GIVEN THREE ATOMS
#                        (METHOD_1)
#
# Authour : ANJI BABU KAPAKAYALA
#           IIT KANPUR, INDIA.
#
# OUTPUT  : angle.dat  ;Contains frame no v/s angle in deg.
#           angle-details.dat ;contains detailed information.
#
set outfile [open "angle.dat" w]
set outfile2 [open "angle-details.dat" w]
set n [molinfo top get numframes] 
puts $outfile2 "Total Frames found : $n\n=============================\n"
set sum 0
global M_PI
#puts "PI : $M_PI"
for {set i 0} {$i <= $n} {incr i} {
    set A [atomselect top "serial 3415" frame $i ]
    set B [atomselect top "serial 3412" frame $i ]
    set C [atomselect top "serial 3418" frame $i ]
        set A_pos [ lindex [$A get "x y z" ] 0 ]
        set B_pos [ lindex [$B get "x y z" ] 0 ]
        set C_pos [ lindex [$C get "x y z" ] 0 ]
            puts $outfile2 "Frame : $i\n=======================\n"
            puts $outfile2 "Coordinates of Given Atoms :\n"
            puts $outfile2 "A position: $A_pos "
            puts $outfile2 "B position: $B_pos "
            puts $outfile2 "C position: $C_pos \n"
   $A delete
   $B delete
   $C delete
    set v1 [vecsub $B_pos $A_pos ]
    set v2 [vecsub $C_pos $B_pos ]
           puts $outfile2 "Setoup Vectors V1 and V2 :\n"
           puts $outfile2 " Vector1:   $v1"
           puts $outfile2 " Vector2    $v2\n"
    set dot_prod [vecdot $v1 $v2 ]
           puts $outfile2  "Dot Product : $dot_prod "
    set mod_v1 [veclength $v1]
    set mod_v2 [veclength $v2]
          puts $outfile2 "mod V1: $mod_v1"
          puts $outfile2 "mod V2: $mod_v2\n"
    set cos_theta [expr $dot_prod/$mod_v1*$mod_v2]
          puts $outfile2  "COS(theta) : $cos_theta\n"
    set theta [expr acos($cos_theta)*180.0/$M_PI]
         puts $outfile2 ""
         puts $outfile2 " Angle Bwn given three atoms ; $theta "
         set sum [expr $sum + $theta]
     puts $outfile "$i  $theta "
}
   set Avg_angle [expr $sum/$n]
        puts "Avg Angle : $Avg_angle"
       puts $outfile "" 
       puts $outfile "Avg Angle : $Avg_angle"
       puts $outfile2 "\n=======================================\nAvg Angle : $Avg_angle\n==============================\n"
close $outfile
close $outfile2
#==================================================================#
#               Written By ANJI BABU KAPAKAYALA                    #
#==================================================================#
