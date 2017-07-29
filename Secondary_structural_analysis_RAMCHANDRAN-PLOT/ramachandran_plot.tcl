# TCL VMD Script to analyse secondary structure of given protein.
# Based on ramachandran plot. PSI v/s PHI
#
# Authour   : ANJI BABU KAPAKAYALA
#           : IIT KANPUR, INDIA.
#           : ( anjibabu480@gmail.com)
#
# PURPOSE   : This script will print Amount of ALPHA HELIX and BEETA SHEETS percentages
#             for given Atom selection and frame intervals of loaded trajectory.
# USAGE     : rama_analysis {ATOMSELECTION} {FRAME ARGUMENTS}
# ARGUMENTS : 
# Atom Selection  : For any given Atomselection 
# Frame Arguments : Starting & End frame numbers (optional)
#
# EXAMPLE 1 : rama_analysis "backbone" 
# EXAMPLE 2 : rama_analysis "protein" 5
# EXAMPLE 3 : rama_analysis "alpha_helix" 5 25
# EXAMPLE 4 : rama_analysis "beetasheet" 50
#
# EXAMPLE1 , Prints the secondary srtucture information of backbone from zeroth frame to end frame
#            available in trajectory
#
# EXAMPLE2, Prints the secondary srtucture information of protein from 5th frame to end frame

# EXAMPLE3, Prints the secondary srtucture information of selction alpha helix from 5th frame to 25th frame.
#
# EXAMPLE4, Prints the secondary srtucture information of selction betaa sheet from 50th frame to end frame.
#
# OUTPUT      : Stores PHI and PSI values in file PSIPHI.dat.
#             : Stores Alpha helix percentage fluctuations with time in A_HELIX-fluctuation.dat.
#             : Stores Beta Sheet  percentage fluctuations with time in B_Sheet-fluctuation.dat.
#
# PLotting    : gnuplot plot.gnp 
#             : gnuplot A_helix.gnp
#             : gnuplot B_sheet.gnp
# OUTPUT_PLOT : rama_plot.eps ( Ramachandran plot)
#             : A_helix.eps & B_sheet.eps
#
#
proc rama_analysis {sel1 args } {
#puts -nonewline " Enter Selection: "
#flush stdout
#gets stdin sel1
set outfile [open "PSIPHI.dat" w ]
set outfile1 [open "A_HELIX-fluctuation.dat" w ]
set outfile2 [open "B_Sheet-fluctuation.dat" w ]
set sel [atomselect top $sel1 ]
set numframes [molinfo top get numframes ]
# create a selection from all protein C-alpha atoms of 
# sanity check(s).
    set a [$sel num]
    if { $a < 1} {
        puts "no atoms in selection"
        return
    }
    set n [molinfo [$sel molid] get numframes]
    if {$n < 1} {
        puts "no coordinate data available"
        return
    }
#-------------------------------
  if {[llength $args] == 0} {
    set inf 0
    set nf $numframes
  }
  if {[llength $args] == 1} {
    set inf [lindex $args 0]
    set nf $numframes
  }
  if {[llength $args] > 1} {
    set inf [lindex $args 0]
    set nf [lindex $args 1]
  }
  set totframes [expr $nf - $inf + 1]
#----------PRINTING GIVEN INPUT DATA------_#
puts " \nTotal frames found : $numframes \n"
puts " Given Input :\n ============\n"
puts "  Atom selection : $sel1 "
puts "  Starting Frame : $inf "
puts "  End Frame      : $nf \n"
puts " \n Analysis will be performed on $totframes frame(s) ($inf to $nf)"
#-----------#
# Total no of didrals
set nn [llength [$sel get {phi psi}]]
#puts "total dihedrals :$nn\n\n"
set sumh 0 ;set sumb 0
#---------Cycle starts
    for {set i $inf } { $i < $totframes } { incr i } {
        $sel frame $i
        $sel update
set m 0 ;set B 0
#puts " Frame : $i \n\n"
        foreach a [$sel get {phi psi}] {
            set phi [lindex $a 0]
            set psi [lindex $a 1]
puts $outfile [format "%7.2f    %7.2f"  $phi $psi ]
#puts [format "%7.2f    %7.2f" $psi $phi ] 
#----------- ALPHA HELIX ----------------#
#counting alpha helix dihedrals phi and psi  
# FOR ALPHA HELIX  -80.00 <= PHI <= -48.0 and -59.0= PSI -27.0
         if { $phi >= -80.00 && $phi <= -48.00 } {
          if { $psi >= -59.00 && $psi <= -27.00 } {
#puts [ format "%7.2f  %7.2f" $psi $phi]
set m [expr $m +1]
}  
}
#------------------BETA SHEETS------------#
#counting beta sheet or strand dihedrals phi and psi  
#For Beta strands -150.0 <= PHI -90.0 and 90.0 <= PSI <= 150.0
         if { $phi >= -150.00 && $phi <= -90.00 } {
          if { $psi >= 90.00 && $psi <= 150.00 } {
#puts [ format "%7.2f  %7.2f" $psi $phi]
set B [expr $B +1]
}  
}
#
 }

#puts  "ALPHA: $m"
#puts "BETA :$B"

#----ALPHA HELIX
set alpha_helix [expr double($m)/double($nn)*100.00]
#puts [format " Alpha_helix : %7.2f %% " $alpha_helix ]
puts $outfile1 [format " %5d  %7.2f " $i $alpha_helix ]
#----BETA SHEETS
set beta_sheet [expr double($B)/double($nn)*100.00]
#puts [format " Beta_sheet  : %7.2f %% " $beta_sheet ]
puts $outfile2 [format " %5d  %7.2f " $i $beta_sheet ]
#---------PRINTING OUT PUT---------------#
#puts " Data has stored in PSIPHI.dat \n\n\n"
#puts " Secondary Structure Analysis : \n\n"
#puts [format " Alpha_helix : %7.2f %% \n" $alpha_helix ]
#puts [format " Beta_sheet  : %7.2f %% \n" $beta_sheet ]
set sumh [expr $sumh+$alpha_helix]
set sumb [expr $sumb+$beta_sheet ] 
}
#------Averaging over frames
set Avg_alpha [expr $sumh/$totframes ]
set Avg_beta [expr $sumb/$totframes ]
puts " \n\n\n Secondary Structure Analysis : \n\n"
puts [format " Avg. Alpha Helix  : %7.2f %% \n "  $Avg_alpha ]
puts [format " Avg. Beta Strands : %7.2f %% \n\n\n "  $Avg_beta ]
puts " OUTPUTS : Psi v/s Phi data has been stored in PSIPHI.dat"
puts "           Time v/s alpha_helix percentage has stored in A_HELIX-fluctuation.dat "
puts "           Time v/s betasheet percentage has stored in B_Sheet-fluctuation.dat \n"
puts " \n\n   $************  ANJI BABU KAPAKAYALA  *************$\n\n"
#--------------Cycle Ends ----------------#
close $outfile
close $outfile1
close $outfile2
}
#END
#=================================================================================#
#                 Written By   ANJI BABU KAPKAYALA                                #
#=================================================================================#



