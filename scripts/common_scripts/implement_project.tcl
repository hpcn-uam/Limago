# Get the name of the folder
set  project_name [lindex $argv 0]

# Set the paths
source scripts/common_scripts/common_paths.tcl

# Open the project
open_project ${project_dir}/${project_name}/${project_name}.xpr


set project_status [get_property STATUS [get_runs impl_1]]
if {$project_status != "write_bitstream Complete!"} {
	# Reset stages
	#reset_run synth_1
	#reset_run impl_1
	launch_runs impl_1 -to_step write_bitstream -jobs 7
	wait_on_run impl_1
} else {
	puts "Bitstream has been already generated"
}


close_project