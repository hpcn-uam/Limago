# Get the name of generic project to back up
set  project_name [lindex $argv 0]

# Set the paths
source scripts/common_scripts/common_paths.tcl

# Open the project
puts "Backing up: ${project_name}"
open_project ${project_dir}/${project_name}/${project_name}.xpr

# Open the block design
open_bd_design ${project_dir}/${project_name}/${project_name}.srcs/sources_1/bd/bd/bd.bd

#Validate the block design
validate_bd_design

# It will overwrite the previous script, be careful
write_bd_tcl -force scripts/${project_name}/block_design.tcl

close_project