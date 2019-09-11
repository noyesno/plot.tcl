
proc read_command {sock gnuplot} {
  set size [gets $sock]
  if {[string is integer -strict $size]} {
    set command [read $sock $size]
    gets $sock
  } else {
    set command $size
  }

  if {$command ne ""} {
    puts $command
    flush stdout
    puts $gnuplot $command
    flush $gnuplot
  }
}

proc accept {sock args} {
  fconfigure $sock -blocking 0

  set gnuplot [open "| gnuplot " "w"]
  fileevent $sock readable [list read_command $sock $gnuplot]
  
}

socket -server accept 8088

vwait forever
