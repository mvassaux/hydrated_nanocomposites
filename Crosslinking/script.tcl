
	    cd "/home/werner/MD/Jobs/dir500/680"

	    if {[catch {
		# Key variables
		namespace eval job {}
		set ::job::id 680
		set ::job::serverId 35355
		# The port this jobserver is running on, and ::Secure flag
		set ::job::js_port 32000
		set ::job::useSecurity 0
		set ::job::ncores 1
		set ::job::maxcores 1

		namespace eval ::MedeA {}
		
		# the main libraries
		source "/home/werner/MD/bin/generic/tcllib.kit"
		source "/home/werner/MD/bin/Linux-x86_64/Linux-x86_64.kit"
		source "/home/werner/MD/bin/generic/MedeALib.kit"
		source "/home/werner/MD/bin/generic/JobServer.kit"
		set lkits [list "/home/werner/MD/bin/generic/tcllib.kit" "/home/werner/MD/bin/Linux-x86_64/Linux-x86_64.kit" "/home/werner/MD/bin/generic/MedeALib.kit" "/home/werner/MD/bin/generic/JobServer.kit"]
		
		# the path...
		set ::env(PATH) {/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin}
		set ::auto_path {/home/werner/MD/bin/generic/JobServer.kit/bin/../lib /usr/local/bin/tclkit/lib/tcl8.6 /usr/local/bin/tclkit/lib /home/werner/MD/bin/generic/JobServer.kit/lib /home/werner/MD/bin/generic/tcllib.kit/lib /home/werner/MD/bin/Linux-x86_64/Linux-x86_64.kit/lib /home/werner/MD/bin/generic/MedeALib.kit/lib /home/werner/MD/bin/Linux-x86_64/Linux-x86_64.kit/lib/tcl3d0.9.5 /home/werner/MD/bin/generic/JobServer.kit/lib/til /home/werner/MD/bin/generic/JobServer.kit/plugins /home/werner/MD/bin/generic/JobServer.kit/lib/til /home/werner/MD/bin/generic/JobServer.kit/lib/til /home/werner/MD/bin/generic/JobServer.kit/lib/til /home/werner/MD/bin/generic/JobServer.kit/bin/../custom /home/werner/MD/bin/generic/JobServer.kit/lib/til /home/werner/MD/bin/generic/JobServer.kit/bin/../lib/til /home/werner/MD/bin/generic/JobServer.kit/bin/../lib/til /home/werner/MD/bin/generic/JobServer.kit/lib/til /home/werner/MD/bin/generic/JobServer.kit/lib/til /home/werner/MD/bin/generic/JobServer.kit/bin/../lib/til /home/werner/MD/bin/generic/JobServer.kit/bin/../lib/til /home/werner/MD/bin/generic/JobServer.kit/lib/til /home/werner/MD/bin/generic/JobServer.kit/lib/til /home/werner/MD/bin/generic/JobServer.kit/bin/../lib/til /home/werner/MD/bin/generic/JobServer.kit/bin/../lib/til /home/werner/MD/bin/generic/JobServer.kit/lib/til /home/werner/MD/bin/generic/JobServer.kit/lib/til /home/werner/MD/bin/generic/JobServer.kit/bin/../lib/til /home/werner/MD/bin/generic/JobServer.kit/bin/../lib/til /home/werner/MD/bin/generic/JobServer.kit/lib/til /home/werner/MD/bin/generic/JobServer.kit/lib/til /home/werner/MD/bin/generic/JobServer.kit/bin/../lib/til /home/werner/MD/bin/generic/JobServer.kit/bin/../lib/til /home/werner/MD/bin/generic/JobServer.kit/lib/til /home/werner/MD/bin/generic/JobServer.kit/lib/til /home/werner/MD/bin/generic/JobServer.kit/bin/../lib/til}

		# the packages...
		package require ::MD::MedeACore
		package require JobUtilities
		
		# Create a MedeACore object 
		::MD::MedeACore ::medea_core  -initial_core 1 -auto_clean_tmp 0  -generic_kit_dir "/home/werner/MD/bin/generic" -sourced_starkits ${lkits} -log_level warn

		# The plugins
		if {"InlineTaskServer" eq "InlineTaskServer"} {
		    set ::Plugin "InlineTaskServer"
		} else {
		    package require MD::JobServer::Plugin
		    new InlineTaskServer ::Plugin 
		}

		# and the rest of the initialization
		initialize_job
		# Do the work!
		run_job

		# Cleanup the tmp files
		if {[info exists ::env(TMP)]} {
		    set tmpdir [file normalize $::env(TMP)]
		    if {$tmpdir != ""} {
			set files [glob -nocomplain [file join $tmpdir TCL????????]]
			set n [llength $files]
			foreach file $files {
			    catch {file delete -force -- $file}
			}
		    }
		}
	    } msg]} {
		puts "==============================================================="
		puts "ERROR!!!
$::errorInfo"
		error $msg $::errorInfo
	    }
	
