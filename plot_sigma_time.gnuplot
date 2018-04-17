set terminal epslatex color
set output 'sigmaTime.tex'
set key left top
set style line 1 lt 2 lc rgb "red" lw 2
set style line 2 lt 2 lc rgb "blue" lw 2
set style line 3 lt 2 lc rgb "green" lw 2
set title "Avg. Running Time vs $\\sigma$"
set xlabel "$\\sigma$"
set ylabel "\\texttt{avg.query time$\\times{}10^3$}"
plot "out.csv" using 1:3 with lines ls 1 title "extraction\\_mp", "out.csv" using 1:5 with lines ls 2 title "wt\\_hpd", "out.csv" using 1:7 with lines ls 3 title "multiple\\_par"
