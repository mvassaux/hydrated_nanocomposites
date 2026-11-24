
	set origin 0,0
	set style data points
	set style function lines
	set tics in
	set ticslevel 0.5
	set tics scale 1,0.5
	set mxtics default
	set mytics default
	set mx2tics default
	set my2tics default
	set xtics border mirror norotate 
	set ytics border nomirror norotate 
	set nox2tics
	set y2tics border nomirror norotate 
	set timestamp "" bottom norotate offset 0.0,0.0 font ""
	set xrange [ 0 : * ] noreverse nowriteback  # (currently [-10:10] )
	set x2range [ * : * ] noreverse nowriteback  # (currently [-10:10] )
	set yrange [ 0 : * ] noreverse nowriteback  # (currently [-10:10] )
	set y2range [ * : * ] noreverse nowriteback  # (currently [-10:10] )

    
	set term png
	set output 'bondStrainVsCycle.png'

	set title "Maximum Bond Strain"
	set timestamp "" bottom norotate offset 0.0,0.0 font ""
	set xlabel "Cycle"
	set x2label ""
	set ylabel "Max Bond Strain (%)"
	set y2label ""

	plot "strainEnergy.txt" using 1:3 title "Strain" with linespoints pt 9

	set term gif
	set output 'bondStrainVsCycle.gif'
	replot
    
