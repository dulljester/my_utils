set terminal epslatex color
set output 'graph.tex'
set key left bottom
set style line 1 lt 2 lc rgb "red" lw 3
set style line 2 lt 2 lc rgb "blue" lw 2
set style line 3 lt 2 lc rgb "green" lw 2
set title "Running Times of LCA Operation"
set xlabel "\\log{n}"
set ylabel "\\texttt{avg. runtime$\times{} 10^7$}"
# set logscale x
# set xrange [1:33000000]
# set yrange [0:200]
plot "lca.csv" using 5:2 with lines ls 1 title "plain-lca", "lca.csv" using 5:3 with lines ls 2 title "succinct-lca", "lca.csv" using 5:4 with lines ls 3 title "succinct-lca-ns"
