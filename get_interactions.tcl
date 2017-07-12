#Tcl VMD script to get residues which are in  interaction with given selection
#
#Authour: ANJI BABU KAPAKAYALA
#         IIT KANPUR, INDIA.
#
set outfile [ open "interactions_list.dat" w ]
set n [molinfo top get numframes ]
#puts $n
for {set i 0} {$i <= $n } {incr i} {
#set sel [ atomselect top " not resname WAT and (within 3 of resid 235 ) " frame $i ]
set sel [ atomselect top " not resname WAT and (within 3 of serial 3417 3439 3416 3395 3412 3396 3429 3419 3397) and not resname MRP" frame $i ]
set intractions [ $sel get {resid resname} ]
#puts $outfile "$i $intractions "
#puts $intractions
set unique [lsort -unique $intractions ]
#puts "$i $unique "
foreach f $unique {
set cnt 0
foreach residue $intractions {
if {$residue == $f } {
incr cnt
}
}
puts $outfile "$i $f :: $cnt "
}
}
close $outfile
#==================================================#
#     Written by ANJI BABU KAPAKAYALA              #
#==================================================#
