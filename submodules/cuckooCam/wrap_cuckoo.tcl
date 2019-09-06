set root_dir "[file normalize "."]"


# create a dummy project
create_project deleteme /tmp/deleteme -part xcvu9p-flga2104-2L-e -force
set_property board_part xilinx.com:vcu118:part0:2.0 [current_project]

# Include cuckoocam

add_files -norecurse /home/mario/Project/Limago-public-repo/submodules/cuckooCam/cuckoo_cam.dcp
add_files -norecurse /home/mario/Project/Limago-public-repo/submodules/cuckooCam/cuckooCamWrapper.v

set core_name "cuckoo_cam"

ipx::package_project -root_dir $root_dir/ip/${core_name} -vendor hpcn-uam.es -library user -taxonomy /UserIP

set_property vendor hpcn-uam.es [ipx::current_core]
set_property name ${core_name} [ipx::current_core]
set_property display_name ${core_name} [ipx::current_core]
set_property version 0.1 [ipx::current_core]
set_property core_revision 1 [ipx::current_core]
set_property supported_families {virtexuplus Beta} [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]

close_project
