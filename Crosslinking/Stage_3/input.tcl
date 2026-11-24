
	
	package require memory
	package require system
	package require MD::ThermosetBuilder
	package require MD::FF

    

	set __fffile Forcefields.kit::organic/pcff+.frc
	set __ff pcff+

    
    
	::MD::FF ::FF
	::FF readFF $__fffile
	::FF configure -forcefield $__ff
	set ::FF ::FF


	new ::MD::ThermosetBuilder::Builder ThermosetBuilder -mode batch

	set fd [open xlinkprocess.spec r]
	set xlinkprocessSpec [read $fd]
	close $fd
    
	set systems [$ThermosetBuilder build_xlinked_system $xlinkprocessSpec]
    
	set i 0
	foreach system $systems {
	    if {$system eq ""} {continue}
	    incr i
	    $system toFile thermoset_$i.sci
	}
    