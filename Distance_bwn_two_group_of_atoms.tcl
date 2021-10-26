#----------------------------------------------------------------#
#  VMD TCL script to measure distances between two group of atoms.
#----------------------------------------------------------------#
#
set cutoff 3.0
set n [molinfo top get numframes ]
set outfile [open "DIST.dat" w]
#
set sel1 "name Si"
set sel2 "name O"
#
set all [atomselect top "all"]
set allname [$all get name ]
#=================CYCLE STARTS==============================
for {set i 0} {$i <= $n} {incr i} {
set selA [atomselect top $sel1 frame $i ]
set selB  [atomselect top $sel2 frame $i]
    set index_listA [$selA get index]
    set index_listB [$selB get index]
#--------------------------------------------#
 $all frame $i
 $all update
   set allpos [ $all get "x y z" ]
#--------------------------------------------#
       puts "\nFrame$i\n=======\n"
       puts $outfile "\nFrame$i\n=======\n"
       foreach indexA $index_listA {
                 foreach indexB $index_listB {
                 set posA [lindex $allpos  $indexA ]
                 set posB [lindex $allpos  $indexB ]
                 set nameA [lindex $allname  $indexA ]
                 set nameB [lindex $allname  $indexB ]
                 set disAB [vecdist $posA $posB ]
                  if {$disAB <= $cutoff } {
 puts " $i $nameA ($indexA) -- $nameB ($indexB) --->  $disAB"
 puts $outfile "$i $nameA ($indexA) -- $nameB ($indexB) --->  $disAB"
                  }
               }
      }     
}
close $outfile
#---------------------------------------------------------#
#   
#---------------------------------------------------------#

