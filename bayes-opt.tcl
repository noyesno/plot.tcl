
proc plot_sample {n x_range y_range} {
  set dataset [list]
  
  lassign $x_range x_min x_max
  lassign $y_range y_min y_max

  for {
    set x    $x_min
    set step [expr {($x_max-$x_min)/($n-1)}]
  } {
    $n>0
  } {
    incr n -1 
    set x [expr {$x+$step}]
  } {
    set y [expr {rand()*10}]
    lappend dataset [list [format %.3f $x] $y]
  }

  return $dataset
}

set x_range {0.0 1.0} 
set y_range {-10.0 10.0} 
set n_sample 10

foreach idx {1 2 3 4 5} {
  set data($idx) [plot_sample $n_sample $x_range $y_range] 
}

set gnuplot [socket 127.0.0.1 8088]

puts $gnuplot "\$tcldata << EOD"
for {set i 0} {$i<$n_sample} {incr i} {
  set line [list]
  lappend line [lindex $data(1) $i 0]
  foreach idx {1 2 3 4 5} {
    lappend line [lindex $data($idx) $i 1]
  }
  puts $gnuplot $line
} 
puts $gnuplot "EOD"
puts $gnuplot "plot sin(x)"
flush $gnuplot

puts $gnuplot {
plot $tcldata using 1:2 with line , \
     $tcldata using 1:3 with line , \
     $tcldata using 1:4 with line , \
     $tcldata using 1:5 with line , \
     $tcldata using 1:6 with line 
}
flush $gnuplot
