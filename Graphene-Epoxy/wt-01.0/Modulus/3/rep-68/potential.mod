# NOTE: This script can be modified for different pair styles 
# See in.elastic for more info.

# we must undefine any fix ave/* fix before using reset_timestep
if "$(is_defined(fix,avp))" then "unfix avp"
reset_timestep 0

# Choose potential

# Setup neighbor style
neighbor                2.0 bin
neigh_modify            delay 0 every 1 check yes
kspace_style            pppm 0.00001

# Setup output

fix avp all ave/time  ${nevery} ${nrepeat} ${nfreq} c_thermo_press mode vector
thermo		${nthermo}
thermo_style custom step temp pe press f_avp[1] f_avp[2] f_avp[3] f_avp[4] f_avp[5] f_avp[6]
thermo_modify norm no


# Fix shake is needed for water in pcff+
fix			shaken all shake .0001 20 0 a 39 b 20
fix			1 all nvt temp ${T0} ${T0} 100 drag 1.0

timestep		1
