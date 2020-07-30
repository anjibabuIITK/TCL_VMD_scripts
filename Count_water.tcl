#Tcl VMD script to calculate number of waters present within 5 A of given resid
#
# Authour : KAPAKAYALA ANJI BABU
#           IIT KANPUR, INDIA
#
# USAGE   : Open VMD /Extensions/Tkconsile  then source get_no_of_waters.tcl
#
set outfile [open "no-of-waters.dat" w ]
#    set waters [ atomselect top "(within 10 of resid 233 232 234 79 81 83 148 167 290) and resname WAT and type O" ]
    set waters [ atomselect top "(within 10 of resid 235) and resname WAT and type O" ]
#    set resids [$waters get { resname resid }  ]
#     set numofwaters [$waters get type ]
    set nw [ $waters get serial ] 
#    set unique [lsort -unique $nw]
#    puts $unique
  puts $outfile $nw
close $outfile
#==============================================================================#
#               Written By ANJI BABU KAPAKAYALA                                #
#==============================================================================#
