add_files ${submodules_ip_dir}/cuckooCam/cuckoo_cam.dcp
add_files -norecurse ${src_dir}/../wrapper/alveou200_fns_single_toe_wrapper.v

set_property top alveou200_fns_single_toe_wrapper	 [current_fileset]
set_property top bd_wrapper [get_filesets sim_1]

add_files -fileset constrs_1 -norecurse ${submodules_ip_dir}/cuckooCam/cuckoo_cam.xdc

# Force the constraint to be used at the end to overwrite the cuckoo cam constraint 
set_property PROCESSING_ORDER LATE [get_files ${submodules_ip_dir}/cuckooCam/cuckoo_cam.xdc]