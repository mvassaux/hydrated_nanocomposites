
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
        if (1) set arrow 2 from 0.56164999999999998,310598.72000000003 to 0.66164999999999996,384086.15000000002 as 1 head filled
        if (1) set label 3 "Gelation" at 0.56164999999999998,310598.72000000003 right
        if (1) set label 4 "" at 0.66164999999999996,384086.15000000002 point pointtype 3
	set yrange [ 0 : * ] noreverse nowriteback
	set y2range [ * : * ] noreverse nowriteback

	set term png
	set output 'molarMassVsConvExt.png'

	set title "Crosslinking Species Molar Masses"
	set xlabel "Conversion Extent of siteA"
	set ylabel "Sol Molar Mass"

        set key left top

	plot "molarMassData.txt" using 2:4 title "Average" with linespoints pt 9 linecolor rgb "blue", \
	     "molarMassData.txt" using 2:6 title "Largest" with linespoints pt 9 linecolor rgb "green", \
	     "molarMassData.txt" using 2:7 title "2nd Largest" with linespoints pt 9 linecolor rgb "red"

	set term gif
	set output 'molarMassVsConvExt.gif'
	replot
    
