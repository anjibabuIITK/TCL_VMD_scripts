#TCL VMD SCRIPT TO GET ANGLE B/W THREE GIVEN ATOMS (METHOD 2)
#
#Authour : ANJI BABU KAPAKAYALA
#          IIT KANPUR,INDIA.
#
set outfile [open "angle_V2.dat" w]
set outfile2 [open "angle_V2-details.dat" w]
set n [molinfo top get numframes]
     puts $outfile2  "Total Frames found : $n "
     puts $outfile2 ""
set sum 0
#get pi=3.1415926535
global M_PI
    for {set i 0} {$i <= $n} {incr i} {
        set A [atomselect top "serial 3415" frame $i ]
        set B [atomselect top "serial 3412" frame $i ]
        set C [atomselect top "serial 3418" frame $i ]
            set A_pos [lindex [$A get "x y z" ] 0]
            set B_pos [lindex [$B get "x y z" ] 0]
            set C_pos [lindex [$C get "x y z" ] 0]
                 puts $outfile2 "Frame : $i\n========================= "
                 puts $outfile2 "Coordinates of Given Atoms "
                 puts $outfile2 "Atom1 Posions : $A_pos "
                 puts $outfile2 "Atom2 Posions : $B_pos "
                 puts $outfile2 "Atom3 Posions : $C_pos "
     $A delete;$B delete;$C delete 
#split coordinates
    set a(x) [lindex $A_pos 0];set a(y) [lindex $A_pos 1];set a(z) [lindex $A_pos 2];
    set b(x) [lindex $B_pos 0];set b(y) [lindex $B_pos 1];set b(z) [lindex $B_pos 2];
    set c(x) [lindex $C_pos 0];set c(y) [lindex $C_pos 1];set c(z) [lindex $C_pos 2];
#setup vectors ab and bc
    set ab(x) [expr $b(x)-$a(x)];set ab(y) [expr $b(y)-$a(y)];set ab(z) [expr $b(z)-$a(z)];
    set bc(x) [expr $c(x)-$b(x)];set bc(y) [expr $c(y)-$b(y)];set bc(z) [expr $c(z)-$b(z)];
#checking
      puts $outfile2 ""
      puts $outfile2 "Splitting Coordinates : "
      puts $outfile2 "a(x) : $a(x)\na(y) :$a(y)\na(z) : $a(z)"
      puts $outfile2 ""
      puts $outfile2 "b(x) : $b(x)\nb(y) :$b(y)\nb(z) : $b(z)"
      puts $outfile2  ""
      puts $outfile2 "c(x) : $c(x)\nc(y) :$c(y)\nc(z) : $c(z)"
      puts $outfile2 ""
      puts $outfile2 " Setup Vectors : "  
      puts $outfile2 "ab(x) : $ab(x)\nab(y) :$ab(y)\nab(z) : $ab(z)"
      puts $outfile2 ""
      puts $outfile2 "bc(x) : $bc(x)\nbc(y) :$bc(y)\nbc(z) : $bc(z)"
      puts $outfile2 ""
#Dot product of vectors
     set dot_prod [expr $ab(x)*$bc(x)+$ab(y)*$bc(y)+$ab(z)*$bc(z)]
     puts $outfile2 "Dot product : $dot_prod"
     puts $outfile2 ""
#Vector Length MOD(V) :
#  mod_ab = sqrt (x^2 + y^2 + z^2)
     set mod_ab [expr sqrt(pow($ab(x),2)+pow($ab(y),2)+pow($ab(z),2))]
     set mod_bc [expr sqrt(pow($bc(x),2)+pow($bc(y),2)+pow($bc(z),2))]
     puts $outfile2 "Mod ab : $mod_ab "
     puts $outfile2 "Mod bc : $mod_bc "
     puts $outfile2 ""
#Compute Cos_theta
   set cos_theta [expr $dot_prod/$mod_ab*$mod_bc ]
   set theta [expr acos($cos_theta)] 
       puts $outfile2  "COS_THETA : $cos_theta"
       puts $outfile2 ""
       puts $outfile2  "THETA (radians) : $theta"
       puts $outfile2 ""
# Convert theta from Radian to Degrees 
   set angle [expr $theta*180.0/$M_PI]
       puts $outfile2  "Frame : $i   Angle : $angle "
       puts $outfile " $i  $angle "
       puts $outfile2  ""
#Sum all the angles  
 set sum [expr $sum+$angle]
    }
 #Get Avg Angle by deviding Total frames
 set Avg_angle [expr $sum/$n]
     puts $outfile2 "============================================="
     puts $outfile2 "Average angle : $Avg_angle"
     puts $outfile2 "============================================="
     puts $outfile ""
     puts $outfile "Average angle : $Avg_angle"
     puts  "Average angle of trajectory : $Avg_angle"
close $outfile
close $outfile2
#=============================================================================#
#         Written By ANJI BABU KAPAKAYALA                                     #
#=============================================================================#
