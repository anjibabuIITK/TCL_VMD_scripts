mol new /home/anjibabu/ANJI/Codes_backup/Tcl-VMD_Scriping/TRAJECTORY/umb.gro type gro first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor all
mol addfile /home/anjibabu/ANJI/Codes_backup/Tcl-VMD_Scriping/TRAJECTORY/pbc.xtc type xtc first 0 last -1 step 20 filebonds 1 autobonds 1 waitfor all
mol delrep 0 top
mol representation Lines
#mol new umb.gro type gro first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor all
#mol addfile pbc.xtc type xtc first 0 last -1 step 20 filebonds 1 autobonds 1 waitfor all
set outfile [open e2e.dat w ]
set n [molinfo top get numframes] 
 for  {set i 1}  {$i< $n}  {incr i}  {
       set a [atomselect top "resid 20 and name CA" frame $i ] 
       set apos [ lindex [ $a get "x y z"] 0 ] 
      $a delete
      set b [atomselect top "resid 180 and name CA" frame $i ] 
      set bpos [ lindex [ $b get "x y z"]  0 ]
     $b delete 
     set e2e [ vecdist $apos $bpos ] 
    puts $outfile  "$i\t$e2e"
    }
   close $outfile
quit
#==================================#
# Written by ANJI BABU KAPKAYALA
#==================================#
