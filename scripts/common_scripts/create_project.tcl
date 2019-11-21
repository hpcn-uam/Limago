# Get the name of the source files of the project
set project_name [lindex $argv 0]

# Set the paths
source scripts/common_scripts/common_paths.tcl

# Create the project and specify the board


if {[string first "vcu118" ${project_name}] == 0} {
	set fpga_part "xcvu9p-flga2104-2L-e"
	set fpga_board "xilinx.com:vcu118:part0:2.0"  
} elseif {[string first "alveou200" ${project_name}] == 0} {
	set fpga_part "xcu200-fsgd2104-2-e"
	set fpga_board "xilinx.com:au200:part0:1.0"  
} else {
	puts "The project ${project_name} does not have associated constraint(s)"
	exit
}

create_project ${project_name} ${project_dir}/${project_name} -part ${fpga_part} -force
set_property board_part ${fpga_board} [current_project]

#Adding the ip path to the project
set_property  ip_repo_paths  "$submodules_ip_dir" [current_project]

#A block design is created
create_bd_design "bd"


#Add modules from RTL
add_files ${src_dir}/
add_files ${submodules_ip_dir}/fpga-network-stack-core/RTL

# Refresh the  hierarchy
set_property source_mgmt_mode All [current_project]

# Add extra files
source ./scripts/${project_name}/extra_files.tcl -quiet

# Create the block Design
source ./scripts/${project_name}/block_design.tcl

# Add Contraints files
if {[string first "vcu118" ${project_name}] == 0} {
	add_files -fileset constrs_1 -norecurse ${constraints_dir}/vcu118_pinout.xdc
	add_files -fileset constrs_1 -norecurse ${constraints_dir}/vcu118_timing.xdc
} elseif {[string first "alveou200" ${project_name}] == 0} {
	add_files -fileset constrs_1 -norecurse ${constraints_dir}/alveou200_pinout.xdc
	add_files -fileset constrs_1 -norecurse ${constraints_dir}/alveou200_timing.xdc
} else {
	puts "The project ${project_name} does not have associated constraint(s)"
}

    
set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {-verilog_define ULTRASCALE_PLUS} -objects [get_runs synth_1]
set_property verilog_define ULTRASCALE_PLUS [get_filesets sources_1]
set_property verilog_define ULTRASCALE_PLUS [get_filesets sim_1]

update_compile_order -fileset sources_1
generate_target all [get_files ${project_dir}/${project_name}/${project_name}.srcs/sources_1/bd/bd/bd.bd]
make_wrapper -files [get_files ${project_dir}/${project_name}/${project_name}.srcs/sources_1/bd/bd/bd.bd] -top
add_files -norecurse ${project_dir}/${project_name}/${project_name}.srcs/sources_1/bd/bd/hdl/bd_wrapper.v


set_property top bd_wrapper [current_fileset]
set_property top bd_wrapper [get_filesets sim_1]

set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]

# Add in this file things that are not common to the other projects
# If this file does not exists the project creation will continue due to "-quiet"
source ./scripts/${project_name}/specific_details.tcl -quiet

close_project
