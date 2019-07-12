# Adopted from BMMG group, Curtin University Prof. Ricardo Mancera
# Pretty handy script to calculate and update the secondary structure for a protein across a loaded trajectory.
# To use, load this script in the TK Console and then type "start_sscache". Simples.

proc reset_sscache {{molid top}} {
    global sscache_data
    if {! [string compare $molid top]} {
      set molid [molinfo top]
    }
    if [info exists sscache_data($molid)] {
        unset sscache_data
    }
}

# start the cache for a given molecule
proc start_sscache {{molid top}} {
    if {! [string compare $molid top]} {
      set molid [molinfo top]
    }
    global vmd_frame
    # set a trace to detect when an animation frame changes
    trace variable vmd_frame($molid) w sscache
    return
}

# remove the trace (need one stop for every start)
proc stop_sscache {{molid top}} {
    if {! [string compare $molid top]} {
      set molid [molinfo top]
    }
    global vmd_frame
    trace vdelete vmd_frame($molid) w sscache
    return
}


# when the frame changes, trace calls this function
proc sscache {name index op} {
    # name == vmd_frame
    # index == molecule id of the newly changed frame
    # op == w
    
    global sscache_data

    # get the protein CA atoms
    set sel [atomselect $index "protein name CA"]

    ## get the new frame number
    # Tcl doesn't yet have it, but VMD does ...
    set frame [molinfo $index get frame]

    # see if the ss data exists in the cache
    if [info exists sscache_data($index,$frame)] {
        $sel set structure $sscache_data($index,$frame)
        return
    }

    # doesn't exist, so (re)calculate it
    vmd_calculate_structure $index
    # save the data for next time
    set sscache_data($index,$frame) [$sel get structure]

    return
}

