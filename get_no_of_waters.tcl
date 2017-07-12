#Tcl VMD script to calculate number of waters present within 5 A of given resid
#
# Authour : KAPAKAYALA ANJI BABU
#           IIT KANPUR, INDIA
#
# USAGE   : Open VMD /Extensions/Tkconsile  then source get_no_of_waters.tcl
#
set outfile [open "no-of-waters.dat" w ]
set n [ molinfo top get numframes ]
set sum 0  
puts $outfile  " No of frames found are : $n "
for {set i 0} {$i <= $n } {incr i} {
    set waters [ atomselect top "(within 5 of resid 235 ) and resname WAT and type O" frame $i ]
#    set resids [$waters get { resname resid }  ]
#     set numofwaters [$waters get type ]
    set nw [ $waters get type ] 
    set unique [lsort -unique $nw]
#    puts $unique
    foreach f $unique {
        set cnt 0
        foreach item $nw {
        if {$item == $f} {
            incr cnt
#        set sum [expr $cnt+$cnt]
        }
    }
#    puts "$f :: $cnt"
     set sum2 [ expr $sum + $cnt ]
     set sum $sum2
   }
    puts $outfile " $i \t $cnt"
   }
#  puts $sum
#  puts $i
  set avg [ expr $sum/$i ]
  puts "Total No. of frames    : $i   "
  puts "The Avg. No. of Waters : $avg "
  puts "================================="
  puts "Written by ANJI BABU KAPAKAYALA "
  puts "================================="
  puts $outfile "Total No. of frames    : $i   "
  puts $outfile "The Avg. No. of Waters : $avg "
  puts $outfile "================================="
  puts $outfile "Written by ANJI BABU KAPAKAYALA "
  puts $outfile "================================="
close $outfile
#==============================================================================#
#               Written By ANJI BABU KAPAKAYALA                                #
#==============================================================================#
