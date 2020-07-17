set project_dir 	  "[file normalize "./projects"]"
set tcl_dir 		  "[file normalize "./scripts/generate_ips/individual_ips"]"
set tcl_bd_dir 		  "[file normalize "./scripts/generate_ips/bd"]"
set ip_dir 			  "[file normalize "./project/ips"]"
set src_dir 		  "[file normalize "./src/rtl"]"
set src_dir_sw 		  "[file normalize "./src/microblaze"]"
set constraints_dir   "[file normalize "./src/constraints"]"
set tb_dir 			  "[file normalize "./src/tb"]"
set filter_ip_dir 	  "[file normalize "./src/rtl/filters/"]"
set embedded_dir  	  "[file normalize "./embedded"]"

set submodules_ip_dir "[file normalize "./submodules"]"
set cmac_dir ${submodules_ip_dir}/cmac
set stack_dir ${submodules_ip_dir}/fpga-network-stack-core/synthesis_results_noHBM

if {[string first "alveou280" ${project_name}] == 0} {
	set stack_dir ${submodules_ip_dir}/fpga-network-stack-core/synthesis_results_HBM
}