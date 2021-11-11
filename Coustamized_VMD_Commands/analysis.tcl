# TCL VMD Script for analyse trajectory
#
# VERSION  : analysis_script_V 1.0
#
# Authour  :  ANJI BABU KAPAKAYLA
#             IIT KANPUR, INDIA.
#             ( anjibabu480@gmail.com)
#
# SOURCE analysis.tcl in VMD Tk console
#
#  Following analysis can be done by using this script :
#
#  Alignment
#  RMSD
#  Distance btw two atoms
#  Measure  Angle
#  Measure Dihedral
#  Contact map
#  clustering analysis
#  Print  Interactions within given cutoff
#  Print No. of watrs within given cutoff
#  Print No. of HBonds within given cutoff
#  Print residue names and resid for given sel 
#  Molecule details ( No of frames, No of atoms, No of waters, Box size
#  set pbc_box and off Pbc_box
#  save_pdb
#  save_image
#  sasa
#  save_coordinates
#  bgcolor
#  --help : which gives details of command
#  my_commands show : shows avalilable commands
#
#====================================================
#  Future updates:
#  save_view    : saves the visivilization of current vmd 
#  save_movie   : creates a movie for given frames
#  delete_frame : Deletes the frames for given intial and final frames
#  Histogram : probability distribution for any selected data
#  Radial distribution plot : 
# PBC wrapping
# Ramachandran plot
# HB plot
#====================================================
#
#
# my_commands   : Shows all available commands
# USAGE&example : my_commands show
#
# --help  : Gives details of any mentioned command
#  USAGE  : --help command
# example : --help distance
# example2: --help angle
#
# save_pdb : Writes pdb file for given options
# USAGE    : save_pdb atomselection start_frame end_frame stride molid filename
#
# EXAMPLE  : save_pdb "protein" 5 100 5 top file.pdb
# Above example , It will write file.pdb for "protein" from frame 5 to 100 by skipping every 5 frames.
#
# Align    : align molid1 molid2
#example   : align 0 1
#
# RMSD     : Measures Avg.RMSD & std for given selections
# USAGE    : rmsd Atomselection molid1  molid2
# example  : rmsd "backbone" top  1
# example  : rmsd "protein" top top
#
#IF both the molids are same , RMSD will be calculated by taking zeroth frame as reference
#
# Distance : Measures Distance, Avg Distance & std for any given 2 atoms
# USAGE    : distance sel1 sel2 <initial-frame> <end-frame> <-show_plot>
# example  : distance "serial 3418" "serial 3415" 
# example  : distance "serial 3418" "serial 3415" 100 2000
# example  : distance "serial 3418" "serial 3415" -show_plot
# example  : distance "serial 3418" "serial 3415" 10 1000 -show_plot
# OUTPUT   : DISTANCE.xvg and dist.png
#
# Angle    : Measures Avg. angle & std  for any given 3 atoms
# USAGE    : angle sel1 sel2 sel3
# example  : angle "serial 3418" "serial 3415" "serial 3395"
# OUTPUT   : ANGLE.dat
#
# Dihedral : Measures Avg Dihedral angle & std  for any given 4 atoms 
# USAGE    : dihedral sel1 sel2 sel3 sel4
# example  : dihedral "serial 3418" "serial 3415" "serial 3412" "serial 3395"
# example2 : dihedral "index 3417" "index 3414" "index 3411" "index 3394"
# OUTPUT   : DIHEDRAL.dat
#
# show_residues : Prints RESID and corresponding RESNAME for given selection and for given frames
# USAGE    : show_residues sel molid <initial frame>  <final frame>
# example  : show_residues "resid 170 to 180" 0 0 5
# example2 : show_residues "(not resname WAT) and within 3 of resid 235" 0 5 10
# example3 : show_residues "protein and hydrophobic " 0 1 0
# OUTPUT   : RESNAMES.dat
#
# details  : Prints required molecular details for given molid
# USAGE    : details molid
# example  : details 0
#
# count_waters : Prints Avg. No of waters present around given selection
# USAGE    : count_waters sel molid start_frame end_frame
# example  : count_waters "within 5 of resid 235" 0 5 10
# OUTPUT   : NO-OF-WATERS.dat
#
# pbc_box   : Sets or off or show the size of PBC BOX 
# USAGE     : pbc_box choice 
# Arguments : on off size 
# example   : pbc_box on
# It will on the pbc box for current top molecule\n
# example2  : pbc_box off 
# It will off the PBC box
# example 3 : pbc_box size 
# It will show the size of BOX (values)
#
# show_interactions : Prints Interactions between given two selections within given cutoff
# USAGE             : show_interactions sel1 sel2 cutoff inf nf 
# example           : show_interactions "protein" "resid 235" 3.0 5 10
#    sel1           : Any given selction
#    sel2           : Any given selction
#    cutoff         : distance cutoff
#   inf & nf        : Initial frame & Final framme
#   OUTPUT          : stores all the information in INTERACTIONS.dat file
#
#
# contact_map    :  Measures all the contacts between given two selections and prints 1 if contact below cutoff , 0 (zero) otherwise
# USAGE          : contact_map " sel1"  "sel2"  cutoff startframe endframe
# Example        : contact_map {"resid 1 to 50 and name CA" "resid 51 to 100 and name CA" 6.0 0 10
# OUTPUT         : stores all data in CONTACT_MAP.dat file
# 
# PLOTTING DATA : gnuplot >>  splot "contact_map.dat" u 1:2:3 w p " 
#                 gnuplot >>  set view 0,0,1
#                 gnuplot >>  replot
#
#
#
# count_hbonds     : Measures No of HBonds between given two donor and acceptor selections within given cutoff and angle_cutoff
# USAGE            : count_hbonds Donor_sel1  Acceptor_sel2  distance_cutoff angle_cutoff
# EXAMPLE          : count_hbonds "protein and name N" "protein and name O" 3.0 30
# OUTPUT           : data will be store in HBONDS_COUNT.dat, Which contains Frame vs No.of Hbonds (You can plot this data as Frames v/s No. of Hbonds)
#
#
# show_hbonds      : Prints the HBonds between given DONOR and ACCEPTOR selections within given distance & angle cutoff.
# USAGE            : show_hbonds  Donor_sel1 Acceptor_sel2 distance_cutoff angle_cutoff <initial frame>  <end frame> 
# EXAMPLE          : show_hbonds "protein and name N" "protein and name O" 3.0 30 5 10
# OUTPUT           : data will be store in HBONDS.dat.
#
#
# HB_occupancy   :  Prints the HBONDS occupancy for given selctions for selected frames
# USAGE          : HB_occupancy sel1 sel2 distance_cutoff angle_cutoff start_frame end_frame
# EXAMPLE        : HB_occupancy "protein" "resid 235" 3.0 30 0 20
# ARGUMENTS      :
#  SELECTION1      : ANY DONOR SELECTION
#  SELECTION2      : ANY ACCEPTOR SELECTION
#  DISTANCE_CUTOFF : Distance cutoff to measure HBonds
#  ANGLEE_CUTOFF   : Angle cutoff to measure HBonds
#  START_FRAME     : Starting Frame Number
#  END_FRAME       : End Frame Number
#
#
# save_image  :
# UASAGE      :save_image molid filename
# EXAMPLE     : save_image top my_image
# ( extension of file not required )
#
# save_movie  : RENDER MOVIE IN  GIF FORMAT FOR GIVEN MOLID
# USAGE       : save_movie molid filename "
#  (no extension of filename is required ) 
# EXAMPLE     : save_movie top my_protein 
# EXAMPLE     : save_movie 1 drug_protein
# OUTPUT      : Genarates filename.gif file 
#
#      
# TCL script Measuring Solvent Accessible Surface Area (SASA) 
# SASA: 
# USAGE   : sasa "SELCTION"
# EXAMPLE : sasa "resid 170 to 180"
# OUTPUT  : SASA.dat
#
# clustering: To do cluster analysis 
# USAGE     : source clustering.tcl in VMD Tk console.
#           : clustering {Atomselection} {rmsd_cutoff} {step size} {frame_args}
#
# Arguments :
# Atomselect:  Any atom selection
# rmsd_cutoff : RMSD cutoff 
# Step_size :   STEP SIZE ( nothing but skip)
# frame_args: Initial & final frame numbers
# Default Arguments : 
# Dist_func : Distance Function is set to rmsd as default.
# num       : No. of Clusters are fixed to default vaule 3
#
# EXAMPLES  :
# EXAMPLE1  : clustering "(protein) and backbone" 1.0 2 
# EXAMPLE2  : clustering "(protein) and backbone" 1.0 2 5
# EXAMPLE3  : clustering "(protein) and backbone" 1.0 2 5 25
# Example1, measures the clusters of given selections with rmsd cutoff 1.0 and step size 2 for zeroth frame to final frame in trajectory.
# Example2, measures the clusters of given selections with rmsd cutoff 1.0 and step size 2 from frame 5 to final frame in trajectory.
# Example3, measures the clusters of given selections with rmsd cutoff 1.0 and step size 2 from frame 5 to frame 25 in trajectory.
#  (At present No. of clusters are fixed to 3)
#  Default  Distance function is rmsd. but you can change to fitrmsd or rgyd or rmsd
#
#
#=====================Allignment=====================================
proc align {molid1 molid2 } {
set n [molinfo top get numframes]
for {set i 0} {$i <= $n} {incr i} {
 if {$molid1 == $molid2} {
set ref_sel [ atomselect $molid1  "protein" frame 0]
set compare_sel [ atomselect $molid2 "protein" frame $i]
} else {
set ref_sel [ atomselect $molid1  "protein" frame $i]
set compare_sel [ atomselect $molid2 "protein" frame $i]
}
set transform_matrx [ measure fit $compare_sel $ref_sel ]

#set mov_sel [atomselect 0 "all" frame $i ]
#$mov_sel move $transform_matrx 
$compare_sel  move $transform_matrx

}
puts "Alignment Done. "
}
# ============================== Measuring RMSD=========================
proc rmsd {sel molid1 molid2 } {
set n [molinfo top get numframes ]
set outfile [open "RMSD.dat" w ]
#printing input given by user
puts $outfile "Given INPUT: \n==================\n"
puts $outfile "Sel :$sel \nMolid : $molid1\n\n Molid : $molid1\n\n"
puts $outfile "Total Frames found : $n \n\n"
puts $outfile "   Frame    RMSD\n==================\n"
puts "Given INPUT: \n==================\n"
puts "Sel :$sel \nMolid : $molid1\n\n Molid : $molid1\n\n"
puts "Total Frames found : $n \n\n"
set sum 0
#=========CYCLE STARTS==============================
for {set i 0} {$i <= $n} {incr i} {
#=========IF BOTH MOLID SAME======================== 
  if {$molid1 == $molid2} {
set selA [atomselect $molid1 $sel frame 0]
set selB [atomselect $molid2 $sel frame $i]
  } else {
#=========IF BOTH MOLID ARE NOT SAME================
set selA [atomselect $molid1 $sel frame $i]
set selB [atomselect $molid2 $sel frame $i]
        }
set transform_matrx [ measure fit $selB $selA ]
#set mov_sel [atomselect 0 "all" frame $i ]
#$mov_sel move $transform_matrx 
$selB  move $transform_matrx
#weighted rmsd
set rmsdAB [measure rmsd $selA $selB weight mass ]
#set rmsdAB [measure rmsd $selA $selB ]
puts [format "Frame: %5d     RMSD : %7.2f" $i $rmsdAB]
puts $outfile [format " %5d    %7.2f" $i $rmsdAB]
set sum [expr $sum+$rmsdAB]
}
#=========CYCLE ENDS===============================
# Averaging
set avg_rmsd [expr $sum/$n]
#------------------------------------------------#
# Standard Deviation
set sum 0
for {set i 0} {$i <= $n} {incr i} {
  if {$molid1 == $molid2} {
set selA [atomselect $molid1 $sel frame 0]
set selB [atomselect $molid2 $sel frame $i]
  } else {
#=========IF BOTH MOLID ARE NOT SAME================
set selA [atomselect $molid1 $sel frame $i]
set selB [atomselect $molid2 $sel frame $i]
        }
#weighted rmsd
set rmsdAB [measure rmsd $selA $selB weight mass ]
set Numarator [expr pow (($rmsdAB-$avg_rmsd),2)]
set sum [expr $sum + $Numarator ]
# sum = sum of (x-x_avg)**2
}
set std [expr sqrt ($sum/($n-1))]
#puts " Standard Deviation : $std "
#------------------------------------------------#
puts [format "\n\n Avg. Rmsd is        : %7.2f\n " $avg_rmsd ]
puts [format " Standard deviation  : %7.2f\n\n " $std ]
puts " Data has stored in RMSD.dat file . "
puts "\n#===================================#\n# Written By ANJI BABU KAPAKAYALA   #\n"
puts  "#===================================#\n"
puts $outfile [format "\n\nAvg. Rmsd is : %7.2f " $avg_rmsd ]
puts $outfile [format "\n\nStd. is : %7.2f " $std ]
puts $outfile "\n#===================================#\n# Written By ANJI BABU KAPAKAYALA   #\n"
puts $outfile "#===================================#\n"
close $outfile
puts "Done."
}
#=============Calculating Distance====================================
proc distance { sel1 sel2 args } {
#---------------------------#
# if {[llength $args] == 2} {
#   set choice "no"
#   puts "$choice"
# }
#---------------------------#
set outfile [open DISTANCE.xvg w ]
set pltfile [open plot.gnp w ]
#set pltfile1 [open dist.xvg w ]
#set hist_file [open HISTOGRAM.dat w]
#set nbin 101
set n [molinfo top get numframes]
#-------------------------------------------------#
#----------setting up frames------------------------------------------#
  if {[llength $args] == 0} {
    set inf 0
    set nf $n
    set plot "false"
  }
  if {[llength $args] == 1} {
    if {[lindex $args 0] == "-show_plot"} {
    set inf 0
    set nf $n
    set plot "true"
    } else {
    set inf [lindex $args 0]
    set nf $n
    set plot "false"
    }
}
  if {[llength $args] > 1} {
     set inf [lindex $args 0]
     if {[lindex $args 1] == "-show_plot"} {
       set plot "true"
       set nf $n
     } else {
      set nf [lindex $args 1]
     }
    if {[lindex $args 2] == "-show_plot"} {
    set plot "true"
    } else {
    set plot "false"
    puts "Use argument: -show_plot to visulize the graph"
    }
}
  puts "\n\n analysis will be performed on $inf to $nf frame(s) " 
#-------------------------------------------------------------------------#
# Writing xmgrace file

  puts $outfile "# -------------------------------------------#"
  puts $outfile "#   <=== Welcome to Easy Console Tool ===>    "
  puts $outfile "#            ANJI BABU KAPAKAYALA	       "
  puts $outfile "# -------------------------------------------#"
  puts $outfile "# This file was created by Easy console tool."
  puts $outfile "# Plots Distance with Frame."
  puts $outfile "\n#GIVEN INPUT DATA :\n#====================\n"
  puts $outfile "#Sel1 : $sel1 \n# Sel2 : $sel2\n"
  puts $outfile "# No. of Frames found : $n \n"
  puts $outfile "@ title \"Distance vs Frame.\""
  puts $outfile "@ xaxis label \"Frame\""
  puts $outfile "@ yaxis label \"Distance\""
  puts $outfile "@ TYPE xy"
  puts $outfile "@ view 0.15, 0.15, 1.00, 0.75"
  puts $outfile "@ legend on"
  puts $outfile "@ legend box on"
  puts $outfile "@ legend loctype view"
  puts $outfile "@ legend 0.78, 0.8"
  puts $outfile "@ legend length 2"
  puts $outfile "@ s0 legend \"Distance\""
#-------------------------------------------------#
puts  "\nGIVEN INPUT DATA :\n====================\n"
puts  " Sel1 : $sel1 \n Sel2 : $sel2\n\n"
puts  " No. of Frames found : $n \n\n"
set sum 0
 for  {set i $inf}  {$i <= $nf}  {incr i}  {
       set atom1 [atomselect top $sel1 frame $i ]
       set atom1_posi [ lindex [ $atom1 get "x y z"] 0 ]
#       puts "Atom1 Positions : $atom1_posi\n"
       $atom1 delete
       set atom2 [atomselect top $sel2 frame $i ]
       set atom2_posi [ lindex [ $atom2 get "x y z"]  0 ]
#       puts "Atom2 Positions : $atom2_posi \n"
       $atom2 delete
       set dist [ vecdist $atom1_posi $atom2_posi ]
       set distribution($i.r) $dist
       puts $outfile [format " %5d    %7.2f" $i  $dist]
#       puts  "Frame : $i\t Distance : $dist "
      set sum [expr $sum + $dist]
    }
#--------Averaging
   set Avg_dist [expr $sum/$nf]
#--------Standard Deviation
set sum 0
 for  {set i $inf}  {$i <= $nf}  {incr i}  {
       set atom1 [atomselect top $sel1 frame $i ]
       set atom1_posi [ lindex [ $atom1 get "x y z"] 0 ]
       $atom1 delete
       set atom2 [atomselect top $sel2 frame $i ]
       set atom2_posi [ lindex [ $atom2 get "x y z"]  0 ]
       $atom2 delete
       set dist [ vecdist $atom1_posi $atom2_posi ]
    set Numarator [expr pow (($dist-$Avg_dist),2)]
    set sum [expr $sum + $Numarator ]
# sum = sum of (x-x_avg)**2
}
set std [expr sqrt ($sum/($nf-1))]
#puts " Standard Deviation : $std "
#------------------------------------------------#
#HISTOGRAM
#set d_min distance(0.r)
#set d_max distance(0.r)
#for {set i 0} {$i < $n} {incr i} {
#if {$distance($i.r) < $d_min} {set d_min $distance($i.r)}
#if {$distance($i.r) > $d_min} {set d_max $distance($i.r)}
#}
#set width [expr ($d_max - $d_min) / ($nbin -1)]
#for {set k 0} {$k < $nbin} {incr k} {
#set distribution($k) 0
#}
#for {set i 0} {$i < $n} {incr i} {
#set k [expr int(($distance($i.r) - $d_min) / $width)]
#incr distribution($k)
#}
#for {set k 0} {$k < $nbin} {incr k} {
#puts $hist_file "[expr $d_min + $k * $width] $distribution($k)"
#}
#close  $hist_file
#--------------------------------------------------#
#   puts $outfile [ format "\n\nAvg. Distance       : %7.2f\n\n"  $Avg_dist ]
#   puts $outfile [ format " Standard Deviation  : %7.2f\n\n"  $std ]
#-------------------------------------------------#
# Plotting script using gnuplot
  puts $pltfile "set term png"
  puts $pltfile "set output 'dist.png'"
  puts $pltfile "set border lw 2"
  puts $pltfile "set grid"
  puts $pltfile "set yl 'Distance'"
  puts $pltfile "set xl 'Frame'"
  puts $pltfile "set xr \[$inf:$nf\]"
# puts $pltfile "set ytics 0,2"
  puts $pltfile "plot 'DISTANCE.xvg' u 1:2 w l lw 2 lc'black' title'Distance'"

  close $pltfile 
#-------------------------------------------------#

   puts  [ format "\n Avg. Distance       : %7.2f (A)\n"  $Avg_dist ]
   puts  [ format " Standard Deviation  : %7.2f\n\n"  $std ]
   puts  " Note : Data has been stored in files DISTANCE.xvg & plot.png\n\n"
   puts " #=================================================#"
   puts " #  Written By ANJI BABU KAPAKAYALA                #"
   puts " #=================================================#"
   close $outfile
#--->
if {$plot == "true"} {
exec xmgrace DISTANCE.xvg &
}
#
  exec  gnuplot plot.gnp 
  exec rm plot.gnp
# exec "xdg-open dist.png &"
}
#=========================Calculating Avg Angle=========================================
proc angle {sel1 sel2 sel3 } {
set outfile [open "ANGLE.dat" w]
set n [molinfo top get numframes]
#--------writing given inputs--------------
puts $outfile "\nGIVEN INPUT DATA :\n====================\n\n"
puts $outfile "Sele1 : $sel1 \n Sel2 : $sel2\n Sel3 : $sel3\n\n"
puts $outfile " No. of Frames found : $n \n\n"
puts  "\nGIVEN INPUT DATA :\n====================\n\n"
puts  " Sel1 : $sel1 \n Sel2 : $sel2\n Sel3 : $sel3\n\n"
puts  " No. of Frames found : $n \n\n"
set sum 0
global M_PI
#puts "PI : $M_PI"
for {set i 0} {$i <= $n} {incr i} {
    set A [atomselect top $sel1 frame $i ]
    set B [atomselect top $sel2 frame $i ]
    set C [atomselect top $sel3 frame $i ]
        set A_pos [ lindex [$A get "x y z" ] 0 ]
        set B_pos [ lindex [$B get "x y z" ] 0 ]
        set C_pos [ lindex [$C get "x y z" ] 0 ]
   $A delete
   $B delete
   $C delete
    set v1 [vecsub $B_pos $A_pos ]
    set v2 [vecsub $C_pos $B_pos ]
    set dot_prod [vecdot $v1 $v2 ]
    set mod_v1 [veclength $v1]
    set mod_v2 [veclength $v2]
    set cos_theta [expr $dot_prod/$mod_v1*$mod_v2]
    set theta [expr acos($cos_theta)*180.0/$M_PI]
         set sum [expr $sum + $theta]
     puts $outfile "$i  $theta "
}
#-----------------Averaging
   set Avg_angle [expr $sum/$n]
#----------------Standard Deviation
set sum 0
for {set i 0} {$i <= $n} {incr i} {
    set A [atomselect top $sel1 frame $i ]
    set B [atomselect top $sel2 frame $i ]
    set C [atomselect top $sel3 frame $i ]
        set A_pos [ lindex [$A get "x y z" ] 0 ]
        set B_pos [ lindex [$B get "x y z" ] 0 ]
        set C_pos [ lindex [$C get "x y z" ] 0 ]
   $A delete
   $B delete
   $C delete
    set v1 [vecsub $B_pos $A_pos ]
    set v2 [vecsub $C_pos $B_pos ]
    set dot_prod [vecdot $v1 $v2 ]
    set mod_v1 [veclength $v1]
    set mod_v2 [veclength $v2]
    set cos_theta [expr $dot_prod/$mod_v1*$mod_v2]
    set theta [expr acos($cos_theta)*180.0/$M_PI]
    set Numarator [expr pow (($theta-$Avg_angle),2)]
    set sum [expr $sum + $Numarator ]
# sum = sum of (x-x_avg)**2
}
set std [expr sqrt ($sum/($n-1))]
#puts " Standard Deviation : $std "
#------------------------------------------------#
       puts [ format "\n Avg Angle          : %7.2f (deg) \n"  $Avg_angle ]
       puts [ format " Standard Deviation : %7.2f \n\n"  $std ]
       puts $outfile [ format " \n=======================================\nAvg Angle : %7.2f \n Standard Deviation : %7.2f \n==============================\n" $Avg_angle $std ]
puts " Note : Data has been stored in ANGLE.dat file.\n"
puts "\n #===================================================#"
puts " #    Written By ANJI BABU KAPKAYALA                 #"
puts " #===================================================#"
close $outfile
}
#=====================Calculating Dihedral Angle ================================
proc dihedral { sel1 sel2 sel3 sel4 } {
set outfile [open "dihedral.dat" w]
set n [molinfo top get numframes ]
#--------writing given inputs--------------
puts $outfile "\n GIVEN INPUT DATA :\n====================\n\n"
puts $outfile " Sel1 : $sel1 \n Sel2 : $sel2\n\ Sel3 : $sel3\n Sel4 : $sel4"
puts $outfile " No. of Frames found : $n \n\n"
puts  "\n GIVEN INPUT DATA :\n====================\n\n"
puts  " Sel1 : $sel1 \n Sel2 : $sel2\n Sel3 : $sel3\n Sel4 : $sel4\n\n"
puts  " No. of Frames found : $n \n\n"
set sum 0
global M_PI
#puts "PI : $M_PI "
for {set i 0 } {$i <= $n} {incr i} {
set a [atomselect top $sel1 frame $i ]
set b [atomselect top $sel2 frame $i ]
set c [atomselect top $sel3 frame $i ]
set d [atomselect top $sel4 frame $i ]
    set a_pos [lindex [$a get "x y z"] 0]
    set b_pos [lindex [$b get "x y z"] 0]
    set c_pos [lindex [$c get "x y z"] 0]
    set d_pos [lindex [$d get "x y z"] 0]
#setting up three vectors from four points
   set v1 [vecsub $b_pos $a_pos ]
   set mod_v1 [veclength $v1]
   set v2 [vecsub $c_pos $b_pos ]
   set mod_v2 [veclength $v2]
   set v3 [vecsub $d_pos $c_pos ]
   set mod_v3 [veclength $v3]
#setting up unit  normal vectors
   set n1 [vecnorm [veccross $v1 $v2 ]]
   set n2 [vecnorm [veccross $v2 $v3 ]]
# Get dot product of n1 and n2
   set dot_prod [vecdot $n1 $n2 ]
#Calculating COS_theta by using dot product of above two normal vectors
   set cos_theta [expr $dot_prod  ]
# get theta in degrees
 set theta [expr acos($cos_theta)*180.0/$M_PI ]
# Get sign is vector dot prod of n3.v2
  set n3  [vecnorm [ veccross $n1 $n2 ]]
  set sign [vecdot  $v2 $n3 ]
#if sign is +ve dihedra is +ve , if sign is -ve then Dihedral is -ve , if sign = 0 then dihedral = 180.0
    if {$sign < 0} {
#       puts $outfile2  "Sign is -ve\n"
       set theta [expr {0-$theta}]
     } elseif {$sign == 0} {
#       puts $outfile2  "Sign is 0\n"
       set theta 180.00
     } else { 
#       puts $outfile2  "Sign is +ve\n"
       set theta $theta }
#========FINAL DIHEDRAL ANGLE====================
 puts  $outfile [format "%-5d %7.3f" $i  $theta ]
#======================Summingup all dihedrals===
set sum [expr $sum+$theta ]
}
#==========ANG DIHEDRAK=========================
set avg_dihedral [ expr $sum/$n]
#----------------Standard Deviation
set sum 0
for {set i 0 } {$i <= $n} {incr i} {
set a [atomselect top $sel1 frame $i ]
set b [atomselect top $sel2 frame $i ]
set c [atomselect top $sel3 frame $i ]
set d [atomselect top $sel4 frame $i ]
    set a_pos [lindex [$a get "x y z"] 0]
    set b_pos [lindex [$b get "x y z"] 0]
    set c_pos [lindex [$c get "x y z"] 0]
    set d_pos [lindex [$d get "x y z"] 0]
   set v1 [vecsub $b_pos $a_pos ]
   set mod_v1 [veclength $v1]
   set v2 [vecsub $c_pos $b_pos ]
   set mod_v2 [veclength $v2]
   set v3 [vecsub $d_pos $c_pos ]
   set mod_v3 [veclength $v3]
#=========================================
#setting up unit  normal vectors
   set n1 [vecnorm [veccross $v1 $v2 ]]
   set n2 [vecnorm [veccross $v2 $v3 ]]
# Get dot product of n1 and n2
   set dot_prod [vecdot $n1 $n2 ]
#Calculating COS_theta by using dot product of above two normal vectors
   set cos_theta [expr $dot_prod  ]
# get theta in degrees
 set theta [expr acos($cos_theta)*180.0/$M_PI ]
#===============================================
# Get sign is vector dot prod of n3.v2
  set n3  [vecnorm [ veccross $n1 $n2 ]]
  set sign [vecdot  $v2 $n3 ]
#if sign is +ve dihedra is +ve , if sign is -ve then Dihedral is -ve , if sign = 0 then dihedral = 180.0
    if {$sign < 0} {
#       puts $outfile2  "Sign is -ve\n"
       set theta [expr {0-$theta}]
     } elseif {$sign == 0} {
#       puts $outfile2  "Sign is 0\n"
       set theta 180.00
     } else { 
#       puts $outfile2  "Sign is +ve\n"
       set theta $theta }
#========FINAL DIHEDRAL ANGLE====================
    set Numarator [expr pow (($theta-$avg_dihedral),2)]
    set sum [expr $sum + $Numarator ]
# sum = sum of (x-x_avg)**2
}
set std [expr sqrt ($sum/($n-1))]
#puts " Standard Deviation : $std "
#------------------------------------------------#
    puts  $outfile [format "%-5d %7.3f" $i  $theta ]
    puts [format "\n Avg. Dihedral angle : %7.2f\n" $avg_dihedral ]
    puts [format " Standard Deviation : %7.2f\n\n" $std ]
    puts " Note : Data has been stored in DIHEDRAL.dat file .\n\n"
    puts $outfile [format "#=========================#\n#Avg. Dihedral angle : %7.2f\n Standard Deviation : %7.2f\n#========================#\n" $avg_dihedral $std ]
#    puts $outfile2 [format "#==============================#\n#Avg. Dihedral angle : %7.3f\n#==============================#\n" $avg_dihedral ]
#    puts $outfile2 "\n#============================================#\n#     Written By ANJI BABU KAPKAYALA         #\n#============================================#\n"
    puts "\n#============================================#\n#     Written By ANJI BABU KAPKAYALA         #\n#============================================#\n"
close $outfile
}
#===========================CONTACT MAP==============================
# USAGE   : contact_map " sel1"  "sel2"  cutoff startframe endframe
#
# Example : contact_map {"resid 1 to 50" "resid 51 to 100" 6.0 0 10
# 
# PLOTTING DATA : gnuplot >>  splot "contact_map.dat" u 1:2:3 w p " 
#                 gnuplot >>  set view 0,0,1
#                 gnuplot >>  replot
#
# Know more about Contact maps : https://en.wikipedia.org/wiki/Protein_contact_map
#
proc contact_map { sel1 sel2 cutoff inf nf } {
set outfile [open "CONTACT_MAP.dat" w]
set n [molinfo top get numframes ]
#--------writing given inputs--------------
puts $outfile "\n GIVEN INPUT DATA :\n====================\n\n"
puts $outfile " Sel1 : $sel1 \n Sel2 : $sel2\n"
puts $outfile " Given cutoff  : $cutoff \n"
puts $outfile " Intial Frame  : $inf \n Final Frame  : $nf\n"
#puts $outfile " No. of Frames found : $n \n\n"
puts  "\n GIVEN INPUT DATA :\n====================\n\n"
puts  " Sel1 : $sel1 \n Sel2 : $sel2\n"
puts  " Intial Frame  : $inf \n Final Frame   : $nf\n"
puts  " Given cutoff  : $cutoff \n"
#puts  " No. of Frames found : $n \n\n"
#puts "No of Frames found:$n\n================="
#============ALL ATOMS MAPPING DATA=================
set all [atomselect top "all"]
set allresid [$all get resid]
set allresname [$all get resname ]
set alltype [$all get type ]
#set allpos [$all get "x y z" ]
    foreach resid $allresid resname $allresname {
         set mapallresidresname($resid) $resname
#         puts $mappings "$resid $resname" 
   } 
#=================CYCLE STARTS=========================
  for {set i $inf} {$i <= $nf} {incr i} {
     set A [atomselect top $sel1 frame $i ]
     set B [atomselect top $sel2 frame $i ]
#--------------------------------------------#
#updating atomselection "all"
 $all frame $i
 $all update
#   set all [atomselect top "all" frame $i]
   set allpos [ $all get "x y z" ]
#--------------------------------------------#
     foreach {listA listB} [measure contacts $cutoff $A $B ] break
     foreach indexA $listA indexB $listB {
     set distance [vecdist [lindex $allpos $indexA] [lindex $allpos $indexB]]
         set Aresid [lindex $allresid $indexA]
         set Bresid [lindex $allresid $indexB]
         set Aresname [lindex $allresname $indexA ]
         set Bresname [lindex $allresname $indexB ]
#============printing f distance is bellow 3.0 A ==========
            if { $distance <= 4.0 } {
              puts $outfile [format " %4s %4s %3d %7.2f " $Aresid  $Bresid  1 $distance ]
            }
           if { $distance > 4.0 } {
              puts $outfile [format " %4s %4s %3d %7.2f " $Aresid  $Bresid  0  $distance ]
            }
#puts "$i"
     }  
   } 
close $outfile
puts " Data has stored in file : CONTACT_MAP.dat \n\n "
puts " PLOTTING DATA : gnuplot >>  splot 'contact_map.dat' u 1:2:3 w p notitle "
puts "                 gnuplot >>  set view 0,0,1  "
puts "                 gnuplot >>  replot   \n\n"
puts "#================================================#"
puts "#     Written By ANJI BABU KAPAKAYALA            #"
puts "#================================================#"
}
#=====================================PRINT RESIDUES NAMES AND RESID================
proc show_residues {sel molid args} {
set outfile [open "RESNAMES.dat" w]
#set resname_list [$selA get resname ]
set numframes [molinfo $molid get numframes ]
# nf: end frame
# t : starting frame
#----------setting up frames------------------------------------------#
  if {[llength $args] == 0} {
    set inf 0
    set nf 0
  }
  if {[llength $args] == 1} {
  set inf [lindex $args 0]
  set nf $numframes
}
  if {[llength $args] > 1} {
   set inf [lindex $args 0]
   set nf [lindex $args 1]
}
  puts "\n\n analysis will be performed on $inf to $nf frame(s) " 
#-------------------------------------------------------------------------#
#set resid_list [$selA get resid ]
  puts "  \n  Given Input : \n  ===============\n"
  puts "  Sel   : $sel\n"
  puts "  Molid : $molid\n\n"
  puts "  OUTPUT : \n\n  RESID  RESNAME \n ===============\n"
  puts $outfile "  \n  Given Input : \n  ===============\n"
  puts $outfile "  Sel   : $sel\n"
  puts $outfile "  Molid : $molid\n\n"
  puts $outfile "  OUTPUT : \n\n  RESID  RESNAME \n ===============\n"
#-------------CYCLE STARTS--------------------
 for {set i $inf} {$i <= $nf} {incr i} {
set selA [atomselect $molid "$sel" frame $i ]
set list1 [ $selA get {resid   resname } ]
puts " Frame : $i \n-----------\n" 
puts $outfile " Frame : $i \n=============\n" 
  set unique [lsort -unique $list1 ]
#   puts $unique
   foreach resid_resname $unique {
   puts "   $resid_resname "
   puts $outfile  "   $resid_resname "
   }
 puts " ================"
 puts $outfile " ================"
}
#--------------------------------
#set RESID [lsort -unique $resid_list ]
#set RESNAME [lsort -unique $resname_list ]
#puts " $RESID  \n$RESNAME"
# foreach resid $RESID resname $RESNAME  {
#     puts [format " %5d    %4s"  $resid $resname ]
#  }
puts "\n  Note: Data has been stored in RESNAMES.dat .\n\n"
puts "\n #================================================#"
puts " #     Written By ANJI BABU KAPAKAYALA            #"
puts " #================================================#"

}
#================================MOLECULE DETAILS===================
proc details { sel } {
   set molid 0

#----------setting up frames------------------------------------------#
  if {$sel == "system"} {
#
 set n [molinfo $molid get numframes]
 set name [molinfo $molid get name]
 set natoms [molinfo $molid get numatoms]
 set current_frame [molinfo $molid get frame]
 set id [molinfo $molid get id]
 set index [molinfo $molid get index]
 set filname [molinfo $molid get filename]
 set filtype [molinfo $molid get filetype]
 set timsteps [molinfo $molid get timesteps]
 set box [molinfo $molid get {a b c} ]
 set box1 [molinfo $molid get {alpha beta gamma} ]
 set protein [atomselect $molid "protein" ] 
 set protein_natoms [llength [ $protein get name ]]
 set waters [atomselect $molid "resname WAT " ] 
 set nwaters [llength [ $waters get name ]]
 set ions [atomselect $molid "ion and ions" ] 
 set nions [llength [ $ions get serial ]]
 #--------Printing
puts "\n Molecule Details : \n====================\n\n"
puts " Name          : $name "
puts " Files Used    : $filtype"
puts " Molid         : $id   "
puts " Total Atoms   : $natoms"
puts " Protein Atoms : $protein_natoms"
puts " No. of Waters : $nwaters "
puts " No. of Ions   : $nions"
puts " Total Frames  : $n"
puts " Current Frame : $current_frame"
puts " BOX SIZE      : $box"
puts "               : $box1 "
puts "\n\n #================================================#"
puts " #     Written By ANJI BABU KAPAKAYALA            #"
puts " #================================================#"
#
} else {
#   set sel [lindex $args 1]
puts "\n Details : \n====================\n\n"
puts "index name resid resname"
puts "====================\n\n"
   set selA [atomselect $molid "$sel" ]
   set list1 [ $selA get { index  name resid  resname } ]
#  
   set unique [lsort -unique $list1 ]
   foreach resid_resname $unique {
   puts "   $resid_resname "
   }
puts "\n\n #================================================#"
puts " #     Written By ANJI BABU KAPAKAYALA             #"
puts " #================================================#"
}
}
#======================SHOW NO OF WATERS WITHIN GIVEN SELECTION================
proc count_waters {sel molid inf nf } {
set outfile [open "NO-OF-WATERS.dat" w ]
puts "\n Given INPUT  : \n ==============\n"
puts " Sel    : $sel\n Molid  : $molid\n"
puts " Initial Frame : $inf "
puts " Final Frame   : $nf  \n"
puts " OUTPUT  :\n =========\n"
set n [ molinfo top get numframes ]
set sum 0
puts $outfile  " No of frames found are : $n "
for {set i $inf } {$i <= $nf } {incr i} {
    set waters [ atomselect $molid " ($sel) and resname WAT or resname SOLV and type O" frame $i]
    set nw [llength [ $waters get type ]]
    puts $outfile [ format " Frame  : %3d   No of Waters : %3d" $i $nw ]
    puts  [ format " Frame  : %3d    No of Waters : %3d" $i $nw ]
    set sum [expr $sum+$nw] 
}
#---------Averaging
   set Avg_waters [expr $sum/($nf-$inf)]
    puts $outfile [format " \n\n Avg. No. of Waters : %3d" $Avg_waters]
    puts [format " \n\n Avg. No. of Waters : %3d\n" $Avg_waters]
#---------Standard Deviation
set sum 0
for {set i $inf} {$i <= $nf } {incr i} {
    set waters [ atomselect $molid " ($sel) and resname WAT and type O" frame $i]
    set nw [llength [ $waters get type ]]
    set Numarator [expr pow (($nw-$Avg_waters),2)]
    set sum [expr $sum + $Numarator ]
# sum = sum of (x-x_avg)**2
}
set std [expr sqrt ($sum/($nf-1))]
    puts $outfile [format " \n\n Standard Deviation : %7.2f" $std]
    puts  [format " \n\n Standard Deviation : %7.2f\n\n" $std]
    puts " Note : Data has been stored in NO-OF-WATERS.dat ."
puts "\n\n #================================================#"
puts " #     Written By ANJI BABU KAPAKAYALA            #"
puts " #================================================#"
}
#
#================== SET PBC BOX for given molid ============================
proc pbc_box {choice} {
 if { "on" == $choice } {
  pbc box -center com
} elseif {"off" == $choice} {
  pbc box no 
} elseif {"size" == $choice } {
 set box [molinfo top get {a b c} ]
 set box1 [molinfo top get {alpha beta gamma} ]
 puts " \n\nBOX SIZE       : $box"
 puts "               : $box1 \n\n"
 puts "\n\n\n ***** ANJI BABU KAPAKAYALA*****\n" 
} else { puts "\n type  --help pbc_box  To check command \n\n\n ***** ANJI BABU KAPAKAYALA*****\n" }
}
#
#
#=======================================
proc show_interactions {sel1 sel2 cutoff inf nf } {
#============   READING INPUT FROM USER========================
#puts -nonewline "Enter Cutoff Distance :"
#flush stdout
#set cutoff [gets stdin]
#puts -nonewline "Enter Initial frame : "
#flush stdout
#set inf [gets stdin]
#puts -nonewline "Enter Final frame : "
#flush stdout
#set nf [gets stdin]
set outfile [open "INTERACTIONS.dat" w]
#============PRINTING GIVEN INPUT===========================
#set cutoff 3.0 
puts $outfile  " \n  Atomselection 1 : $sel1"
puts $outfile  "  Atomselection 2 : $sel2"
puts $outfile  "  Given Cutoff    : $cutoff "
puts $outfile  "  Starting Frame  : $inf "
puts $outfile  "  End Frame       : $nf \n=============================\n"
puts   " \n Atomselection 1 : $sel1"
puts   "  Atomselection 2 : $sel2"
puts   "  Given Cutoff    : $cutoff "
puts   "  Srarting Frame  : $inf "
puts   "  End Frame       : $nf \n=============================\n"
#set n [molinfo top get numframes]
#set n 2
#puts "$n"
#====================ALL ATOM DATA==========================
set all [atomselect top "all"]
set allresid [$all get resid]
set allresname [$all get resname ]
set alltype [$all get type ]
#set allpos [$all get "x y z" ]
    foreach resid $allresid resname $allresname {
          set mapallresidresname($resid) $resname
#         puts $mappings "$resid $resname" 
   } 
#=================CYCLE STARTS==============================
for {set i $inf} {$i <= $nf} {incr i} {
#set selA [atomselect top "resid 235 and type O69 O70 O71 O72 O73 N50" frame $i ]
#set selB  [atomselect top "protein" frame $i]
set selA [atomselect top $sel1 frame $i ]
set selB  [atomselect top $sel2 frame $i]
    set index_listA [$selA get index]
    set index_listB [$selB get index]
#--------------------------------------------#
#updating atomselection "all"
 $all frame $i
 $all update
#   set all [atomselect top "all" frame $i]
   set allpos [ $all get "x y z" ]
#--------------------------------------------#
       puts "\nFrame$i\n=======\n"
       puts $outfile "\nFrame$i\n=======\n"
       foreach indexA $index_listA {
                 foreach indexB $index_listB {
                 set posA [lindex $allpos  $indexA ]
                 set posB [lindex $allpos  $indexB ]
                 set residA [lindex $allresid  $indexA ]
                 set residB [lindex $allresid  $indexB ]
                 set typeA [lindex $alltype  $indexA ]
                 set typeB [lindex $alltype $indexB ]
                 set resnameA [lindex $allresname  $indexA ]
                 set resnameB [lindex $allresname  $indexB ]
#          puts $outfile "POSA : $posA\n\nPOSB : $posB\n====\n"
               set disAB [vecdist $posA $posB ]
                  if {$disAB <= $cutoff } {
             #puts "$indexA  $residA $resnameA --  $indexB $residB $resnameB  ---  $disAB"
             puts $outfile [format "%5d %5d %4s (%4s) -- %5d %5d %4s (%4s) --- %7.3f " $indexA $residA $resnameA $typeA $indexB $residB $resnameB $typeB $disAB]
             puts  [format "%5d %5d %4s (%4s) -- %5d %5d %4s (%4s) --- %7.3f " $indexA $residA $resnameA $typeA $indexB $residB $resnameB $typeB $disAB]
                  }
    #        puts "resid : $residA index:$indexA pos: $selA_pos   \n\nresid : $residB index:$indexB pos: $selB_pos\n"
               }
      }     
}
puts $outfile "\n#=================================#\n# Written By ANJI BABU KAPAKAYALA #\n#=================================#\n"
puts  "\n\n\n\n\n\n         $**********     ANJI BABU KAPAKAYALA    *********$  \n"
close $outfile
#puts "\nDone."
}
#==================================HYDROGEN BONDS====================================
proc show_hbonds  { sel1 sel2 cutoff angle inf nf } {
set outfile [open "HBONDS.dat" w]
#set n [molinfo top get numframes ]
#set ccutoff 5.0
#set angle 30.0
#============PRINTING GIVEN INPUT===========================
#set cutoff 3.0 
puts $outfile   "\n Atomselection 1 : $sel1"
puts $outfile  " Atomselection 2 : $sel2"
puts $outfile  "\nGiven Cutoff    : $cutoff "
puts $outfile  "Starting Frame  : $inf "
puts $outfile  "End Frame       : $nf \n=============================\n"
puts   "\n Atomselection 1 : $sel1"
puts   " Atomselection 2 : $sel2"
puts   " Given Cutoff    : $cutoff "
puts   " Starting Frame  : $inf "
puts   " End Frame       : $nf \n=============================\n"
#====================ALL ATOM DATA==========================
set all [atomselect top "all"]
set allresid [$all get resid]
set allresname [$all get resname ]
set alltype [$all get type ]
#set allpos [$all get "x y z" ]
    foreach resid $allresid resname $allresname {
          set mapallresidresname($resid) $resname
#         puts $mappings "$resid $resname" 
   } 
set sum 0
#=================CYCLE STARTS==============================
  for {set i $inf} {$i <= $nf} {incr i} {
     set A [atomselect top $sel1 frame $i ]
     set B [atomselect top $sel2 frame $i ]
#      set A [atomselect top " protein and (not hydrophobic) " frame $i]
#      set B [atomselect top "resname MRP and type O69 O70 O71 O72 O73 N50"  frame $i]
#--------------------------------------------#
#updating atomselection "all"
 $all frame $i
 $all update
#   set all [atomselect top "all" frame $i]
   set allpos [ $all get "x y z" ]
#--------------------------------------------#
          puts $outfile "Frame : $i\n==========\n"
#          puts  "Frame : $i\n==========\n"
     set M 0 
     foreach {listA listB} [measure hbonds $cutoff $angle $A $B ] break
#      puts "listA :\n $listA\n\nlistB\n: $listB\n====="
     foreach indexA $listA indexB $listB  {
     set distance [vecdist [lindex $allpos $indexA] [lindex $allpos $indexB]]
         set Aresid [lindex $allresid $indexA]
         set Bresid [lindex $allresid $indexB]
         set Aresname [lindex $allresname $indexA ]
         set Bresname [lindex $allresname $indexB ]
         set Aatomtype [lindex $alltype $indexA ]
         set Batomtype [lindex $alltype $indexB ] 
#============printing f distance is bellow 3.0 A ==========
          #  if { $distance <= 3.0 } {
#counting No. of Hbonds
            set M [expr $M + 1]
            puts $outfile [format "%5d %5d %5d  %4s (%3s) --- %5d %5d  %4s (%3s) -- %7.2f " $i $indexA $Aresid  $Aresname $Aatomtype $indexB $Bresid  $Bresname $Batomtype  $distance]
            puts  [format "%5d %5d %5d  %4s (%3s) --- %5d %5d  %4s (%3s) -- %7.2f " $i $indexA $Aresid  $Aresname $Aatomtype $indexB $Bresid  $Bresname $Batomtype  $distance]
#}
}
#    puts $outfile "\n No. of Hbonds : $M\n " 
#    puts  "\n No. of Hbonds : $M\n " 
    set sum [expr $sum + $M]
}
    set avg_hbonds [expr $sum/($nf-$inf)]
    puts $outfile [format " \n\n Avg. No. of HBonds :  %7.2f\n\n" $avg_hbonds]
    puts  [format " \n\n Avg. No. of HBonds :  %7.2f\n\n" $avg_hbonds]
    puts " Data has been stored in HBONDS.dat\n\n\n"
    puts "\n\n  $**********   ANJI BABU KAPAKAYALA   **********$ \n\n"
close $outfile
}
#==============================================================================
#TCL VMD script to calculate Avg No. of HBonds for given Acceptor and Donor groups in protein 
#
#USAGE   : Open VMD/Extensions - Tk console then execute script as " source script.tcl"
#
# HBONDS_COUNT.dat : Which contains Frame vs No.of Hbonds (You can plot this data as Frames v/s No. of Hbonds)
#
proc count_hbonds {Donor_sel1 Acceptor_sel2 cutoff angle } {
#set outfile [open "hbonds-details.dat" w]
set outfile [open "HBONDS_COUNT.dat" w]
#============PRINTING GIVEN INPUT===========================
puts " \n Given Input  :\n================\n"
puts "    D_sel1       : $Donor_sel1 "
puts "    A_sel2       : $Acceptor_sel2"
puts "    Cutoff       : $cutoff "
puts "    Angle        : $angle \n================"
#puts   "Initial Frame : $inf "
#puts   "Final Frame   : $nf \n\n"
#-----------------
set n [ molinfo top get numframes]
puts " \n\n Total Frames found : $n \n\n"
set sum 0
for {set i 0} {$i <= $n} {incr i} {
#set D [atomselect top "protein and name N" frame $i] 
#set A [atomselect top "protein and name O" frame $i]
set D [atomselect top $Donor_sel1 frame $i] 
set A [atomselect top $Acceptor_sel2 frame $i]
set D_list [$D get {resname type serial }]
set A_list [$A get {resname type serial }]
#set lists [measure hbonds 3.5 30 $D $A]
set lists [measure hbonds $cutoff $angle $D $A]
set atoms [lindex $lists 0]
set Num [llength $atoms]  
#---------Writing OUTPUT----------------------#
#puts $outfile [format "%3d   %3d" $i   $Num]
#puts  [format " Frame : %3d  No. of HBonds : %3d" $i   $Num]
#---------------------------------------------#
set sum [expr $sum + $Num ]
#puts "Sum :: $sum"
}
#------------------Calculating Avg HBonds--------#
set avg_HB [expr $sum/$i]
puts $outfile [ format " \n\n Ang Hbonds :: %7.2f" $avg_HB]
puts  [ format " \n\n================================\n  Ang. No. of  Hbonds :: %7.2f\n================================\n" $avg_HB]
puts "\n\n Note :  HBONDS_COUNT.dat  :: Contains Frames v/s No. Of Hbonds"
puts " \n\n\n\n $**********   ANJI BABU KAPAKAYALA   **********$\n\n"
puts $outfile " \n\n\n\n #$**********   ANJI BABU KAPAKAYALA   **********$#\n\n"
#puts "hbonds-details.dat :: Details of Acceptor & Donor & Hbonds residues "
$D delete
$A delete
close $outfile
}
#==================================================================
#TCL VMD SCRIPT TO GET HBONDING OCCUPANCY (%)
#
# USAGE   : HB_occupancy "sel1" "sel2" start_frame end_frame
#
# EXAMPLE : HB_occupancy "protein" "resid 235"
# EXAMPLE : HB_occupancy "protein" "resid 235" 200
# EXAMPLE : HB_occupancy "protein" "resid 235" 200 400
#
#
proc HB_occupancy { sel1 sel2 args } {
set n [ molinfo top get numframes]
# Distance cutoff and angle cutoff are fixed.    
    set cutoff 3.0
    set angle 30.0
#----------setting up frames------------------------------------------#
  if {[llength $args] == 0} {
    set inf 0
    set nf $n
  }
  if {[llength $args] == 1} {
    set inf [lindex $args 0]
    set nf $n
    }
  if {[llength $args] > 1} {
     set inf [lindex $args 0]
     set nf [lindex $args 1]
    }
  puts "\n\n analysis will be performed on $inf to $nf frame(s) " 
#-------------------------------------------------------------------------#
# Printing given input data
puts " \n Given Input   : \n==================\n"
puts "  Atomselection 1 : $sel1 "
puts "  Atomselection 2 : $sel2 "
puts "  Distance Cutoff : $cutoff"
puts "  Angle Cutoff    : $angle"
puts "  Starting Frame  : $inf"
puts "  End Frame       : $nf\n\n"


#  set n [molinfo top get numframes]
#-----------------------------------------------#
  # make some mappings
  set all [atomselect top all]
  # resid map for every atom
  set allResid [$all get resid]
  # resname map for every atom
  set allResname [$all get resname]
  # create resid->resname map
  foreach resID $allResid resNAME $allResname {
    set mapResidResname($resID) $resNAME
  }
#----------------------------------------------#
  # create specified atom selections
  set A [atomselect top $sel1]
  set B [atomselect top $sel2]
#---------------------------------------------#
  # output file for printing out all contacts
  set outfile [open "HBONDS.dat" w]
 #--------------------------------------------#
  # cycle over the trajectory
  for {set i $inf} {$i <= $nf} {incr i} {
#---------------------------------------------#
    # update selections
    # we expect that atom assignments didn't change
    $all frame $i
    $all update
    $A frame $i
    $A update
    $B frame $i
    $B update
#---------------------------------------------#
    # position for every atom
    set allPos [$all get {x y z}]
#---------------------------------------------#    
    # extract the pairs. listA and listB hold corresponding pairs from selections 1 and 2, respectively.
    foreach {listA listB} [measure hbonds $cutoff $angle $A $B] break
#---------------------------------------------#
    # go through the pairs, assign distances
    foreach indA $listA indB $listB {
      # calculated distance between 2 atoms
      set dist [vecdist [lindex $allPos $indA] [lindex $allPos $indB]]
      # get information about residue id's
      set residA [lindex $allResid $indA]
      set residB [lindex $allResid $indB]
      # results will be stored in [residA,residB][list of distances] array
      lappend HBONDS($residA,$residB) $dist
    }
#---------------------------------------------#
    foreach name [array names HBONDS] {
      # assign residue names to residue numbers
      foreach {residA residB} [split $name ,] break
      foreach {tmp resnameA} [split [array get mapResidResname $residA] ] break
      foreach {tmp resnameB} [split [array get mapResidResname $residB] ] break
      # get minimum contact distance for the pair
      foreach {tmp distanceList} [array get HBONDS $name] break
      set minDistance [lindex [lsort -real $distanceList] 0]

      # print to output file
      puts $outfile [format "%-5d %5d %3s - %5d %3s - %7.2f" $i $residA $resnameA $residB $resnameB $minDistance]
#      puts  [format "%-5d %5d %3s - %5d %3s - %7.2f" $i $residA $resnameA $residB $resnameB $minDistance]
      flush $outfile

      # store all contacts for residue pair (whole trajectory)
      lappend HB_TABLE($residA,$residB) $minDistance
    }
#-------------------------------------------------#
    # delete the contact table - will be created again in the next loop
    if {[info exists HBONDS]} {
      unset HBONDS
    }
#------------------------------------------------#
  }
#------------------------------------------------#
puts "\n\n Resid Resname Resid Resname Occupancy(%) \n===========================================\n"
  foreach name [array names HB_TABLE] {
    foreach {residA residB} [split $name ,] break
    foreach {tmp resnameA} [split [array get mapResidResname $residA] ] break
    foreach {tmp resnameB} [split [array get mapResidResname $residB] ] break
    set frames [llength $HB_TABLE($name)]
    set percentage [expr 100.0 * $frames / ($nf-$inf)]
#    puts $outfile [format "%5d %3s - %5d %3s - %6.1f %% (%d frame(s))" $residA $resnameA $residB $resnameB $percentage $frames]
    puts $outfile [format "%5d %3s - %5d %3s - %6.1f %% " $residA $resnameA $residB $resnameB $percentage ]
    puts  [format "%5d  %4s - %5d  %4s  -  %6.1f %% " $residA $resnameA $residB $resnameB $percentage ]
    flush $outfile
  }
#-----------------------------------------------#
  # close output files
  close $outfile
#  puts "done"
puts "\n\n\n\n     $***********    ANJI BABU KAPAKAYALA    ************$\n\n"
} 
#========================SAVE PDB==========================================================#
#SAVE PDB
#
# USAGE    : save_pdb atomselection start_frame end_frame stride molid filename
#
# EXAMPLE  : save_pdb "protein" 5 100 5 top file.pdb
# Above example , It will write file.pdb for "protein" from frame 5 to 100 by skipping every 5 frames.
#
#
proc save_pdb { sel inf nf stride molid filenam } {
#---------Print Input
 puts " \n\n Given Input  :\n-----------------\n"
 puts "  Atomselection  : $sel "
 puts "  Start frame    : $inf "
 puts "  End frame      : $nf"
 puts "  Stride         : $stride"
 puts "  molid          : $molid"
 puts "  Filename       : $filenam\n\n"
#--------------------#
set sel1 [atomselect $molid "$sel"]
#------saving coordinates as pdb
 animate write pdb $filenam beg $inf end $nf skip $stride sel $sel1
#--------------------#
puts  " \n\n $filenam has been written successfully."
puts  "\n\n\n\n\n             $***************     ANJI BABU KAPAKAYALA     ***************$\n\n"
 }
#
#=========================SAVE COORDINATES========================================================#
# SAVE COORDINATES
#
# USAGE    : save_coordinates atomselection molid  filename filetype  tart_frame end_frame stride
#
# EXAMPLE  : save_coordinates "protein"  top file.mol2 mol2 5 100 5
# EXAMPLE2  : save_coordinates "protein"  top file.gro gro 5 100 5
# Above example , writes filename.mol2 for "protein" from frame 5 to 100 by skipping every 5 frames.
# Above example2 , writes filename.gro for "protein" from frame 5 to 100 by skipping every 5 frames.
#
proc save_coordinates { sel molid filenam filetype  inf nf stride } {
#---------Print Input
 puts " \n\n Given Input  :\n-----------------\n"
 puts "  Atomselection  : $sel "
 puts "  Start frame    : $inf "
 puts "  End frame      : $nf"
 puts "  Stride         : $stride"
 puts "  molid          : $molid"
 puts "  Filename       : $filenam"
 puts "  Filetype       : $filetype\n\n"
#--------------------#
set sel1 [atomselect $molid "$sel"]
#------saving coordinates as pdb
 animate write $filetype $filenam beg $inf end $nf skip $stride sel $sel1
#---------
puts  " \n\n $filenam has been written successfully."
puts  "\n\n\n\n\n             $***************     ANJI BABU KAPAKAYALA     ***************$\n\n"
 }
#===============RENDER IMAGE ===========================#
#Render Image by using Tachyon  
#
# save_image :
# UASAGE     : save_image filename
# EXAMPLE    : save_image my_image
# ( extension of file not required )
# 
#
proc save_image { filname } {
set molid top
set imagename  "$filname.dat"
set name [molinfo $molid get name]
set current_frame [molinfo $molid get frame]
set oldbg [colorinfo category  Display Background ]
#color Display Background white
#mol modmaterial 1 0 AOShiny
#mol modmaterial 2 0 AOChalky
#mol modcolor 2 0 name
#mol modstyle 2 0 Licorice
puts "\n\n rendering : $name\n\n"
render Tachyon $imagename  tachyon -aasamples 4 -trans_vmd -mediumshade %s  format TARGA -o %s.tga
#exec convert $imagename.tga $imagename.ps
exec convert $imagename.tga $filname.jpg
puts " \n Rendering completed."
puts " \n\n Image files :\n ------------\n "
puts "  $imagename"
puts "  $imagename.tga"
puts "  $filname.jpg"
#color Display Background $oldbg
puts "\n\n\n   $**********   ANJI BABU KAPAKAYALA   *********$\n"
}
#===============RENDER MOVIE ================================#
# RENDER MOVIE GIF FORMAT
#
# USAGE   : save_movie molid filename
#(no extension of filename is required )
# EXAMPLE : save_movie top my_protein
#example2 : save_movie 1 drug_protein
# OUTPUT  : It genarates filename.gif file
#
proc save_movie  {molid filname args} {
set numframes [molinfo $molid get numframes ]
# n : end frame
# t : starting frame
#----------setting up frames------------------------------------------#
  if {[llength $args] == 0} {
    set inf 0
    set n $numframes
  }
  if {[llength $args] == 1} {
    set inf [lindex $args 0]
    set n $numframes
    if {$inf < 0} {
      puts "illegal value of startframe, changing to 0"
      set inf 0
    }
  }
  if {[llength $args] > 1} {
    set inf [lindex $args 0]
    set n [lindex $args 1]
    if {$inf < 0} {
      puts "illegal value of startframe, changing to 0"
      set inf 0
    }
    if {$n > $numframes} {
      puts "illegal value of endframe, changing to $numframes"
      set inf 0
    }
  }
  set totframes [expr $n - $inf ]
puts " \n number of frames: $numframes\n\n"
  puts "analysis will be performed on $inf to $n frame(s) " 
#-------------------------------------------------------------------------#
set file [molinfo $molid get name]
puts " rendering\n"
#-------saving old background color and changing to white
set oldbg [colorinfo category Display Background ]
color Display Background white
#-----------------------------------------------------------------------#
for {set t $inf ; set d 1 } {$t < $n} {incr t ; incr d} {
animate goto $t
#puts "rendering frame: $t"
# show activity
    if { [expr $d % 10] == 0 } {
#doble (number) gives floating point
     set percentage [expr double($d)/double($totframes -1)*100]
#int(number) gives intger
      puts -nonewline " [expr int($percentage)] %     "
   if { [expr $d % 500] == 0 } { puts " " }
    flush stdout
   }
#--------rendering
#render Tachyon $molec$t tachyon -aasamples 4 -trans_vmd -mediumshade %s format TARGA -o %s.tga
render snapshot $filname.$t.ppm
#-------------------------------------------------------------------------#
}
puts " \n\n rendering completed. \n"
#------setting back old background color
#color Display Background $oldbg
color Display Background $oldbg
#-------converting to gif format
puts " \n\n Converting frames to animated GIF format"
puts " \n\n Please wait..."
#-------status bar
#for {set d 1 } {$d <= 100 } {incr d} {
#exec -delay 20
#if { [expr $d % 10] == 0} {
#puts -nonewline "."
#}
#   if { [expr $d % 500] == 0 } { puts " " }
#    flush stdout
# }
#------ status bar over
exec convert -delay 4.17 -loop 4 $filname.*.ppm  $filname.gif
#-------deleteing all image files
#file delete  {*} [glob *.ppm]
eval file delete [glob *.ppm* ]
puts " \n\n $filname.gif has created successfully.\n\n"
puts " \n\n  $***********    ANJI BABU KAPKAYALA     ***********$\n\n"
}
#
#==========================++SASA=============================
# TCL script Measuring Solvent Accessible Surface Area (SASA) 
#
# USAGE   : sasa "SELCTION"
# EXAMPLE : sasa "resid 170 to 180"
# OUTPUT  : SASA.dat
#
proc sasa {sel} {
#puts -nonewline "\n \t \t Selection: "
#gets stdin selmode
# selection
set output [open "SASA.dat" w]
set n [molinfo top get numframes]
puts $output "\n Total Frames found : $n \n"
set sum 0
for {set i 0} {$i <= $n} {incr i} {
set selA [atomselect top $sel frame $i] 
set protein [atomselect top "protein" frame $i]
# sasa calculation loop
#	molinfo top set frame $i
	set sasa [measure sasa 1.4 $protein -restrict $selA]
       	puts $output [format " %5d   %7.2f" $i $sasa]
        puts [format "%5d SASA : %7.2f" $i  $sasa]
        set sum [expr $sum + $sasa ]
}
#-----------Avg over trajectory
set avg_sasa [expr $sum/$n]
        puts [format "\n Avg. Solvent Accessible Surface Area : %7.2f\n" $avg_sasa ]
        puts $output [format "\n Avg. Solvent Accessible Surface Area : %7.2f\n" $avg_sasa ]
        puts "Done."	
close $output
}
#=====================================CLUSTERING ANALYSIS=====================
# TCL VMD SCRIPT TO DO CLUSTER ANALYSIS
#
# Authour : ANJI BABU KAPAKYALA
#           IIT KANPUR, INDIA.
#           (anjibabu480@gmail.com)
# 
# PURPOSE   : To do cluster analysis 
# USAGE     : source clustering.tcl in VMD Tk console.
#           : clustering {Atomselection} {rmsd_cutoff} {step size} {frame_args}
#
# Arguments :
# Atomselect:  Any atom selection
# rmsd_cutoff : RMSD cutoff 
# Step_size :   STEP SIZE ( nothing but skip)
# frame_args: Initial & final frame numbers
# Default Arguments : 
# Dist_func : Distance Function is set to rmsd as default.
# num       : No. of Clusters are fixed to default vaule 3
#
# EXAMPLES  :
# EXAMPLE1  : clustering "(protein) and backbone" 1.0 2 
# EXAMPLE2  : clustering "(protein) and backbone" 1.0 2 5
# EXAMPLE3  : clustering "(protein) and backbone" 1.0 2 5 25
# Example1, measures the clusters of given selections with rmsd cutoff 1.0 and step size 2 for zeroth frame to final frame in trajectory.
# Example2, measures the clusters of given selections with rmsd cutoff 1.0 and step size 2 from frame 5 to final frame in trajectory.
# Example3, measures the clusters of given selections with rmsd cutoff 1.0 and step size 2 from frame 5 to frame 25 in trajectory.
#  (At present No. of clusters are fixed to 3)
#  Default  Distance function is rmsd. but you can change to fitrmsd or rgyd or rmsd
#
#
#
proc clustering {sel1 rcutoff step_size args } {
#=====================
#puts -nonewline "\nEnter Your Selction :"
#flush stdout
#gets stdin sel
#puts "$sel"
#-----default number of clusters
set number 3
#---------------------------------------#
set nframes [molinfo top get numframes]
#---------------Opening OUTPUT files
set file1 [open "CLUSTER-A.xyz" w]
set file2 [open "CLUSTER-B.xyz" w]
set file3 [open "CLUSTER-C.xyz" w]
set file4 [open "UNCLUSTER.xyz" w]
#---------------Settingup arguments----#
  set sel $sel1
  set selA [atomselect top $sel ]
#---------------frames details----------#
  if {[llength $args] == 0} {
      set inf 0
      set nf $nframes
}
 if {[llength $args] == 1} {
    set inf [lindex $args 0]
    set nf $nframes
  }
  if {[llength $args] > 1} {
    set inf [lindex $args 0]
    set nf [lindex $args 1]
    }
#------------------total frames---------#
  set totframes [expr $nf - 1 ]
#------------------PRINT Given DATA-----#
 puts " \n \t  \t  WELCOME TO CLUSTERING ANALYSIS PLUGIN "
 puts "    \t  \t  =====================================\n\n"
 puts " \n No. of frames Found in Trajectory: $nframes\n\n"
 puts " Given Data :\n =============\n"
 puts " Atomselection     : $sel1 "
 puts " Distance Function : rmsd (default) "
 puts " No. of clusters   : 3    (default) "
 puts " Rmsd Cutoff       : $rcutoff      "
 puts " Step size         : $step_size "
 puts " Starting Frame    : $inf "
 puts " End Frame         : $nf \n"
 puts " Analysis will be performed on $inf to $nframes frame(s) \n\n\n"
#------------------------------------------#
  # Cluster
  #set result [measure cluster $selA num $number cutoff $rmsdcutoff first 0 last $totframes  step 2 distfunc rmsd ]
#selupdate $calc_selupdate weight $calc_weight]
#  set nclusters [llength $result]
#  puts "$nclusters"
#----------------------------------------
# foreach {listA listB listC listD} [measure cluster $selA num $number cutoff $rmsdcutoff first $inf last $totframes  step 1 distfunc rmsd ] break
 foreach {listA listB listC listD} [measure cluster $selA num $number cutoff $rcutoff first $inf last $totframes  step $step_size distfunc rmsd ] break
    set nclustera [llength $listA] ; set nclusterb [llength $listB] ; set nclusterc [llength $listC] ; set nclusterd [llength $listD]
 puts " CLUSTER-A ($nclustera) :\n $listA \n\n CLUSTER-B ($nclusterb)  :\n $listB \n\n CLUSTER-C ($nclusterc)  :\n $listC \n\n UNCLUSTRED ($nclusterd) : \n $listD\n"
#-----------------------------------------------
# update on graphical representation of the above clusters
#------ListA
menu graphics on
#mol delrep replica_number Mol_number
mol delrep 0 0
mol delrep 0 0
mol delrep 0 0
mol delrep 0 0
mol representation lines
mol selection $sel
mol addrep 0
mol drawframes 0 0 $listA
mol modcolor 0 0 ColorID 0
#------ListAB
mol representation lines
mol selection $sel
mol addrep 0
mol drawframes 0 1 $listB
mol modcolor 1 0 ColorID 1
#------ListC
mol representation lines
mol selection $sel
mol addrep 0
mol drawframes 0 2 $listC
mol modcolor 2 0 ColorID 4
#------ListD
mol representation lines
mol selection $sel
mol addrep 0
mol drawframes 0 3 $listD
mol modcolor 3 0 ColorID 7
mol showrep 0 2 0
mol showrep 0 0
#mol showrep 0 2 1
#mol showrep 0 2 0
#---------------WRITING OUTPUT----------------------------------------
puts " \n Writing OUTPUT files.........\n"
#--------------------Cycle starts
for {set i 0 ; set d 1} { $i<=$nframes} {incr i; incr d}  {
#------------------STATUS BAR
# show activity
#    if { [expr $d % 10] == 0 } {
#doble (number) gives floating point
     set percentage [expr double($d)*100/double($totframes )]
#int(number) gives intger
    if { [expr int($percentage) % 10 ] == 0 } {
      puts -nonewline " [expr int($percentage)] %     "
 flush stdout
     }
#   if { [expr $d % 500] == 0 } { puts " " }
#    flush stdout
#   }
#-------STORING CLUSTER-A
  foreach list1 $listA {
    if {$i == $list1 } {
#puts " Writing CLUSTER-A.xyz :$i"
#puts "$i : $list1 "
#set selA [atomselect top $sel frame $i ]
[atomselect top "all" frame $i] writexyz cluster$i.xyz
exec cat cluster$i.xyz >> CLUSTER-A.xyz
exec rm cluster$i.xyz
}
}
#-------STORING CLUSTER-B
  foreach list2 $listB {
    if {$i == $list2 } {
#puts "$i : $list2 "
#puts " Writing CLUSTER-B.xyz :$i"
#set selA [atomselect top $sel frame $i ]
[atomselect top "all" frame $i] writexyz cluster$i.xyz
exec cat cluster$i.xyz >> CLUSTER-B.xyz
exec rm cluster$i.xyz
}
}
#-------STORING CLUSTER-C
  foreach list3 $listC {
    if {$i == $list3 } {
#puts "$i : $list3 "
#puts " Writing CLUSTER-C.xyz :$i"
#set selA [atomselect top $sel frame $i ]
[atomselect top "all" frame $i] writexyz cluster$i.xyz
exec cat cluster$i.xyz >> CLUSTER-C.xyz
exec rm cluster$i.xyz
}
}
#-------STORING UN CLUSTER-D
  foreach list4 $listD {
    if {$i == $list4 } {
#puts "$i : $list4 "
#puts " Writing UNCLUSTER.xyz :$i"
#set selA [atomselect top $sel frame $i ]
[atomselect top "all" frame $i] writexyz cluster$i.xyz
exec cat cluster$i.xyz >> UNCLUSTER.xyz
exec rm cluster$i.xyz
}
}
}
close $file1
close $file2
close $file3
close $file4
#-----------Printing OUTPUT files
puts " \n\n OUTPUT files :\n---------------\n"
puts " \n CLUSTER-A.xyz\n CLUSTER-B.xyz\n CLUSTER-C.xyz \n UNCLUSTER.xyz \n"

#
puts "\n\n\n \t  \t $********** ANJI BABU KAPAKAYALA **********$\n\n\n"
}

#=========================MY COMMAND LIST============================
proc my_commands {} {
puts "\n  COMMANDS   :\n=============== \n"
puts "  --help"
puts "  align "
puts "  angle"
puts "  clustering"
puts "  contact_map"
puts "  count_waters"
puts "  count_hbonds"
puts "  details"
puts "  dihedral"
puts "  distance"
puts "  HB_occupancy"
puts "  pbc_box"
puts "  rmsd"
puts "  save_coordinates"
puts "  save_image "
puts "  save_movie"
puts "  save_pdb  "
puts "  sasa"
puts "  show_hbonds"
puts "  show_interactions"
puts "  show_residues"
puts "  bgcolor"
puts "  \nFuture updates :\n=============\n "
puts "  wrap_pbc"
puts "  ramachandran_plot "
puts "  HB_plot     "
puts "  save_vmd  "
puts "  delete_frame"
puts "  Radial Pair Distribution Function g(r) "
puts "  Histogram for given set of data"
puts " \n\n To Know details of command check :  --help command \n"
puts "\n\n $********** ANJI BABU KAPKAYALA **********$  \n\n"
#
}
#
#========================================HELP COMMAND=========================
proc --help {command} {
puts " \n\n COMMAND NAME : $command\n========================\n\n"
  if { "my_commands" == $command}  {
puts " Prints the available commands from Easy Console Tool\n written by Anji Babu Kapakayala.\n"
} elseif { "distance" == $command}  {
#set d distance
puts " PURPOSE : Measures Distance, Avg Distance & std for any given 2 atoms\n"
puts " USAGE    : distance sel1 sel2 <initial-frame> <end-frame> <-show_plot>\n\n"
puts " Example  : distance \"serial 3418\" \"serial 3415\""
puts " Example  : distance \"serial 3418\" \"serial 3415\" 100 2000"
puts " Example  : distance \"serial 3418\" \"serial 3415\" -show_plot"
puts " Example  : distance \"serial 3418\" \"serial 3415\" 10 1000 -show_plot\n"
puts " OUTPUT   : Stores data in DISTANCE.xvg and dist.png files."

} elseif { "align" == $command}  {
puts " PUPOSE    : Aligns molecules corresponding to given  molid1 & molid2 \n\n"
puts " USAGE     : align molid1 molid2 \n\n"
puts " example   : align 0 1 "
} elseif { "rmsd" == $command } {
puts " PURPOSE  : Measures Avg.RMSD & std for given selection and molecules \n\n"
puts " USAGE    : rmsd {Atomselection} {molid1} {molid2} \n\n"
puts " EXAMPLE1 : rmsd 'backbone' 0  1 \n"
puts " EXAMPLE2 : rmsd 'protein' top top \n"
puts " OUTPUT   : Data will be stored in RMSD.dat file\n\n"
puts " IF both the molids are same , RMSD will be calculated by taking zeroth frame as reference \n"
} elseif { "angle" == $command } {
puts "  PURPOSE  : Measures Avg. angle & std  for any given 3 atoms \n\n"
puts "  USAGE    : angle sel1 sel2 sel3 \n\n"
puts "  example  : angle 'serial 3418' 'serial 3415' 'serial 3395' \n"
puts "  OUTPUT   : Data will be stored in ANGLE.dat file "
} elseif { "dihedral" == $command } {
puts " PURPOSE  : Measures Avg Dihedral angle & std  for any given 4 atoms \n\n "
puts " USAGE    : dihedral sel1 sel2 sel3 sel4 \n\n"
puts " example  : dihedral 'serial 3418' 'serial 3415' 'serial 3412' 'serial 3395' \n"
puts " example2 : dihedral 'index 3417' 'index 3414' 'index 3411' 'index 3394' \n"
puts " OUTPUT   : Data will be stored in DIHEDRAL.dat file"
} elseif { "show_residues" == $command } {
puts " PURPOSE  : Prints RESID and corresponding RESNAME for given selection and for selected frames \n\n"
puts " USAGE    : show_residues sel molid <initial frame> <end frame>\n\n"
puts "\n USAGE 2  : show_residues sel molid   (frame no. are optional) \n\n\n"
puts " EXAMPLES :\n=============\n"
puts " Example 1 : show_residues 'protein and basic' top "
puts "              It prints the residues from 0th frame only \n\n"
puts " example 1 : show_residues 'resid 170 to 180' 0  1 20\n\n"
puts " example 2 : show_residues '(not resname WAT) and within 3 of resid 235' 0 5 10 \n\n"
puts " example 3 : show_residuese 'protein and hydrophobic ' top  \n\n"
puts " OUTPUT   : Data will be stored in RESNAMES.dat file\n\n"
} elseif { "details" == $command } {
puts " PURPOSE  : Prints required details for given selection \n\n"
puts " USAGE    : details <system/selection> \n\n"
puts " Example  : details system "
puts " Example  : details \"resid 170\""
puts " Example  : details \"resid 170 to 180\""
} elseif { "count_waters" == $command } {
puts " PURPOSE  : Prints Avg. No of waters present around given selection \n\n"
puts " USAGE    : count_waters sel molid start_frame end_frame \n\n"
puts " example  : count_waters 'within 5 of resid 235' 0 5 10 \n"
puts " OUTPUT   : Dsta will be stored in NO-OF-WATERS.dat file"
} elseif {"pbc_box" == $command} {
puts " PURPOSE   : Sets or off or show the size of PBC BOX \n\n"
puts " USAGE     : pbc_box choice \n\n"
puts " Arguments : on off size \n"
puts " example   : pbc_box on \n"
puts " It will on the pbc box for current top molecule\n"
puts " example2  : pbc_box off "
puts " It will off the PBC box \n"
puts " example 3 : pbc_box size "
puts " It will show the size of BOX (values) "
} elseif {"show_interactions" == $command } {
puts " PURPOSE           : Prints Interactions between given two selections within given cutoff \n\n"
puts " USAGE             : show_interactions sel1 sel2 cutoff inf nf \n\n"
puts " example           : show_interactions 'protein' 'resid 235' 3.0 5 10\n\n"
puts " Arguments         :\n=================="
puts "    sel1           : Any given selction "
puts "    sel2           : Any given selction"
puts "    cutoff         : distance cutoff"
puts "   inf & nf        : Initial frame & Final framme"
puts "   OUTPUT          : stores all the information in INTERACTIONS.dat file"
} elseif {"contact_map" == $command} {
puts " PURPOSE       :  Measures all the contacts between given two selections and prints 1 if contact below cutoff , 0 (zero) otherwise \n\n"
puts " USAGE         :  contact_map ' sel1'  'sel2'  cutoff startframe endframe\n"
puts " Example       :  contact_map 'resid 1 to 50 and name CA' 'resid 51 to 100 and name CA' 6.0 0 10\n"
puts " OUTPUT        : stores all data in CONTACT_MAP.dat file \n\n"
puts " PLOTTING DATA : gnuplot >>  splot 'CONTACT_MAP.dat' u 1:2:3 w p notitle" 
puts "                 gnuplot >>  set view 0,0,1 "
puts "                 gnuplot >>  replot "
#
} elseif {"count_hbonds" == $command} {
puts "\n PURPOSE       : Measures No of HBonds between given two donor and acceptor selections within given cutoff and angle_cutoff\n\n"
puts " USAGE           : count_hbonds Donor_sel1  Acceptor_sel2  distance_cutoff angle_cutoff \n\n"
puts " EXAMPLE         : count_hbonds 'protein and name N' 'protein and name O' 3.0 30 \n\n"
puts " OUTPUT          : data will be store in HBONDS_COUNT.dat, Which contains Frame vs No.of Hbonds (You can plot this data as Frames v/s No. of Hbonds)\n"
} elseif  {"show_hbonds" == $command} {
puts "\n PURPOSE   : Prints the HBonds between given DONOR and ACCEPTOR selections within given distance & angle cutoff.\n\n"
puts "   USAGE     : show_hbonds  Donor_sel1 Acceptor_sel2 distance_cutoff angle_cutoff <initial frame>  <end frame> \n\n"
puts "   EXAMPLE   : show_hbonds 'protein and name N' 'protein and name O' 3.0 30 5 10 \n\n"
puts "    OUTPUT   : data will be store in HBONDS.dat.\n"
#
} elseif {"HB_occupancy" == $command} {
puts "\n PURPOSE :  Measures the HBONDS occupancy for given donor and acceptor selctions for selected frames. \n\n"
puts "  USAGE    : HB_occupancy \"sel1\" \"sel2\" <start_frame> <end_frame>\n\n"
puts "  EXAMPLE  : HB_occupancy \"protein\" \"resid 235\" 0 20\n"
puts "  EXAMPLE  : HB_occupancy \"protein\" \"resid 235\" \n"
puts "  EXAMPLE  : HB_occupancy \"protein\" \"resid 235\" 200\n"
puts "  ARGUMENTS     : \n===============\n"
puts "       SELECTION1      : ANY DONOR SELECTION "
puts "       SELECTION2      : ANY ACCEPTOR SELECTION"
puts "       DISTANCE_CUTOFF : Distance cutoff to measure HBonds, 3.00 Ang is fixed"
puts "       ANGLEE_CUTOFF   : Angle cutoff to measure HBonds, 30.0 degree is fixed"
puts "       START_FRAME     : Starting Frame Number (optional)"
puts "       END_FRAME       : End Frame Number (optional)\n"
#
} elseif {"save_pdb" == $command} {
puts "\n   PURPOSE : Writes pdb file for given options \n\n"
puts "   USAGE    : save_pdb {atomselection} {start_frame} {end_frame stride} {molid} {filename}\n\n"
puts "   EXAMPLE  : save_pdb 'protein' 5 100 5 top file.pdb \n"
puts "   Above example , It will write file.pdb for 'protein' from frame 5 to 100 by skipping every 5 frames. \n\n\n"
} elseif {"save_coordinates" ==  $command} {
puts "\n   PURPOSE : Saves coordinates for given arguments \n\n"
 puts "   USAGE    : save_coordinates {atomselection} {molid}  {filename} {filetype}{start_frame} {end_frame stride} \n\n"
 puts "   Atomselection  : Any slection"
 puts "   Start frame    : From which frame to save coordinates"
 puts "   End frame      : To which frame to save coordinates"
 puts "   Stride         : After how many frames you want save (skipping)"
 puts "   molid          : Which molecule you want save"
 puts "   Filename       : Filename with extension"
 puts "   Filetype       : Which format you want to save. \n\n\n"
 puts "   Filetypes Available  : ABINIT , bgf, binpos, crd, crdbox, dcd, gro, trr, js, lammpstrj, mol2,"
 puts "                          namdbin, pdb, pqr, rst7,POSCAR, xbgf, xyz, dtr, mae, dms, hoomd \n\n"
 puts "   EXAMPLES       : \n\n"
 puts "   EXAMPLE1  : save_coordinates 'protein'  top file.mol2 mol2 5 100 5"
 puts "   EXAMPLE2  : save_coordinates 'protein'  top file.gro gro 5 100 5\n\n\n"
 puts "   In example1 , writes filename.mol2 for 'protein' from frame 5 to 100 by skipping every 5 frames."
 puts "   In example2 , writes filename.gro for 'protein' from frame 5 to 100 by skipping every 5 frames."
#
} elseif {"save_image" == $command } {
puts "    PURPOSE    : Rendering image of currently active frame of molid 0 or top.\n\n"
puts "    UASAGE     : save_image filename \n\n"
puts "    EXAMPLE    : save_image my_image \n"
puts "     ( extension of file not required ) \n\n"
puts "    OUTPUT     : Generates three files." 
puts "                : filename.dat"
puts "                : filename.dat.tga"
puts "                : filename.jpg\n"
} elseif {"save_movie" == $command} {
puts "\n   PURPOSE  : RENDER MOVIE IN  GIF FORMAT FOR GIVEN MOLID \n\n"
puts "   USAGE    : save_movie molid filename inf nf"
puts "   (no extension of filename is required ) \n"
puts "   starting frame and end frame are optional\n\n "
puts "   EXAMPLE  : save_movie top my_protein "
puts "   EXAMPLE 2: save_movie 1 drug_protein 5 20 \n "
puts "   OUTPUT   : Genarates filename.gif file \n\n"
puts "   (In above example it genarates my_protein.gif file from frame 0 to end frame)\n\n"
puts "   (In above example 2 it genarates drug_protein.gif file from frame 5 to 20th  frame)\n\n"
#
} elseif {"sasa" == $command} {
puts "\n TCL script Measuring Solvent Accessible Surface Area (SASA) \n"
puts " USAGE   : sasa 'SELCTION'\n"
puts " EXAMPLE : sasa 'resid 170 to 180' \n"
puts " OUTPUT  : SASA.dat \n"
#
} elseif {"clustering" == $command} {
puts "\n PURPOSE   : To do cluster analysis \n\n"
puts " USAGE     : clustering {Atomselection} {rmsd_cutoff} {step size} {frame_args} \n\n"
puts "  Arguments : \n============\n"
puts "  Atomselect  :  Any atom selection "
puts "  rmsd_cutoff : RMSD cutoff "
puts "  Step_size   :   STEP SIZE ( nothing but skip)"
puts "  frame_args  : Initial & final frame numbers \n\n"
puts " Default Arguments : \n"
puts " Dist_func : Distance Function is set to rmsd as default."
puts " num       : No. of Clusters are fixed to default vaule 3\n\n"
puts " EXAMPLES  :\n==============\n "
puts " EXAMPLE1  : clustering '(protein) and backbone' 1.0 2 "
puts " EXAMPLE2  : clustering '(protein) and backbone' 1.0 2 5"
puts " EXAMPLE3  : clustering '(protein) and backbone' 1.0 2 5 25\n\n"
puts " Example1, measures the clusters of given selections with rmsd cutoff 1.0 and "
puts "           step size 2 for zeroth frame to final frame in trajectory.\n"
puts " Example2, measures the clusters of given selections with rmsd cutoff 1.0 and "
puts "           step size 2 from frame 5 to final frame in trajectory.\n"
puts " Example3, measures the clusters of given selections with rmsd cutoff 1.0 and "
puts "           step size 2 from frame 5 to frame 25 in trajectory.\n"
puts "  (At present No. of clusters are fixed to 3) "
puts "  Default  Distance function is rmsd. but you can change to fitrmsd or rgyd or rmsd"
puts " \n OUTPUT Files :\n============\n"
Puts " Generates 4 output files."
puts " CLUSTER-A.xyz\n CLUSTER-B.xyz\n CLUSTER-C.xyz\n UNCLUSTER.xyz "
} elseif {"bgcolor" == $command} {
puts "\n PURPOSE   : To change Background color of Display\n"
puts " USAGE     : bgcolor <color> \n\n"
puts " EXAMPLE    : bgcolor white \n\n"

#
} else  { puts " Command  Not Found " }
puts "\n\n \n    $************* ANJI BABU KAPAKAYALA *************$\n\n"
}
#
# Added these procedures o\after Oct 2021
#===============Change Background color ===========================#
#
# bgcolor :
# UASAGE     : bgcolor <color>
# EXAMPLE    : bgcolor white
#
#
proc bgcolor { choice } {
color Display Background $choice
puts "\n\n Backgroung color changed to $choice\n\n"
puts "\n\n\n   $**********   ANJI BABU KAPAKAYALA   *********$\n"
}
#==================================================================================#
#                    Written By ANJI BABU KAPAKAYALA                               #
#==================================================================================#
