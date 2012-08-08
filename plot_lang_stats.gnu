#!/usr/bin/gnuplot
# (C) Mason Larobina <mason.larobina@gmail.com>

reset
#set terminal wxt size 800,300 enhanced font 'Verdana,10' persist
set terminal tikz color solid size 14.5cm,6.5cm
set output 'langstats.tex'

set xdata time
set timefmt "%Y-%m-%d"
set yrange [ 0 : 300 ]
set xrange [ "2009-06-15" : "2012-08-20" ]

set title "My Averaged Daily Open Source Contributions By Language (2009 -- Present)"
set ylabel "Lines Changed"
#set xlabel "Date"

set format x "$%m/%Y$"
set key left

set style line 11 lc rgb '#808080' lt 1
set border 3 back ls 11
set tics nomirror

set grid
set style line 12 lc rgb '#b0b0b0' lt 0 lw 1
set grid back ls 12

set samples 300
set border linewidth 1
plot 'lua.dat'  using 1:($2) title "Lua" \
    smooth bezier with lines linecolor rgb "#FF0000" lt 1 lw 1, \
    'py.dat'    using 1:($2) title "Python"  \
    smooth bezier with lines linecolor rgb "#00FF00" lt 1 lw 1, \
    '[ch].dat'  using 1:($2) title "C" \
    smooth bezier with lines linecolor rgb "#0000FF" lt 1 lw 1, \
    'other.dat' using 1:($2) title "Other" \
    smooth bezier with lines linecolor rgb "#aaaaaa" lt 1 lw 1;
