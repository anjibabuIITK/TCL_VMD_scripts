#Tcl VMD script to print the residues within 10 A of given resid
#
# Authour : KAPAKAYALA ANJI BABU
#           IIT KANPUR, INDIA
#
# USAGE   : Open VMD /Extensions/Tkconsile  then source Print_Residues_within_selection.tcl
#
set outfile [open "Residues.dat" w ]
    set residues [ atomselect top "(within 10 of resid 232) and type CA" ]
    set resids [$residues get { resname resid }  ]
puts ""
puts "Residues within 10A of given selection"
puts ""
foreach a $resids {
  puts $a
  puts $outfile $a
}

close $outfile
#==============================================================================#
#               Written By ANJI BABU KAPAKAYALA                                #
#==============================================================================#
