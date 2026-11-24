
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

    
	if (1) set style arrow 1 head filled
        if (1) set arrow 2 from 0.56164999999999998,7.0 to 0.66164999999999996,8.2599999999999998 as 1 head filled
        if (1) set label 3 "Gelation" at 0.56164999999999998,7.25 right
        if (1) set label 4 "" at 0.66164999999999996,8.2599999999999998 point pointtype 3
	set xrange [ 0 : * ] noreverse nowriteback  # (currently [-10:10] )
	set x2range [ * : * ] noreverse nowriteback  # (currently [-10:10] )
	set yrange [ 0 : 10 ] noreverse nowriteback  # (currently [-10:10] )
	set y2range [ * : 10 ] noreverse nowriteback  # (currently [-10:10] )

	set term png
	set output 'bondStrainVsConvExt.png'

	set title "Maximum Bond Strain"
	set xlabel "Conversion Extent of siteA"

	plot "strainEnergy.txt" using 2:3 title "Strain" with linespoints pt 9 linecolor rgb "blue"

	set term gif
	set output 'bondStrainVsConvExt.gif'
	replot
    
