
################################################################
# This is a generated script based on design: bd
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source bd_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# qsfp28_cage_control, axi4stream_constant, axi4stream_sinker, interface_settings, performance_debug_reg, bandwith_reg, bandwith_reg, bandwith_reg, axi4stream_sinker, bandwith_reg, bandwith_reg, cycle_limiter, tcp_checksum_axis, tcp_checksum_axis, bandwith_reg, size_checker, axi4stream_sinker, bandwith_reg, bandwith_reg, bandwith_reg

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcu200-fsgd2104-2-e
   set_property BOARD_PART xilinx.com:au200:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name bd

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:smartconnect:1.0\
naudit:cmac:cmac_sync:1\
naudit:cmac:cmac_ALVEOu200_0:1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:vio:3.0\
xilinx.com:ip:axi_register_slice:2.1\
xilinx.com:ip:jtag_axi:1.2\
xilinx.com:ip:util_ds_buf:2.1\
xilinx.com:ip:xdma:4.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:axis_register_slice:1.1\
xilinx.com:hls:arp_server:1.0\
xilinx.com:hls:icmp_server:1.0\
xilinx.com:ip:axi_datamover:5.1\
hpcn-uam.es:hls:iperf2_client:1.0\
xilinx.com:ip:ddr4:2.2\
xilinx.com:hls:toe:1.0\
xilinx.com:hls:ethernet_header_inserter:1.0\
xilinx.com:ip:axis_switch:1.1\
xilinx.com:ip:fifo_generator:13.2\
xilinx.com:hls:packet_handler:1.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
qsfp28_cage_control\
axi4stream_constant\
axi4stream_sinker\
interface_settings\
performance_debug_reg\
bandwith_reg\
bandwith_reg\
bandwith_reg\
axi4stream_sinker\
bandwith_reg\
bandwith_reg\
cycle_limiter\
tcp_checksum_axis\
tcp_checksum_axis\
bandwith_reg\
size_checker\
axi4stream_sinker\
bandwith_reg\
bandwith_reg\
bandwith_reg\
"

   set list_mods_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_msg_id "BD_TCL-008" "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: Traffic_Identification
proc create_hier_cell_Traffic_Identification { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_Traffic_Identification() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 ARP
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 ICMP
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 TCP

  # Create pins
  create_bd_pin -dir I -type clk cmac_if0_rx_clk
  create_bd_pin -dir I -type rst cmac_if0_rx_rst_n
  create_bd_pin -dir O -from 191 -to 0 debug_slot_input_traffic
  create_bd_pin -dir O -from 191 -to 0 debug_slot_packet_handler
  create_bd_pin -dir O -from 191 -to 0 debug_slot_udp
  create_bd_pin -dir I -type rst user_rst_n

  # Create instance: axi4stream_sinker_0, and set properties
  set block_name axi4stream_sinker
  set block_cell_name axi4stream_sinker_0
  if { [catch {set axi4stream_sinker_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi4stream_sinker_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: bandwith_cmac_0, and set properties
  set block_name bandwith_reg
  set block_cell_name bandwith_cmac_0
  if { [catch {set bandwith_cmac_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $bandwith_cmac_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.USE_KEEP {1} \
 ] $bandwith_cmac_0

  # Create instance: bandwith_udp, and set properties
  set block_name bandwith_reg
  set block_cell_name bandwith_udp
  if { [catch {set bandwith_udp [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $bandwith_udp eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.USE_KEEP {1} \
 ] $bandwith_udp

  # Create instance: cmac_bandwidth_slice, and set properties
  set cmac_bandwidth_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 cmac_bandwidth_slice ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.REG_CONFIG {8} \
   CONFIG.TDATA_NUM_BYTES {64} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $cmac_bandwidth_slice

  # Create instance: cmac_slice, and set properties
  set cmac_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 cmac_slice ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.REG_CONFIG {8} \
   CONFIG.TDATA_NUM_BYTES {64} \
   CONFIG.TUSER_WIDTH {0} \
 ] $cmac_slice

  # Create instance: packet_handler_0, and set properties
  set packet_handler_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:packet_handler:1.0 packet_handler_0 ]

  # Create instance: packet_handler_bandwidth, and set properties
  set block_name bandwith_reg
  set block_cell_name packet_handler_bandwidth
  if { [catch {set packet_handler_bandwidth [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $packet_handler_bandwidth eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.TDEST_WIDTH {3} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.USE_KEEP {1} \
 ] $packet_handler_bandwidth

  # Create instance: packet_handler_slice, and set properties
  set packet_handler_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 packet_handler_slice ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.REG_CONFIG {8} \
   CONFIG.TDATA_NUM_BYTES {64} \
   CONFIG.TDEST_WIDTH {3} \
   CONFIG.TUSER_WIDTH {0} \
 ] $packet_handler_slice

  # Create instance: traffic_splitter, and set properties
  set traffic_splitter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 traffic_splitter ]
  set_property -dict [ list \
   CONFIG.DECODER_REG {1} \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
   CONFIG.TDATA_NUM_BYTES {64} \
 ] $traffic_splitter

  # Create interface connections
  connect_bd_intf_net -intf_net bandwith_cmac_0_OUT_DBG [get_bd_intf_pins bandwith_cmac_0/OUT_DBG] [get_bd_intf_pins cmac_bandwidth_slice/S_AXIS]
  connect_bd_intf_net -intf_net bandwith_cmac_1_OUT_DBG [get_bd_intf_pins axi4stream_sinker_0/S_AXIS] [get_bd_intf_pins bandwith_udp/OUT_DBG]
  connect_bd_intf_net -intf_net cmac_bandwidth_slice_M_AXIS [get_bd_intf_pins cmac_bandwidth_slice/M_AXIS] [get_bd_intf_pins packet_handler_0/s_axis]
  connect_bd_intf_net -intf_net cmac_slice_M_AXIS_1 [get_bd_intf_pins bandwith_cmac_0/IN_DBG] [get_bd_intf_pins cmac_slice/M_AXIS]
  connect_bd_intf_net -intf_net ip_handler_bandwidth_1_OUT_DBG [get_bd_intf_pins packet_handler_bandwidth/OUT_DBG] [get_bd_intf_pins packet_handler_slice/S_AXIS]
  connect_bd_intf_net -intf_net packet_handler_0_m_axis [get_bd_intf_pins packet_handler_0/m_axis] [get_bd_intf_pins packet_handler_bandwidth/IN_DBG]
  connect_bd_intf_net -intf_net packet_handler_slice_M_AXIS [get_bd_intf_pins packet_handler_slice/M_AXIS] [get_bd_intf_pins traffic_splitter/S00_AXIS]
  connect_bd_intf_net -intf_net traffic_generator_LBUS2AXI [get_bd_intf_pins S_AXIS] [get_bd_intf_pins cmac_slice/S_AXIS]
  connect_bd_intf_net -intf_net traffic_splitter_M00_AXIS [get_bd_intf_pins ARP] [get_bd_intf_pins traffic_splitter/M00_AXIS]
  connect_bd_intf_net -intf_net traffic_splitter_M01_AXIS [get_bd_intf_pins ICMP] [get_bd_intf_pins traffic_splitter/M01_AXIS]
  connect_bd_intf_net -intf_net traffic_splitter_M02_AXIS [get_bd_intf_pins TCP] [get_bd_intf_pins traffic_splitter/M02_AXIS]
  connect_bd_intf_net -intf_net traffic_splitter_M03_AXIS [get_bd_intf_pins bandwith_udp/IN_DBG] [get_bd_intf_pins traffic_splitter/M03_AXIS]

  # Create port connections
  connect_bd_net -net CMAC_CLK_1 [get_bd_pins cmac_if0_rx_clk] [get_bd_pins axi4stream_sinker_0/CLK] [get_bd_pins bandwith_cmac_0/S_AXI_ACLK] [get_bd_pins bandwith_udp/S_AXI_ACLK] [get_bd_pins cmac_bandwidth_slice/aclk] [get_bd_pins cmac_slice/aclk] [get_bd_pins packet_handler_0/ap_clk] [get_bd_pins packet_handler_bandwidth/S_AXI_ACLK] [get_bd_pins packet_handler_slice/aclk] [get_bd_pins traffic_splitter/aclk]
  connect_bd_net -net bandwith_cmac_1_debug_slot [get_bd_pins debug_slot_packet_handler] [get_bd_pins packet_handler_bandwidth/debug_slot]
  connect_bd_net -net bandwith_cmac_1_debug_slot1 [get_bd_pins debug_slot_udp] [get_bd_pins bandwith_udp/debug_slot]
  connect_bd_net -net bandwith_reg_0_debug_slot [get_bd_pins debug_slot_input_traffic] [get_bd_pins bandwith_cmac_0/debug_slot]
  connect_bd_net -net p_arst_n_322_1 [get_bd_pins cmac_if0_rx_rst_n] [get_bd_pins axi4stream_sinker_0/RST_N] [get_bd_pins bandwith_cmac_0/S_AXI_ARESETN] [get_bd_pins bandwith_udp/S_AXI_ARESETN] [get_bd_pins cmac_bandwidth_slice/aresetn] [get_bd_pins cmac_slice/aresetn] [get_bd_pins packet_handler_0/ap_rst_n] [get_bd_pins packet_handler_bandwidth/S_AXI_ARESETN] [get_bd_pins packet_handler_slice/aresetn] [get_bd_pins traffic_splitter/aresetn]
  connect_bd_net -net reg_debug_0_user_rst_n_1 [get_bd_pins user_rst_n] [get_bd_pins bandwith_cmac_0/user_rst_n] [get_bd_pins bandwith_udp/user_rst_n] [get_bd_pins packet_handler_bandwidth/user_rst_n]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Traffic_Agregation
proc create_hier_cell_Traffic_Agregation { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_Traffic_Agregation() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 ARP
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 ICMP
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 TCP
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 TX_TRAFFIC
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 arpTableReplay
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 arpTableRequest_V_V

  # Create pins
  create_bd_pin -dir I -type clk cmac_if0_rx_clk
  create_bd_pin -dir I -type rst cmac_if0_rx_rst_n
  create_bd_pin -dir I -type clk cmac_if0_tx_clk
  create_bd_pin -dir I -type rst cmac_if0_tx_rst_n
  create_bd_pin -dir O -from 191 -to 0 debug_slot
  create_bd_pin -dir I -from 47 -to 0 -type data myMacAddress
  create_bd_pin -dir I -from 31 -to 0 -type data regDefaultGateway
  create_bd_pin -dir I -from 31 -to 0 -type data regSubNetMask
  create_bd_pin -dir I -type rst user_rst_n

  # Create instance: bandwith_reg_0, and set properties
  set block_name bandwith_reg
  set block_cell_name bandwith_reg_0
  if { [catch {set bandwith_reg_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $bandwith_reg_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.USE_KEEP {1} \
 ] $bandwith_reg_0

  # Create instance: eth_header_inserter_slice, and set properties
  set eth_header_inserter_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 eth_header_inserter_slice ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.REG_CONFIG {8} \
   CONFIG.TDATA_NUM_BYTES {64} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $eth_header_inserter_slice

  # Create instance: ethernet_header_inserter_0, and set properties
  set ethernet_header_inserter_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:ethernet_header_inserter:1.0 ethernet_header_inserter_0 ]

  # Create instance: ethernet_level_merger, and set properties
  set ethernet_level_merger [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 ethernet_level_merger ]
  set_property -dict [ list \
   CONFIG.ARB_ALGORITHM {1} \
   CONFIG.ARB_ON_MAX_XFERS {0} \
   CONFIG.ARB_ON_TLAST {1} \
   CONFIG.DECODER_REG {0} \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
   CONFIG.TDATA_NUM_BYTES {64} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $ethernet_level_merger

  # Create instance: fifo_packet_output_reg, and set properties
  set fifo_packet_output_reg [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 fifo_packet_output_reg ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.REG_CONFIG {8} \
   CONFIG.TDATA_NUM_BYTES {64} \
 ] $fifo_packet_output_reg

  # Create instance: ip_level_merger, and set properties
  set ip_level_merger [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 ip_level_merger ]
  set_property -dict [ list \
   CONFIG.ARB_ALGORITHM {1} \
   CONFIG.ARB_ON_MAX_XFERS {0} \
   CONFIG.ARB_ON_TLAST {1} \
   CONFIG.DECODER_REG {0} \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
   CONFIG.TDATA_NUM_BYTES {64} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $ip_level_merger

  # Create instance: output_slice, and set properties
  set output_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 output_slice ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.REG_CONFIG {8} \
   CONFIG.TDATA_NUM_BYTES {64} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $output_slice

  # Create instance: rx_tx_domaing_crossing, and set properties
  set rx_tx_domaing_crossing [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 rx_tx_domaing_crossing ]
  set_property -dict [ list \
   CONFIG.Clock_Type_AXI {Independent_Clock} \
   CONFIG.Empty_Threshold_Assert_Value_axis {253} \
   CONFIG.Empty_Threshold_Assert_Value_rach {13} \
   CONFIG.Empty_Threshold_Assert_Value_rdch {1018} \
   CONFIG.Empty_Threshold_Assert_Value_wach {13} \
   CONFIG.Empty_Threshold_Assert_Value_wdch {1018} \
   CONFIG.Empty_Threshold_Assert_Value_wrch {13} \
   CONFIG.Enable_TLAST {true} \
   CONFIG.FIFO_Application_Type_axis {Packet_FIFO} \
   CONFIG.FIFO_Implementation_axis {Independent_Clocks_Block_RAM} \
   CONFIG.FIFO_Implementation_rach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_rdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wach {Independent_Clocks_Distributed_RAM} \
   CONFIG.FIFO_Implementation_wdch {Independent_Clocks_Builtin_FIFO} \
   CONFIG.FIFO_Implementation_wrch {Independent_Clocks_Distributed_RAM} \
   CONFIG.Full_Threshold_Assert_Value_axis {255} \
   CONFIG.Full_Threshold_Assert_Value_rach {15} \
   CONFIG.Full_Threshold_Assert_Value_wach {15} \
   CONFIG.Full_Threshold_Assert_Value_wrch {15} \
   CONFIG.HAS_TKEEP {true} \
   CONFIG.HAS_TSTRB {false} \
   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
   CONFIG.Input_Depth_axis {256} \
   CONFIG.Reset_Type {Asynchronous_Reset} \
   CONFIG.TDATA_NUM_BYTES {64} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TKEEP_WIDTH {64} \
   CONFIG.TSTRB_WIDTH {64} \
   CONFIG.TUSER_WIDTH {0} \
 ] $rx_tx_domaing_crossing

  # Create instance: size_checker_0, and set properties
  set block_name size_checker
  set block_cell_name size_checker_0
  if { [catch {set size_checker_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $size_checker_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $size_checker_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {2} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {2} \
 ] $xlconstant_1

  # Create interface connections
  connect_bd_intf_net -intf_net ICMP_1 [get_bd_intf_pins ICMP] [get_bd_intf_pins ip_level_merger/S01_AXIS]
  connect_bd_intf_net -intf_net TCP_M_AXIS [get_bd_intf_pins TCP] [get_bd_intf_pins ip_level_merger/S00_AXIS]
  connect_bd_intf_net -intf_net arp_out_slice_M_AXIS [get_bd_intf_pins ARP] [get_bd_intf_pins ethernet_level_merger/S01_AXIS]
  connect_bd_intf_net -intf_net arp_server_0_macIpEncode_rsp_V [get_bd_intf_pins arpTableReplay] [get_bd_intf_pins ethernet_header_inserter_0/arpTableReplay_V]
  connect_bd_intf_net -intf_net bandwith_reg_0_OUT_DBG [get_bd_intf_pins bandwith_reg_0/OUT_DBG] [get_bd_intf_pins output_slice/S_AXIS]
  connect_bd_intf_net -intf_net ethernet_header_inserter_0_arpTableRequest_V_V [get_bd_intf_pins arpTableRequest_V_V] [get_bd_intf_pins ethernet_header_inserter_0/arpTableRequest_V_V]
  connect_bd_intf_net -intf_net ethernet_header_inserter_0_dataOut [get_bd_intf_pins eth_header_inserter_slice/S_AXIS] [get_bd_intf_pins ethernet_header_inserter_0/dataOut]
  connect_bd_intf_net -intf_net ethernet_level_merger_M00_AXIS [get_bd_intf_pins ethernet_level_merger/M00_AXIS] [get_bd_intf_pins size_checker_0/S_AXIS]
  connect_bd_intf_net -intf_net ip_level_merger_reg_M_AXIS [get_bd_intf_pins eth_header_inserter_slice/M_AXIS] [get_bd_intf_pins ethernet_level_merger/S00_AXIS]
  connect_bd_intf_net -intf_net output_slice_M_AXIS [get_bd_intf_pins output_slice/M_AXIS] [get_bd_intf_pins rx_tx_domaing_crossing/S_AXIS]
  connect_bd_intf_net -intf_net rx_tx_crossdomain_reg_M_AXIS [get_bd_intf_pins TX_TRAFFIC] [get_bd_intf_pins fifo_packet_output_reg/M_AXIS]
  connect_bd_intf_net -intf_net rx_tx_domaing_crossing_M_AXIS [get_bd_intf_pins fifo_packet_output_reg/S_AXIS] [get_bd_intf_pins rx_tx_domaing_crossing/M_AXIS]
  connect_bd_intf_net -intf_net size_checker_0_M_AXIS [get_bd_intf_pins bandwith_reg_0/IN_DBG] [get_bd_intf_pins size_checker_0/M_AXIS]
  connect_bd_intf_net -intf_net traffic_merger1_M00_AXIS [get_bd_intf_pins ethernet_header_inserter_0/dataIn] [get_bd_intf_pins ip_level_merger/M00_AXIS]

  # Create port connections
  connect_bd_net -net aresetn_1 [get_bd_pins cmac_if0_tx_rst_n] [get_bd_pins fifo_packet_output_reg/aresetn]
  connect_bd_net -net bandwith_reg_0_debug_slot [get_bd_pins debug_slot] [get_bd_pins bandwith_reg_0/debug_slot]
  connect_bd_net -net cmac_tx_clk_1 [get_bd_pins cmac_if0_rx_clk] [get_bd_pins bandwith_reg_0/S_AXI_ACLK] [get_bd_pins eth_header_inserter_slice/aclk] [get_bd_pins ethernet_header_inserter_0/ap_clk] [get_bd_pins ethernet_level_merger/aclk] [get_bd_pins ip_level_merger/aclk] [get_bd_pins output_slice/aclk] [get_bd_pins rx_tx_domaing_crossing/s_aclk] [get_bd_pins size_checker_0/CLK]
  connect_bd_net -net cmac_tx_clk_2 [get_bd_pins cmac_if0_tx_clk] [get_bd_pins fifo_packet_output_reg/aclk] [get_bd_pins rx_tx_domaing_crossing/m_aclk]
  connect_bd_net -net fix_settings_0_my_gateway [get_bd_pins regDefaultGateway] [get_bd_pins ethernet_header_inserter_0/regDefaultGateway_V]
  connect_bd_net -net fix_settings_0_my_ip_subnet_mask [get_bd_pins regSubNetMask] [get_bd_pins ethernet_header_inserter_0/regSubNetMask_V]
  connect_bd_net -net fix_settings_0_my_mac [get_bd_pins myMacAddress] [get_bd_pins ethernet_header_inserter_0/myMacAddress_V]
  connect_bd_net -net p_arst_n_tx_322_1 [get_bd_pins cmac_if0_rx_rst_n] [get_bd_pins bandwith_reg_0/S_AXI_ARESETN] [get_bd_pins eth_header_inserter_slice/aresetn] [get_bd_pins ethernet_header_inserter_0/ap_rst_n] [get_bd_pins ethernet_level_merger/aresetn] [get_bd_pins ip_level_merger/aresetn] [get_bd_pins output_slice/aresetn] [get_bd_pins rx_tx_domaing_crossing/s_aresetn] [get_bd_pins size_checker_0/RST_N]
  connect_bd_net -net reg_debug_0_user_rst_n [get_bd_pins user_rst_n] [get_bd_pins bandwith_reg_0/user_rst_n]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins ethernet_level_merger/s_req_suppress] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins ip_level_merger/s_req_suppress] [get_bd_pins xlconstant_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: TCP
proc create_hier_cell_TCP { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_TCP() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 C3_DDR4
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 IPERF_CONF
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 TCP
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr4_c3_ref_clk
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_session_lup_req
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_session_upd_req
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_session_lup_rsp
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_session_upd_rsp

  # Create pins
  create_bd_pin -dir I -type clk cmac_if0_rx_clk
  create_bd_pin -dir I -type rst cmac_if0_rx_rst_n
  create_bd_pin -dir O -from 191 -to 0 debug_slot_in
  create_bd_pin -dir O -from 191 -to 0 debug_slot_ou
  create_bd_pin -dir I -from 31 -to 0 -type data myIpAddress
  create_bd_pin -dir I user_rst_n

  # Create instance: axi4stream_sinker_0, and set properties
  set block_name axi4stream_sinker
  set block_cell_name axi4stream_sinker_0
  if { [catch {set axi4stream_sinker_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi4stream_sinker_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.C_AXI_TDATA_WIDTH {8} \
 ] $axi4stream_sinker_0

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.ENABLE_ADVANCED_OPTIONS {1} \
   CONFIG.M00_HAS_DATA_FIFO {0} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
   CONFIG.S00_HAS_DATA_FIFO {2} \
   CONFIG.S01_HAS_DATA_FIFO {2} \
   CONFIG.S02_HAS_DATA_FIFO {2} \
   CONFIG.S03_HAS_DATA_FIFO {2} \
   CONFIG.STRATEGY {0} \
   CONFIG.SYNCHRONIZATION_STAGES {2} \
 ] $axi_interconnect_0

  # Create instance: axi_register_slice_0, and set properties
  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.REG_AR {1} \
   CONFIG.REG_AW {1} \
   CONFIG.REG_B {1} \
 ] $axi_register_slice_0

  # Create instance: axis_register_slice_0, and set properties
  set axis_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.REG_CONFIG {8} \
   CONFIG.TDATA_NUM_BYTES {64} \
 ] $axis_register_slice_0

  # Create instance: bandwith_inputTCP, and set properties
  set block_name bandwith_reg
  set block_cell_name bandwith_inputTCP
  if { [catch {set bandwith_inputTCP [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $bandwith_inputTCP eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.USE_KEEP {1} \
 ] $bandwith_inputTCP

  # Create instance: bandwith_reg_1, and set properties
  set block_name bandwith_reg
  set block_cell_name bandwith_reg_1
  if { [catch {set bandwith_reg_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $bandwith_reg_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.USE_KEEP {1} \
 ] $bandwith_reg_1

  # Create instance: cycle_limiter_0, and set properties
  set block_name cycle_limiter
  set block_cell_name cycle_limiter_0
  if { [catch {set cycle_limiter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $cycle_limiter_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: datamover_TX, and set properties
  set datamover_TX [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_datamover:5.1 datamover_TX ]
  set_property -dict [ list \
   CONFIG.c_dummy {1} \
   CONFIG.c_include_mm2s_dre {true} \
   CONFIG.c_include_s2mm_dre {true} \
   CONFIG.c_m_axi_mm2s_data_width {512} \
   CONFIG.c_m_axi_s2mm_data_width {512} \
   CONFIG.c_m_axis_mm2s_tdata_width {512} \
   CONFIG.c_mm2s_burst_size {64} \
   CONFIG.c_mm2s_include_sf {false} \
   CONFIG.c_s2mm_burst_size {64} \
   CONFIG.c_s_axis_s2mm_tdata_width {512} \
   CONFIG.c_single_interface {1} \
 ] $datamover_TX

  # Create instance: iperf2_client_1, and set properties
  set iperf2_client_1 [ create_bd_cell -type ip -vlnv hpcn-uam.es:hls:iperf2_client:1.0 iperf2_client_1 ]

  # Create instance: memory_controller_c0, and set properties
  set memory_controller_c0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 memory_controller_c0 ]
  set_property -dict [ list \
   CONFIG.ADDN_UI_CLKOUT1_FREQ_HZ {None} \
   CONFIG.C0.CKE_WIDTH {1} \
   CONFIG.C0.CS_WIDTH {1} \
   CONFIG.C0.DDR4_AxiAddressWidth {34} \
   CONFIG.C0.DDR4_AxiDataWidth {512} \
   CONFIG.C0.DDR4_AxiNarrowBurst {true} \
   CONFIG.C0.DDR4_CLKOUT0_DIVIDE {5} \
   CONFIG.C0.DDR4_CasLatency {17} \
   CONFIG.C0.DDR4_CasWriteLatency {12} \
   CONFIG.C0.DDR4_DataMask {NONE} \
   CONFIG.C0.DDR4_DataWidth {72} \
   CONFIG.C0.DDR4_Ecc {true} \
   CONFIG.C0.DDR4_InputClockPeriod {3332} \
   CONFIG.C0.DDR4_MemoryPart {MTA18ASF2G72PZ-2G3} \
   CONFIG.C0.DDR4_MemoryType {RDIMMs} \
   CONFIG.C0.DDR4_TimePeriod {833} \
   CONFIG.C0.ODT_WIDTH {1} \
   CONFIG.C0_CLOCK_BOARD_INTERFACE {default_300mhz_clk3} \
   CONFIG.C0_DDR4_BOARD_INTERFACE {ddr4_sdram_c3} \
 ] $memory_controller_c0

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create instance: register_TCPin_bandwidth, and set properties
  set register_TCPin_bandwidth [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 register_TCPin_bandwidth ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.REG_CONFIG {8} \
   CONFIG.TDATA_NUM_BYTES {64} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $register_TCPin_bandwidth

  # Create instance: tcp_checksum_RX, and set properties
  set block_name tcp_checksum_axis
  set block_cell_name tcp_checksum_RX
  if { [catch {set tcp_checksum_RX [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $tcp_checksum_RX eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: tcp_checksum_TX, and set properties
  set block_name tcp_checksum_axis
  set block_cell_name tcp_checksum_TX
  if { [catch {set tcp_checksum_TX [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $tcp_checksum_TX eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: toe_0, and set properties
  set toe_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:toe:1.0 toe_0 ]

  # Create instance: xlconstant_val_0, and set properties
  set xlconstant_val_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_val_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_val_0

  # Create instance: xlconstant_val_1, and set properties
  set xlconstant_val_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_val_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
 ] $xlconstant_val_1

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins C3_DDR4] [get_bd_intf_pins memory_controller_c0/C0_DDR4]
  connect_bd_intf_net -intf_net IPERF_CONF_1 [get_bd_intf_pins IPERF_CONF] [get_bd_intf_pins iperf2_client_1/s_axi_settings]
  connect_bd_intf_net -intf_net TCP_1 [get_bd_intf_pins TCP] [get_bd_intf_pins cycle_limiter_0/S_AXIS]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins memory_controller_c0/C0_DDR4_S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins axi_register_slice_0/M_AXI]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS [get_bd_intf_pins M_AXIS] [get_bd_intf_pins axis_register_slice_0/M_AXIS]
  connect_bd_intf_net -intf_net bandwith_inputTCP_OUT_DBG [get_bd_intf_pins bandwith_inputTCP/OUT_DBG] [get_bd_intf_pins register_TCPin_bandwidth/S_AXIS]
  connect_bd_intf_net -intf_net bandwith_reg_1_OUT_DBG [get_bd_intf_pins axis_register_slice_0/S_AXIS] [get_bd_intf_pins bandwith_reg_1/OUT_DBG]
  connect_bd_intf_net -intf_net cycle_limiter_0_M_AXIS [get_bd_intf_pins bandwith_inputTCP/IN_DBG] [get_bd_intf_pins cycle_limiter_0/M_AXIS]
  connect_bd_intf_net -intf_net datamover_TX_M_AXI [get_bd_intf_pins axi_register_slice_0/S_AXI] [get_bd_intf_pins datamover_TX/M_AXI]
  connect_bd_intf_net -intf_net datamover_TX_M_AXIS_MM2S [get_bd_intf_pins datamover_TX/M_AXIS_MM2S] [get_bd_intf_pins toe_0/s_axis_tx_MM2S]
  connect_bd_intf_net -intf_net datamover_TX_M_AXIS_MM2S_STS [get_bd_intf_pins axi4stream_sinker_0/S_AXIS] [get_bd_intf_pins datamover_TX/M_AXIS_MM2S_STS]
  connect_bd_intf_net -intf_net datamover_TX_M_AXIS_S2MM_STS [get_bd_intf_pins datamover_TX/M_AXIS_S2MM_STS] [get_bd_intf_pins toe_0/s_axis_txwrite_sts_V]
  connect_bd_intf_net -intf_net ddr4_ref_clk_1 [get_bd_intf_pins ddr4_c3_ref_clk] [get_bd_intf_pins memory_controller_c0/C0_SYS_CLK]
  connect_bd_intf_net -intf_net iperf2_client_1_m_App2RxEngRequestData_V [get_bd_intf_pins iperf2_client_1/m_App2RxEngRequestData_V] [get_bd_intf_pins toe_0/s_App2RxEngRequestData_V]
  connect_bd_intf_net -intf_net iperf2_client_1_m_CloseConnRequest_V_V [get_bd_intf_pins iperf2_client_1/m_CloseConnRequest_V_V] [get_bd_intf_pins toe_0/s_CloseConnRequest_V_V]
  connect_bd_intf_net -intf_net iperf2_client_1_m_ListenPortRequest_V_V [get_bd_intf_pins iperf2_client_1/m_ListenPortRequest_V_V] [get_bd_intf_pins toe_0/s_ListenPortRequest_V_V]
  connect_bd_intf_net -intf_net iperf2_client_1_m_OpenConnRequest_V [get_bd_intf_pins iperf2_client_1/m_OpenConnRequest_V] [get_bd_intf_pins toe_0/s_OpenConnRequest_V]
  connect_bd_intf_net -intf_net iperf2_client_1_m_TxDataRequest_V [get_bd_intf_pins iperf2_client_1/m_TxDataRequest_V] [get_bd_intf_pins toe_0/s_TxDataRequest_V]
  connect_bd_intf_net -intf_net iperf2_client_1_m_TxPayload [get_bd_intf_pins iperf2_client_1/m_TxPayload] [get_bd_intf_pins toe_0/s_TxPayload]
  connect_bd_intf_net -intf_net m_axis_session_lup_req [get_bd_intf_pins m_axis_session_lup_req] [get_bd_intf_pins toe_0/m_axis_session_lup_req_V]
  connect_bd_intf_net -intf_net m_axis_session_upd_req [get_bd_intf_pins m_axis_session_upd_req] [get_bd_intf_pins toe_0/m_axis_session_upd_req_V]
  connect_bd_intf_net -intf_net register_TCPin_bandwidth_M_AXIS [get_bd_intf_pins register_TCPin_bandwidth/M_AXIS] [get_bd_intf_pins toe_0/s_axis_tcp_data]
  connect_bd_intf_net -intf_net s_axis_session_lup_rsp [get_bd_intf_pins s_axis_session_lup_rsp] [get_bd_intf_pins toe_0/s_axis_session_lup_rsp_V]
  connect_bd_intf_net -intf_net s_axis_session_upd_rsp [get_bd_intf_pins s_axis_session_upd_rsp] [get_bd_intf_pins toe_0/s_axis_session_upd_rsp_V]
  connect_bd_intf_net -intf_net tcp_checksum_RX_M_AXIS [get_bd_intf_pins tcp_checksum_RX/M_AXIS] [get_bd_intf_pins toe_0/s_axis_rx_pseudo_packet_checksum_V_V]
  connect_bd_intf_net -intf_net tcp_checksum_TX_M_AXIS [get_bd_intf_pins tcp_checksum_TX/M_AXIS] [get_bd_intf_pins toe_0/s_axis_tx_pseudo_packet_checksum_V_V]
  connect_bd_intf_net -intf_net toe_0_m_App2RxEngResponseID_V_V [get_bd_intf_pins iperf2_client_1/s_App2RxEngResponseID_V_V] [get_bd_intf_pins toe_0/m_App2RxEngResponseID_V_V]
  connect_bd_intf_net -intf_net toe_0_m_ListenPortResponse_V [get_bd_intf_pins iperf2_client_1/s_ListenPortResponse_V] [get_bd_intf_pins toe_0/m_ListenPortResponse_V]
  connect_bd_intf_net -intf_net toe_0_m_NewClientNoty_V [get_bd_intf_pins iperf2_client_1/s_NewClientNoty_V] [get_bd_intf_pins toe_0/m_NewClientNoty_V]
  connect_bd_intf_net -intf_net toe_0_m_OpenConnResponse_V [get_bd_intf_pins iperf2_client_1/s_OpenConnResponse_V] [get_bd_intf_pins toe_0/m_OpenConnResponse_V]
  connect_bd_intf_net -intf_net toe_0_m_RxAppNoty_V [get_bd_intf_pins iperf2_client_1/s_RxAppNoty_V] [get_bd_intf_pins toe_0/m_RxAppNoty_V]
  connect_bd_intf_net -intf_net toe_0_m_RxRequestedData [get_bd_intf_pins iperf2_client_1/s_RxRequestedData] [get_bd_intf_pins toe_0/m_RxRequestedData]
  connect_bd_intf_net -intf_net toe_0_m_TxDataResponse_V [get_bd_intf_pins iperf2_client_1/s_TxDataResponse_V] [get_bd_intf_pins toe_0/m_TxDataResponse_V]
  connect_bd_intf_net -intf_net toe_0_m_axis_rx_pseudo_packet [get_bd_intf_pins tcp_checksum_RX/S_AXIS] [get_bd_intf_pins toe_0/m_axis_rx_pseudo_packet]
  connect_bd_intf_net -intf_net toe_0_m_axis_tcp_data [get_bd_intf_pins bandwith_reg_1/IN_DBG] [get_bd_intf_pins toe_0/m_axis_tcp_data]
  connect_bd_intf_net -intf_net toe_0_m_axis_tx_S2MM [get_bd_intf_pins datamover_TX/S_AXIS_S2MM] [get_bd_intf_pins toe_0/m_axis_tx_S2MM]
  connect_bd_intf_net -intf_net toe_0_m_axis_tx_pseudo_packet [get_bd_intf_pins tcp_checksum_TX/S_AXIS] [get_bd_intf_pins toe_0/m_axis_tx_pseudo_packet]
  connect_bd_intf_net -intf_net toe_0_m_axis_txread_cmd_V [get_bd_intf_pins datamover_TX/S_AXIS_MM2S_CMD] [get_bd_intf_pins toe_0/m_axis_txread_cmd_V]
  connect_bd_intf_net -intf_net toe_0_m_axis_txwrite_cmd_V [get_bd_intf_pins datamover_TX/S_AXIS_S2MM_CMD] [get_bd_intf_pins toe_0/m_axis_txwrite_cmd_V]

  # Create port connections
  connect_bd_net -net M00_ARESETN_1 [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
  connect_bd_net -net bandwith_reg_0_debug_slot [get_bd_pins debug_slot_in] [get_bd_pins bandwith_inputTCP/debug_slot]
  connect_bd_net -net bandwith_reg_1_debug_slot [get_bd_pins debug_slot_ou] [get_bd_pins bandwith_reg_1/debug_slot]
  connect_bd_net -net cmac_rx_clk_1 [get_bd_pins cmac_if0_rx_clk] [get_bd_pins axi4stream_sinker_0/CLK] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_register_slice_0/aclk] [get_bd_pins axis_register_slice_0/aclk] [get_bd_pins bandwith_inputTCP/S_AXI_ACLK] [get_bd_pins bandwith_reg_1/S_AXI_ACLK] [get_bd_pins cycle_limiter_0/clk] [get_bd_pins datamover_TX/m_axi_mm2s_aclk] [get_bd_pins datamover_TX/m_axi_s2mm_aclk] [get_bd_pins datamover_TX/m_axis_mm2s_cmdsts_aclk] [get_bd_pins datamover_TX/m_axis_s2mm_cmdsts_awclk] [get_bd_pins iperf2_client_1/ap_clk] [get_bd_pins register_TCPin_bandwidth/aclk] [get_bd_pins tcp_checksum_RX/clk] [get_bd_pins tcp_checksum_TX/clk] [get_bd_pins toe_0/ap_clk]
  connect_bd_net -net fix_settings_0_my_ip_address [get_bd_pins myIpAddress] [get_bd_pins toe_0/myIpAddress_V]
  connect_bd_net -net memory_controller_c0_c0_ddr4_ui_clk1 [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins memory_controller_c0/c0_ddr4_ui_clk] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
  connect_bd_net -net p_arst_n_rx_322_1 [get_bd_pins cmac_if0_rx_rst_n] [get_bd_pins axi4stream_sinker_0/RST_N] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_register_slice_0/aresetn] [get_bd_pins axis_register_slice_0/aresetn] [get_bd_pins bandwith_inputTCP/S_AXI_ARESETN] [get_bd_pins bandwith_reg_1/S_AXI_ARESETN] [get_bd_pins cycle_limiter_0/rst_n] [get_bd_pins datamover_TX/m_axi_mm2s_aresetn] [get_bd_pins datamover_TX/m_axi_s2mm_aresetn] [get_bd_pins datamover_TX/m_axis_mm2s_cmdsts_aresetn] [get_bd_pins datamover_TX/m_axis_s2mm_cmdsts_aresetn] [get_bd_pins iperf2_client_1/ap_rst_n] [get_bd_pins proc_sys_reset_1/ext_reset_in] [get_bd_pins register_TCPin_bandwidth/aresetn] [get_bd_pins tcp_checksum_RX/rst_n] [get_bd_pins tcp_checksum_TX/rst_n] [get_bd_pins toe_0/ap_rst_n]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins memory_controller_c0/c0_ddr4_aresetn] [get_bd_pins proc_sys_reset_1/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_1_peripheral_reset [get_bd_pins memory_controller_c0/sys_rst] [get_bd_pins proc_sys_reset_1/peripheral_reset]
  connect_bd_net -net user_rst_n_1 [get_bd_pins user_rst_n] [get_bd_pins bandwith_inputTCP/user_rst_n] [get_bd_pins bandwith_reg_1/user_rst_n]
  connect_bd_net -net xlconstant_val_0_dout [get_bd_pins memory_controller_c0/c0_ddr4_s_axi_ctrl_bready] [get_bd_pins memory_controller_c0/c0_ddr4_s_axi_ctrl_rready] [get_bd_pins xlconstant_val_0/dout]
  connect_bd_net -net xlconstant_val_1_dout [get_bd_pins memory_controller_c0/c0_ddr4_s_axi_ctrl_arvalid] [get_bd_pins memory_controller_c0/c0_ddr4_s_axi_ctrl_awvalid] [get_bd_pins memory_controller_c0/c0_ddr4_s_axi_ctrl_wvalid] [get_bd_pins xlconstant_val_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ICMP_HANDLER
proc create_hier_cell_ICMP_HANDLER { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ICMP_HANDLER() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 ICMP_IN
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS

  # Create pins
  create_bd_pin -dir I -type clk cmac_if0_rx_clk
  create_bd_pin -dir I -type rst cmac_if0_rx_rst_n
  create_bd_pin -dir O -from 191 -to 0 debug_slot_in
  create_bd_pin -dir O -from 191 -to 0 debug_slot_out
  create_bd_pin -dir I -from 31 -to 0 -type data myIpAddress_V
  create_bd_pin -dir I -type rst user_rst_n

  # Create instance: bandwith_reg_0, and set properties
  set block_name bandwith_reg
  set block_cell_name bandwith_reg_0
  if { [catch {set bandwith_reg_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $bandwith_reg_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.USE_KEEP {1} \
 ] $bandwith_reg_0

  # Create instance: bandwith_reg_1, and set properties
  set block_name bandwith_reg
  set block_cell_name bandwith_reg_1
  if { [catch {set bandwith_reg_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $bandwith_reg_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.USE_KEEP {1} \
 ] $bandwith_reg_1

  # Create instance: icmp_out_bandwidth_slice, and set properties
  set icmp_out_bandwidth_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 icmp_out_bandwidth_slice ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.REG_CONFIG {8} \
   CONFIG.TDATA_NUM_BYTES {64} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $icmp_out_bandwidth_slice

  # Create instance: icmp_server_0, and set properties
  set icmp_server_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:icmp_server:1.0 icmp_server_0 ]

  # Create instance: icmp_slice1, and set properties
  set icmp_slice1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 icmp_slice1 ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.REG_CONFIG {8} \
   CONFIG.TDATA_NUM_BYTES {64} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $icmp_slice1

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M_AXIS] [get_bd_intf_pins icmp_out_bandwidth_slice/M_AXIS]
  connect_bd_intf_net -intf_net ICMP_IN_1 [get_bd_intf_pins ICMP_IN] [get_bd_intf_pins bandwith_reg_1/IN_DBG]
  connect_bd_intf_net -intf_net bandwith_reg_0_OUT_DBG [get_bd_intf_pins bandwith_reg_0/OUT_DBG] [get_bd_intf_pins icmp_out_bandwidth_slice/S_AXIS]
  connect_bd_intf_net -intf_net bandwith_reg_1_OUT_DBG [get_bd_intf_pins bandwith_reg_1/OUT_DBG] [get_bd_intf_pins icmp_slice1/S_AXIS]
  connect_bd_intf_net -intf_net icmp_server_0_m_axis_icmp [get_bd_intf_pins bandwith_reg_0/IN_DBG] [get_bd_intf_pins icmp_server_0/m_axis_icmp]
  connect_bd_intf_net -intf_net icmp_slice1_M_AXIS1 [get_bd_intf_pins icmp_server_0/s_axis_icmp] [get_bd_intf_pins icmp_slice1/M_AXIS]

  # Create port connections
  connect_bd_net -net aresetn_1 [get_bd_pins cmac_if0_rx_rst_n] [get_bd_pins bandwith_reg_0/S_AXI_ARESETN] [get_bd_pins bandwith_reg_1/S_AXI_ARESETN] [get_bd_pins icmp_out_bandwidth_slice/aresetn] [get_bd_pins icmp_server_0/ap_rst_n] [get_bd_pins icmp_slice1/aresetn]
  connect_bd_net -net bandwith_reg_0_debug_slot [get_bd_pins debug_slot_out] [get_bd_pins bandwith_reg_0/debug_slot]
  connect_bd_net -net bandwith_reg_1_debug_slot [get_bd_pins debug_slot_in] [get_bd_pins bandwith_reg_1/debug_slot]
  connect_bd_net -net cmac_tx_clk_1 [get_bd_pins cmac_if0_rx_clk] [get_bd_pins bandwith_reg_0/S_AXI_ACLK] [get_bd_pins bandwith_reg_1/S_AXI_ACLK] [get_bd_pins icmp_out_bandwidth_slice/aclk] [get_bd_pins icmp_server_0/ap_clk] [get_bd_pins icmp_slice1/aclk]
  connect_bd_net -net myIpAddress_V_1 [get_bd_pins myIpAddress_V] [get_bd_pins icmp_server_0/myIpAddress_V]
  connect_bd_net -net user_rst_n_1 [get_bd_pins user_rst_n] [get_bd_pins bandwith_reg_0/user_rst_n] [get_bd_pins bandwith_reg_1/user_rst_n]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ARP
proc create_hier_cell_ARP { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ARP() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 macIpEncode_req
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 macIpEncode_rsp

  # Create pins
  create_bd_pin -dir I -type clk cmac_if0_rx_clk
  create_bd_pin -dir I -type rst cmac_if0_rx_rst_n
  create_bd_pin -dir O -from 191 -to 0 debug_slot
  create_bd_pin -dir I -from 31 -to 0 -type data gatewayIP
  create_bd_pin -dir I -from 31 -to 0 -type data myIpAddress
  create_bd_pin -dir I -from 47 -to 0 -type data myMacAddress
  create_bd_pin -dir I -from 31 -to 0 -type data networkMask
  create_bd_pin -dir I -type rst user_rst_n

  # Create instance: arp_in_slice, and set properties
  set arp_in_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 arp_in_slice ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.REG_CONFIG {8} \
   CONFIG.TDATA_NUM_BYTES {64} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $arp_in_slice

  # Create instance: arp_out_slice, and set properties
  set arp_out_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 arp_out_slice ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.REG_CONFIG {8} \
   CONFIG.TDATA_NUM_BYTES {64} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
 ] $arp_out_slice

  # Create instance: arp_server_0, and set properties
  set arp_server_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:arp_server:1.0 arp_server_0 ]

  # Create instance: bandwith_reg_0, and set properties
  set block_name bandwith_reg
  set block_cell_name bandwith_reg_0
  if { [catch {set bandwith_reg_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $bandwith_reg_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   CONFIG.USE_KEEP {1} \
 ] $bandwith_reg_0

  # Create interface connections
  connect_bd_intf_net -intf_net arp_out_slice1_M_AXIS [get_bd_intf_pins arp_in_slice/M_AXIS] [get_bd_intf_pins arp_server_0/arpDataIn]
  connect_bd_intf_net -intf_net arp_out_slice_M_AXIS [get_bd_intf_pins M_AXIS] [get_bd_intf_pins arp_out_slice/M_AXIS]
  connect_bd_intf_net -intf_net arp_server_0_arpDataOut [get_bd_intf_pins arp_server_0/arpDataOut] [get_bd_intf_pins bandwith_reg_0/IN_DBG]
  connect_bd_intf_net -intf_net arp_server_0_macIpEncode_rsp_V [get_bd_intf_pins macIpEncode_rsp] [get_bd_intf_pins arp_server_0/macIpEncode_rsp_V]
  connect_bd_intf_net -intf_net bandwith_reg_0_OUT_DBG [get_bd_intf_pins arp_out_slice/S_AXIS] [get_bd_intf_pins bandwith_reg_0/OUT_DBG]
  connect_bd_intf_net -intf_net ethernet_header_inserter_0_arpTableRequest_V_V [get_bd_intf_pins macIpEncode_req] [get_bd_intf_pins arp_server_0/macIpEncode_req_V_V]
  connect_bd_intf_net -intf_net traffic_splitter_M00_AXIS [get_bd_intf_pins S_AXIS] [get_bd_intf_pins arp_in_slice/S_AXIS]

  # Create port connections
  connect_bd_net -net bandwith_reg_0_debug_slot [get_bd_pins debug_slot] [get_bd_pins bandwith_reg_0/debug_slot]
  connect_bd_net -net cmac_tx_clk_1 [get_bd_pins cmac_if0_rx_clk] [get_bd_pins arp_in_slice/aclk] [get_bd_pins arp_out_slice/aclk] [get_bd_pins arp_server_0/ap_clk] [get_bd_pins bandwith_reg_0/S_AXI_ACLK]
  connect_bd_net -net fix_settings_0_my_ip_address [get_bd_pins myIpAddress] [get_bd_pins arp_server_0/myIpAddress_V]
  connect_bd_net -net fix_settings_0_my_mac [get_bd_pins myMacAddress] [get_bd_pins arp_server_0/myMacAddress_V]
  connect_bd_net -net gatewayIP_V_1 [get_bd_pins gatewayIP] [get_bd_pins arp_server_0/gatewayIP_V]
  connect_bd_net -net networkMask_V_1 [get_bd_pins networkMask] [get_bd_pins arp_server_0/networkMask_V]
  connect_bd_net -net p_arst_n_tx_322_1 [get_bd_pins cmac_if0_rx_rst_n] [get_bd_pins arp_in_slice/aresetn] [get_bd_pins arp_out_slice/aresetn] [get_bd_pins arp_server_0/ap_rst_n] [get_bd_pins bandwith_reg_0/S_AXI_ARESETN]
  connect_bd_net -net reg_debug_0_user_rst_n [get_bd_pins user_rst_n] [get_bd_pins bandwith_reg_0/user_rst_n]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: synq_reset_system
proc create_hier_cell_synq_reset_system { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_synq_reset_system() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk clk_100MHz
  create_bd_pin -dir O -from 0 -to 0 -type rst clk_100_i_rst_n
  create_bd_pin -dir O -from 0 -to 0 -type rst clk_100_p_rst
  create_bd_pin -dir O -from 0 -to 0 -type rst clk_100_rst_n
  create_bd_pin -dir I -type clk cmac_if0_rx_clk
  create_bd_pin -dir O -from 0 -to 0 -type rst cmac_if0_rx_p_rst_n
  create_bd_pin -dir O -from 0 -to 0 -type rst cmac_if0_rx_rst_n
  create_bd_pin -dir I -type clk cmac_if0_tx_clk
  create_bd_pin -dir O -from 0 -to 0 -type rst cmac_if0_tx_rst_n
  create_bd_pin -dir I -type rst dma_reset_n

  # Create instance: proc_reset_clk_100, and set properties
  set proc_reset_clk_100 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_reset_clk_100 ]

  # Create instance: proc_rst_clk_tx_322, and set properties
  set proc_rst_clk_tx_322 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_rst_clk_tx_322 ]

  # Create instance: proc_rst_rx_clk_322, and set properties
  set proc_rst_rx_clk_322 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_rst_rx_clk_322 ]

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_pins clk_100MHz] [get_bd_pins proc_reset_clk_100/slowest_sync_clk]
  connect_bd_net -net proc_reset_clk_100_peripheral_aresetn [get_bd_pins clk_100_rst_n] [get_bd_pins proc_reset_clk_100/peripheral_aresetn]
  connect_bd_net -net proc_reset_clk_100_peripheral_reset [get_bd_pins clk_100_p_rst] [get_bd_pins proc_reset_clk_100/peripheral_reset]
  connect_bd_net -net proc_reset_clk_100_proc_rst_rx_clk_322_peripheral_aresetn [get_bd_pins clk_100_i_rst_n] [get_bd_pins proc_reset_clk_100/interconnect_aresetn]
  connect_bd_net -net proc_rst_clk_tx_322_peripheral_aresetn [get_bd_pins cmac_if0_tx_rst_n] [get_bd_pins proc_rst_clk_tx_322/peripheral_aresetn]
  connect_bd_net -net proc_rst_rx_clk_322_interconnect_aresetn [get_bd_pins cmac_if0_rx_p_rst_n] [get_bd_pins proc_rst_rx_clk_322/interconnect_aresetn]
  connect_bd_net -net proc_rst_rx_clk_322_peripheral_aresetn [get_bd_pins cmac_if0_rx_rst_n] [get_bd_pins proc_rst_rx_clk_322/peripheral_aresetn]
  connect_bd_net -net slowest_sync_clk3_1 [get_bd_pins cmac_if0_rx_clk] [get_bd_pins proc_rst_rx_clk_322/slowest_sync_clk]
  connect_bd_net -net traffic_generator_pcie_reset [get_bd_pins dma_reset_n] [get_bd_pins proc_reset_clk_100/ext_reset_in] [get_bd_pins proc_rst_clk_tx_322/ext_reset_in] [get_bd_pins proc_rst_rx_clk_322/ext_reset_in]
  connect_bd_net -net traffic_generator_usr_tx_clk [get_bd_pins cmac_if0_tx_clk] [get_bd_pins proc_rst_clk_tx_322/slowest_sync_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: interface_0_handler
proc create_hier_cell_interface_0_handler { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_interface_0_handler() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 C3_DDR4
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 IF_SETTINGS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 IPERF_CONF
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 RX_DEBUG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 RX_TRAFFIC
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 TX_TRAFFIC
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr4_c3_ref_clk
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_session_lup_req
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_session_upd_req
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_session_lup_rsp
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_session_upd_rsp

  # Create pins
  create_bd_pin -dir I -type clk cmac_if0_rx_clk
  create_bd_pin -dir I -from 0 -to 0 cmac_if0_rx_rst_n
  create_bd_pin -dir I -type clk cmac_if0_tx_clk
  create_bd_pin -dir I -type rst cmac_if0_tx_rst_n

  # Create instance: ARP
  create_hier_cell_ARP $hier_obj ARP

  # Create instance: ICMP_HANDLER
  create_hier_cell_ICMP_HANDLER $hier_obj ICMP_HANDLER

  # Create instance: TCP
  create_hier_cell_TCP $hier_obj TCP

  # Create instance: Traffic_Agregation
  create_hier_cell_Traffic_Agregation $hier_obj Traffic_Agregation

  # Create instance: Traffic_Identification
  create_hier_cell_Traffic_Identification $hier_obj Traffic_Identification

  # Create instance: interface_settings_0, and set properties
  set block_name interface_settings
  set block_cell_name interface_settings_0
  if { [catch {set interface_settings_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $interface_settings_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: performance_debug_reg_0, and set properties
  set block_name performance_debug_reg
  set block_cell_name performance_debug_reg_0
  if { [catch {set performance_debug_reg_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $performance_debug_reg_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {192} \
 ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins C3_DDR4] [get_bd_intf_pins TCP/C3_DDR4]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins ddr4_c3_ref_clk] [get_bd_intf_pins TCP/ddr4_c3_ref_clk]
  connect_bd_intf_net -intf_net ICMP_HANDLER_M_AXIS [get_bd_intf_pins ICMP_HANDLER/M_AXIS] [get_bd_intf_pins Traffic_Agregation/ICMP]
  connect_bd_intf_net -intf_net RX_DEBUG_1 [get_bd_intf_pins RX_DEBUG] [get_bd_intf_pins performance_debug_reg_0/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins IF_SETTINGS] [get_bd_intf_pins interface_settings_0/S_AXI]
  connect_bd_intf_net -intf_net TCP_M_AXIS [get_bd_intf_pins TCP/M_AXIS] [get_bd_intf_pins Traffic_Agregation/TCP]
  connect_bd_intf_net -intf_net Traffic_Agregation_M_AXIS [get_bd_intf_pins TX_TRAFFIC] [get_bd_intf_pins Traffic_Agregation/TX_TRAFFIC]
  connect_bd_intf_net -intf_net arp_out_slice_M_AXIS [get_bd_intf_pins ARP/M_AXIS] [get_bd_intf_pins Traffic_Agregation/ARP]
  connect_bd_intf_net -intf_net arp_server_0_macIpEncode_rsp_V [get_bd_intf_pins ARP/macIpEncode_rsp] [get_bd_intf_pins Traffic_Agregation/arpTableReplay]
  connect_bd_intf_net -intf_net ethernet_header_inserter_0_arpTableRequest_V_V [get_bd_intf_pins ARP/macIpEncode_req] [get_bd_intf_pins Traffic_Agregation/arpTableRequest_V_V]
  connect_bd_intf_net -intf_net m_axis_session_lup_req [get_bd_intf_pins m_axis_session_lup_req] [get_bd_intf_pins TCP/m_axis_session_lup_req]
  connect_bd_intf_net -intf_net m_axis_session_upd_req [get_bd_intf_pins m_axis_session_upd_req] [get_bd_intf_pins TCP/m_axis_session_upd_req]
  connect_bd_intf_net -intf_net s_axi_settings_1 [get_bd_intf_pins IPERF_CONF] [get_bd_intf_pins TCP/IPERF_CONF]
  connect_bd_intf_net -intf_net s_axis_session_lup_rsp [get_bd_intf_pins s_axis_session_lup_rsp] [get_bd_intf_pins TCP/s_axis_session_lup_rsp]
  connect_bd_intf_net -intf_net s_axis_session_upd_rsp [get_bd_intf_pins s_axis_session_upd_rsp] [get_bd_intf_pins TCP/s_axis_session_upd_rsp]
  connect_bd_intf_net -intf_net traffic_generator_LBUS2AXI [get_bd_intf_pins RX_TRAFFIC] [get_bd_intf_pins Traffic_Identification/S_AXIS]
  connect_bd_intf_net -intf_net traffic_splitter_M00_AXIS [get_bd_intf_pins ARP/S_AXIS] [get_bd_intf_pins Traffic_Identification/ARP]
  connect_bd_intf_net -intf_net traffic_splitter_M01_AXIS [get_bd_intf_pins ICMP_HANDLER/ICMP_IN] [get_bd_intf_pins Traffic_Identification/ICMP]
  connect_bd_intf_net -intf_net traffic_splitter_M02_AXIS [get_bd_intf_pins TCP/TCP] [get_bd_intf_pins Traffic_Identification/TCP]

  # Create port connections
  connect_bd_net -net ARP_debug_slot [get_bd_pins ARP/debug_slot] [get_bd_pins performance_debug_reg_0/PORT2]
  connect_bd_net -net CMAC_CLK_1 [get_bd_pins cmac_if0_rx_clk] [get_bd_pins ARP/cmac_if0_rx_clk] [get_bd_pins ICMP_HANDLER/cmac_if0_rx_clk] [get_bd_pins TCP/cmac_if0_rx_clk] [get_bd_pins Traffic_Agregation/cmac_if0_rx_clk] [get_bd_pins Traffic_Identification/cmac_if0_rx_clk] [get_bd_pins interface_settings_0/S_AXI_ACLK] [get_bd_pins performance_debug_reg_0/S_AXI_ACLK]
  connect_bd_net -net ICMP_HANDLER_debug_slot_in [get_bd_pins ICMP_HANDLER/debug_slot_in] [get_bd_pins performance_debug_reg_0/PORT3]
  connect_bd_net -net ICMP_HANDLER_debug_slot_out [get_bd_pins ICMP_HANDLER/debug_slot_out] [get_bd_pins performance_debug_reg_0/PORT4]
  connect_bd_net -net TCP_debug_slot_in [get_bd_pins TCP/debug_slot_in] [get_bd_pins performance_debug_reg_0/PORT5]
  connect_bd_net -net TCP_debug_slot_ou [get_bd_pins TCP/debug_slot_ou] [get_bd_pins performance_debug_reg_0/PORT6]
  connect_bd_net -net Traffic_Agregation_debug_slot [get_bd_pins Traffic_Agregation/debug_slot] [get_bd_pins performance_debug_reg_0/PORT8]
  connect_bd_net -net Traffic_Identification_debug_slot_udp [get_bd_pins Traffic_Identification/debug_slot_udp] [get_bd_pins performance_debug_reg_0/PORT7]
  connect_bd_net -net bandwith_cmac_1_debug_slot [get_bd_pins Traffic_Identification/debug_slot_packet_handler] [get_bd_pins performance_debug_reg_0/PORT1]
  connect_bd_net -net bandwith_reg_0_debug_slot [get_bd_pins Traffic_Identification/debug_slot_input_traffic] [get_bd_pins performance_debug_reg_0/PORT0]
  connect_bd_net -net cmac_tx_clk_1 [get_bd_pins cmac_if0_tx_clk] [get_bd_pins Traffic_Agregation/cmac_if0_tx_clk]
  connect_bd_net -net fix_settings_0_my_ip_address [get_bd_pins ARP/myIpAddress] [get_bd_pins ICMP_HANDLER/myIpAddress_V] [get_bd_pins TCP/myIpAddress] [get_bd_pins interface_settings_0/my_ip_address]
  connect_bd_net -net fix_settings_0_my_mac [get_bd_pins ARP/myMacAddress] [get_bd_pins Traffic_Agregation/myMacAddress] [get_bd_pins interface_settings_0/my_mac]
  connect_bd_net -net interface_settings_0_my_gateway [get_bd_pins ARP/gatewayIP] [get_bd_pins Traffic_Agregation/regDefaultGateway] [get_bd_pins interface_settings_0/my_gateway]
  connect_bd_net -net interface_settings_0_my_ip_subnet_mask [get_bd_pins ARP/networkMask] [get_bd_pins Traffic_Agregation/regSubNetMask] [get_bd_pins interface_settings_0/my_ip_subnet_mask]
  connect_bd_net -net p_arst_n_322_1 [get_bd_pins cmac_if0_rx_rst_n] [get_bd_pins ARP/cmac_if0_rx_rst_n] [get_bd_pins ICMP_HANDLER/cmac_if0_rx_rst_n] [get_bd_pins TCP/cmac_if0_rx_rst_n] [get_bd_pins Traffic_Agregation/cmac_if0_rx_rst_n] [get_bd_pins Traffic_Identification/cmac_if0_rx_rst_n] [get_bd_pins interface_settings_0/S_AXI_ARESETN] [get_bd_pins performance_debug_reg_0/S_AXI_ARESETN]
  connect_bd_net -net p_arst_n_tx_322_1 [get_bd_pins cmac_if0_tx_rst_n] [get_bd_pins Traffic_Agregation/cmac_if0_tx_rst_n]
  connect_bd_net -net reg_debug_0_user_rst_n_1 [get_bd_pins ARP/user_rst_n] [get_bd_pins ICMP_HANDLER/user_rst_n] [get_bd_pins TCP/user_rst_n] [get_bd_pins Traffic_Agregation/user_rst_n] [get_bd_pins Traffic_Identification/user_rst_n] [get_bd_pins performance_debug_reg_0/user_rst_n]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins performance_debug_reg_0/PORT9] [get_bd_pins xlconstant_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Memory_Mapped
proc create_hier_cell_Memory_Mapped { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_Memory_Mapped() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 IF_SETTINGS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 IPERF_CONF
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 QSFP0
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 RX_DEBUG
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_refclk

  # Create pins
  create_bd_pin -dir I -type clk clk_100MHz
  create_bd_pin -dir I -type clk cmac_if0_rx_clk
  create_bd_pin -dir O dma_user_clk
  create_bd_pin -dir I -type rst i_arst_n_100
  create_bd_pin -dir I -type rst i_arst_n_rx_322
  create_bd_pin -dir I -type rst p_arst_n_100
  create_bd_pin -dir O -from 0 -to 0 pcie_reset_n
  create_bd_pin -dir I pcie_user_rst_n

  # Create instance: axi4stream_constant_1, and set properties
  set block_name axi4stream_constant
  set block_cell_name axi4stream_constant_1
  if { [catch {set axi4stream_constant_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi4stream_constant_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.C_AXI_TDATA_WIDTH {64} \
   CONFIG.C_AXI_TSTRB_WIDTH {8} \
 ] $axi4stream_constant_1

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.ENABLE_ADVANCED_OPTIONS {1} \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {2} \
 ] $axi_interconnect_0

  # Create instance: axi_register_slice_0, and set properties
  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_0 ]
  set_property -dict [ list \
   CONFIG.REG_AR {10} \
   CONFIG.REG_AW {10} \
   CONFIG.REG_B {10} \
   CONFIG.REG_R {10} \
   CONFIG.REG_W {10} \
 ] $axi_register_slice_0

  # Create instance: dma_sinker, and set properties
  set block_name axi4stream_sinker
  set block_cell_name dma_sinker
  if { [catch {set dma_sinker [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dma_sinker eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.C_AXI_TDATA_WIDTH {64} \
 ] $dma_sinker

  # Create instance: jtag_axi_0, and set properties
  set jtag_axi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi_0 ]

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_0 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
 ] $util_ds_buf_0

  # Create instance: xdma_0, and set properties
  set xdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_0 ]
  set_property -dict [ list \
   CONFIG.xdma_axi_intf_mm {AXI_Stream} \
 ] $xdma_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins pcie_refclk] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins pcie_mgt] [get_bd_intf_pins xdma_0/pcie_mgt]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins axi_register_slice_0/M_AXI]
  connect_bd_intf_net -intf_net S01_AXI_1 [get_bd_intf_pins axi_interconnect_0/S01_AXI] [get_bd_intf_pins jtag_axi_0/M_AXI]
  connect_bd_intf_net -intf_net S_AXI_LITE_1 [get_bd_intf_pins RX_DEBUG] [get_bd_intf_pins axi_interconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net axi4stream_constant_1_M_AXIS [get_bd_intf_pins axi4stream_constant_1/M_AXIS] [get_bd_intf_pins xdma_0/S_AXIS_C2H_0]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins QSFP0] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins IF_SETTINGS] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins IPERF_CONF] [get_bd_intf_pins axi_interconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net xdma_0_M_AXIS_H2C_0 [get_bd_intf_pins dma_sinker/S_AXIS] [get_bd_intf_pins xdma_0/M_AXIS_H2C_0]

  # Create port connections
  connect_bd_net -net CMAC_CLK_1 [get_bd_pins cmac_if0_rx_clk] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK]
  connect_bd_net -net M04_ARESETN_1 [get_bd_pins i_arst_n_rx_322] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN]
  connect_bd_net -net S00_ACLK_1 [get_bd_pins dma_user_clk] [get_bd_pins axi4stream_constant_1/CLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_register_slice_0/aclk] [get_bd_pins dma_sinker/CLK] [get_bd_pins xdma_0/axi_aclk]
  connect_bd_net -net clk_1 [get_bd_pins clk_100MHz] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins jtag_axi_0/aclk]
  connect_bd_net -net pcie_rst_n_1 [get_bd_pins pcie_user_rst_n] [get_bd_pins xdma_0/sys_rst_n]
  connect_bd_net -net proc_reset_clk_100_interconnect_aresetn [get_bd_pins i_arst_n_100] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN]
  connect_bd_net -net proc_reset_clk_100_peripheral_aresetn [get_bd_pins p_arst_n_100] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins jtag_axi_0/aresetn]
  connect_bd_net -net traffic_generator_dma_reset_n [get_bd_pins pcie_reset_n] [get_bd_pins axi4stream_constant_1/RST_N] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_register_slice_0/aresetn] [get_bd_pins dma_sinker/RST_N] [get_bd_pins xdma_0/axi_aresetn]
  connect_bd_net -net util_ds_buf_0_IBUF_DS_ODIV2 [get_bd_pins util_ds_buf_0/IBUF_DS_ODIV2] [get_bd_pins xdma_0/sys_clk]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins xdma_0/sys_clk_gt]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xdma_0/usr_irq_req] [get_bd_pins xlconstant_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Interfaces
proc create_hier_cell_Interfaces { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_Interfaces() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 QSFP0
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 Rx_Traffic_0
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 TX_Traffic_0
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt_if0_ref_clk
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:gt_rtl:1.0 gt_if0_rx
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 gt_if0_tx

  # Create pins
  create_bd_pin -dir I -type clk clk_100MHz
  create_bd_pin -dir O -type clk cmac_if0_rx_clk
  create_bd_pin -dir O cmac_if0_tx_clk
  create_bd_pin -dir I -type rst p_arst_n_100
  create_bd_pin -dir O -from 1 -to 0 qsfp_if0_freqSel
  create_bd_pin -dir I qsfp_if0_intl_n
  create_bd_pin -dir O qsfp_if0_lpmode
  create_bd_pin -dir I qsfp_if0_modprsl_n
  create_bd_pin -dir O qsfp_if0_modsel_n
  create_bd_pin -dir O qsfp_if0_reset_n
  create_bd_pin -dir I s_axi_sreset

  # Create instance: cmac_interconnect, and set properties
  set cmac_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 cmac_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
 ] $cmac_interconnect

  # Create instance: cmac_sync_0, and set properties
  set cmac_sync_0 [ create_bd_cell -type ip -vlnv naudit:cmac:cmac_sync:1 cmac_sync_0 ]
  set_property -dict [ list \
   CONFIG.ULTRASCALE_PLUS {true} \
 ] $cmac_sync_0

  # Create instance: cmac_wrapper_0, and set properties
  set cmac_wrapper_0 [ create_bd_cell -type ip -vlnv naudit:cmac:cmac_ALVEOu200_0:1 cmac_wrapper_0 ]

  # Create instance: freqSel, and set properties
  set freqSel [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 freqSel ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {3} \
   CONFIG.CONST_WIDTH {2} \
 ] $freqSel

  # Create instance: qsfp28_cage_control_0, and set properties
  set block_name qsfp28_cage_control
  set block_cell_name qsfp28_cage_control_0
  if { [catch {set qsfp28_cage_control_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $qsfp28_cage_control_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: vio_cmac_synq_0, and set properties
  set vio_cmac_synq_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_cmac_synq_0 ]
  set_property -dict [ list \
   CONFIG.C_NUM_PROBE_IN {9} \
   CONFIG.C_NUM_PROBE_OUT {0} \
 ] $vio_cmac_synq_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_STATISTICS_1 [get_bd_intf_pins QSFP0] [get_bd_intf_pins cmac_interconnect/S01_AXI]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins TX_Traffic_0] [get_bd_intf_pins cmac_wrapper_0/AXI2LBUS]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins Rx_Traffic_0] [get_bd_intf_pins cmac_wrapper_0/LBUS2AXI]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins gt_if0_tx] [get_bd_intf_pins cmac_wrapper_0/gt_tx]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins gt_if0_rx] [get_bd_intf_pins cmac_wrapper_0/gt_rx]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins gt_if0_ref_clk] [get_bd_intf_pins cmac_wrapper_0/gt_ref_clk]
  connect_bd_intf_net -intf_net cmac_interconnect_M01_AXI [get_bd_intf_pins cmac_interconnect/M01_AXI] [get_bd_intf_pins qsfp28_cage_control_0/QSFP_CONTROL]
  connect_bd_intf_net -intf_net cmac_sync_0_s_axi [get_bd_intf_pins cmac_interconnect/S00_AXI] [get_bd_intf_pins cmac_sync_0/s_axi]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins cmac_interconnect/M00_AXI] [get_bd_intf_pins cmac_wrapper_0/AXI4_STATISTICS]

  # Create port connections
  connect_bd_net -net aresetn_1 [get_bd_pins p_arst_n_100] [get_bd_pins cmac_interconnect/aresetn] [get_bd_pins cmac_wrapper_0/s_axi_reset_n] [get_bd_pins qsfp28_cage_control_0/S_AXI_ARESETN]
  connect_bd_net -net cmac_sync_0_cmac_aligned_sync [get_bd_pins cmac_sync_0/cmac_aligned_sync] [get_bd_pins vio_cmac_synq_0/probe_in7]
  connect_bd_net -net cmac_sync_0_rx_aligned_led [get_bd_pins cmac_sync_0/rx_aligned_led] [get_bd_pins vio_cmac_synq_0/probe_in3]
  connect_bd_net -net cmac_sync_0_rx_busy_led [get_bd_pins cmac_sync_0/rx_busy_led] [get_bd_pins vio_cmac_synq_0/probe_in6]
  connect_bd_net -net cmac_sync_0_rx_data_fail_led [get_bd_pins cmac_sync_0/rx_data_fail_led] [get_bd_pins vio_cmac_synq_0/probe_in5]
  connect_bd_net -net cmac_sync_0_rx_done_led [get_bd_pins cmac_sync_0/rx_done_led] [get_bd_pins vio_cmac_synq_0/probe_in4]
  connect_bd_net -net cmac_sync_0_rx_gt_locked_led [get_bd_pins cmac_sync_0/rx_gt_locked_led] [get_bd_pins vio_cmac_synq_0/probe_in2]
  connect_bd_net -net cmac_sync_0_tx_busy_led [get_bd_pins cmac_sync_0/tx_busy_led] [get_bd_pins vio_cmac_synq_0/probe_in1]
  connect_bd_net -net cmac_sync_0_tx_done_led [get_bd_pins cmac_sync_0/tx_done_led] [get_bd_pins vio_cmac_synq_0/probe_in0]
  connect_bd_net -net cmac_wrapper_0_tx_rst [get_bd_pins cmac_sync_0/usr_tx_reset] [get_bd_pins cmac_wrapper_0/tx_rst]
  connect_bd_net -net cmac_wrapper_0_usr_clk [get_bd_pins cmac_if0_tx_clk] [get_bd_pins cmac_wrapper_0/usr_tx_clk]
  connect_bd_net -net cmac_wrapper_0_usr_rx_clk [get_bd_pins cmac_if0_rx_clk] [get_bd_pins cmac_wrapper_0/usr_rx_clk]
  connect_bd_net -net cmac_wrapper_if0_rx_rst_asynq [get_bd_pins cmac_sync_0/usr_rx_reset] [get_bd_pins cmac_wrapper_0/rx_rst]
  connect_bd_net -net cmac_wrapper_if0_stat_rx_aligned_asynq [get_bd_pins cmac_sync_0/cmac_stat_stat_rx_aligned] [get_bd_pins cmac_wrapper_0/CMAC_STAT_stat_rx_aligned]
  connect_bd_net -net freqSel_dout [get_bd_pins qsfp_if0_freqSel] [get_bd_pins freqSel/dout]
  connect_bd_net -net init_clk_1 [get_bd_pins clk_100MHz] [get_bd_pins cmac_interconnect/aclk] [get_bd_pins cmac_sync_0/s_axi_aclk] [get_bd_pins cmac_wrapper_0/s_axi_aclk] [get_bd_pins qsfp28_cage_control_0/S_AXI_ACLK] [get_bd_pins vio_cmac_synq_0/clk]
  connect_bd_net -net qsfp28_cage_control_0_qsfp_lpmode [get_bd_pins qsfp_if0_lpmode] [get_bd_pins qsfp28_cage_control_0/qsfp_lpmode]
  connect_bd_net -net qsfp28_cage_control_0_qsfp_modsel_n [get_bd_pins qsfp_if0_modsel_n] [get_bd_pins qsfp28_cage_control_0/qsfp_modsel_n]
  connect_bd_net -net qsfp28_cage_control_0_qsfp_present_led [get_bd_pins qsfp28_cage_control_0/qsfp_present_led] [get_bd_pins vio_cmac_synq_0/probe_in8]
  connect_bd_net -net qsfp28_cage_control_0_qsfp_reset_n [get_bd_pins qsfp_if0_reset_n] [get_bd_pins qsfp28_cage_control_0/qsfp_reset_n]
  connect_bd_net -net qsfp_intl_n_1 [get_bd_pins qsfp_if0_intl_n] [get_bd_pins qsfp28_cage_control_0/qsfp_intl_n]
  connect_bd_net -net qsfp_modprsl_n_1 [get_bd_pins qsfp_if0_modprsl_n] [get_bd_pins qsfp28_cage_control_0/qsfp_modprsl_n]
  connect_bd_net -net sys_reset_1 [get_bd_pins s_axi_sreset] [get_bd_pins cmac_sync_0/s_axi_sreset]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins cmac_sync_0/lbus_tx_rx_restart_in] [get_bd_pins xlconstant_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set C3_DDR4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 C3_DDR4 ]
  set ddr4_c3_ref_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr4_c3_ref_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {300000000} \
   ] $ddr4_c3_ref_clk
  set gt_if0_ref_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt_if0_ref_clk ]
  set gt_if0_rx [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:gt_rtl:1.0 gt_if0_rx ]
  set gt_if0_tx [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 gt_if0_tx ]
  set m_axis_session_lup_req [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_tlm:1.0 m_axis_session_lup_req ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {322265625} \
   ] $m_axis_session_lup_req
  set m_axis_session_upd_req [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_session_upd_req ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {322265625} \
   ] $m_axis_session_upd_req
  set pcie_mgt [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt ]
  set pcie_refclk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_refclk ]
  set s_axis_session_lup_rsp [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_session_lup_rsp ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {322265625} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {11} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $s_axis_session_lup_rsp
  set s_axis_session_upd_rsp [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_session_upd_rsp ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {322265625} \
   CONFIG.HAS_TKEEP {0} \
   CONFIG.HAS_TLAST {0} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {11} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $s_axis_session_upd_rsp
  set sys_clkref [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clkref ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
   ] $sys_clkref

  # Create ports
  set cmac_if0_rx_clk [ create_bd_port -dir O -type clk cmac_if0_rx_clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {m_axis_session_lup_req:m_axis_session_upd_req:s_axis_session_lup_rsp:s_axis_session_upd_rsp} \
   CONFIG.ASSOCIATED_RESET {cmac_if0_rx_rst_n} \
   CONFIG.FREQ_HZ {322265625} \
 ] $cmac_if0_rx_clk
  set cmac_if0_rx_rst_n [ create_bd_port -dir O -from 0 -to 0 -type rst cmac_if0_rx_rst_n ]
  set pcie_rst_n [ create_bd_port -dir I pcie_rst_n ]
  set qsfp_if0_freqSel [ create_bd_port -dir O -from 1 -to 0 qsfp_if0_freqSel ]
  set qsfp_if0_intl_n [ create_bd_port -dir I qsfp_if0_intl_n ]
  set qsfp_if0_lpmode [ create_bd_port -dir O qsfp_if0_lpmode ]
  set qsfp_if0_modprsl_n [ create_bd_port -dir I qsfp_if0_modprsl_n ]
  set qsfp_if0_modsel_n [ create_bd_port -dir O qsfp_if0_modsel_n ]
  set qsfp_if0_reset_n [ create_bd_port -dir O qsfp_if0_reset_n ]

  # Create instance: Interfaces
  create_hier_cell_Interfaces [current_bd_instance .] Interfaces

  # Create instance: Memory_Mapped
  create_hier_cell_Memory_Mapped [current_bd_instance .] Memory_Mapped

  # Create instance: clock_source, and set properties
  set clock_source [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clock_source ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {64.0} \
   CONFIG.CLKOUT1_JITTER {163.213} \
   CONFIG.CLKOUT1_PHASE_ERROR {184.532} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {38.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {6.400} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {11.875} \
   CONFIG.MMCM_DIVCLK_DIVIDE {5} \
   CONFIG.PRIM_IN_FREQ {156.250} \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
   CONFIG.USE_LOCKED {false} \
   CONFIG.USE_RESET {false} \
 ] $clock_source

  # Create instance: interface_0_handler
  create_hier_cell_interface_0_handler [current_bd_instance .] interface_0_handler

  # Create instance: synq_reset_system
  create_hier_cell_synq_reset_system [current_bd_instance .] synq_reset_system

  # Create interface connections
  connect_bd_intf_net -intf_net C0_SYS_CLK_0_1 [get_bd_intf_ports ddr4_c3_ref_clk] [get_bd_intf_pins interface_0_handler/ddr4_c3_ref_clk]
  connect_bd_intf_net -intf_net CLK_IN_D_0_1 [get_bd_intf_ports pcie_refclk] [get_bd_intf_pins Memory_Mapped/pcie_refclk]
  connect_bd_intf_net -intf_net Memory_Mapped_M03_AXI [get_bd_intf_pins Memory_Mapped/IPERF_CONF] [get_bd_intf_pins interface_0_handler/IPERF_CONF]
  connect_bd_intf_net -intf_net Memory_Mapped_M04_AXI [get_bd_intf_pins Memory_Mapped/IF_SETTINGS] [get_bd_intf_pins interface_0_handler/IF_SETTINGS]
  connect_bd_intf_net -intf_net S_AXI_LITE_1 [get_bd_intf_pins Memory_Mapped/RX_DEBUG] [get_bd_intf_pins interface_0_handler/RX_DEBUG]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins Interfaces/QSFP0] [get_bd_intf_pins Memory_Mapped/QSFP0]
  connect_bd_intf_net -intf_net cmac_slice_M_AXIS [get_bd_intf_pins Interfaces/TX_Traffic_0] [get_bd_intf_pins interface_0_handler/TX_TRAFFIC]
  connect_bd_intf_net -intf_net gt_ref_clk_0_1 [get_bd_intf_ports gt_if0_ref_clk] [get_bd_intf_pins Interfaces/gt_if0_ref_clk]
  connect_bd_intf_net -intf_net gt_rx_0_1 [get_bd_intf_ports gt_if0_rx] [get_bd_intf_pins Interfaces/gt_if0_rx]
  connect_bd_intf_net -intf_net interface_0_handler_m_axis_session_lup_req1 [get_bd_intf_ports m_axis_session_lup_req] [get_bd_intf_pins interface_0_handler/m_axis_session_lup_req]
  connect_bd_intf_net -intf_net interface_0_handler_m_axis_session_upd_req_V_0 [get_bd_intf_ports m_axis_session_upd_req] [get_bd_intf_pins interface_0_handler/m_axis_session_upd_req]
  connect_bd_intf_net -intf_net s_axis_session_lup_rsp_V_0_1 [get_bd_intf_ports s_axis_session_lup_rsp] [get_bd_intf_pins interface_0_handler/s_axis_session_lup_rsp]
  connect_bd_intf_net -intf_net s_axis_session_upd_rsp_V_0_1 [get_bd_intf_ports s_axis_session_upd_rsp] [get_bd_intf_pins interface_0_handler/s_axis_session_upd_rsp]
  connect_bd_intf_net -intf_net sys_clkref_1 [get_bd_intf_ports sys_clkref] [get_bd_intf_pins clock_source/CLK_IN1_D]
  connect_bd_intf_net -intf_net top_design_C0_DDR4_0 [get_bd_intf_ports C3_DDR4] [get_bd_intf_pins interface_0_handler/C3_DDR4]
  connect_bd_intf_net -intf_net top_design_gt_tx_0 [get_bd_intf_ports gt_if0_tx] [get_bd_intf_pins Interfaces/gt_if0_tx]
  connect_bd_intf_net -intf_net top_design_pcie_mgt_0 [get_bd_intf_ports pcie_mgt] [get_bd_intf_pins Memory_Mapped/pcie_mgt]
  connect_bd_intf_net -intf_net traffic_generator_LBUS2AXI [get_bd_intf_pins Interfaces/Rx_Traffic_0] [get_bd_intf_pins interface_0_handler/RX_TRAFFIC]

  # Create port connections
  connect_bd_net -net Interfaces_dout_0 [get_bd_ports qsfp_if0_freqSel] [get_bd_pins Interfaces/qsfp_if0_freqSel]
  connect_bd_net -net Interfaces_usr_rx_clk_0 [get_bd_ports cmac_if0_rx_clk] [get_bd_pins Interfaces/cmac_if0_rx_clk] [get_bd_pins Memory_Mapped/cmac_if0_rx_clk] [get_bd_pins interface_0_handler/cmac_if0_rx_clk] [get_bd_pins synq_reset_system/cmac_if0_rx_clk]
  connect_bd_net -net clk_1 [get_bd_pins Interfaces/clk_100MHz] [get_bd_pins Memory_Mapped/clk_100MHz] [get_bd_pins clock_source/clk_out1] [get_bd_pins synq_reset_system/clk_100MHz]
  connect_bd_net -net clk_100_i_rst_n_synq [get_bd_pins Memory_Mapped/i_arst_n_100] [get_bd_pins synq_reset_system/clk_100_i_rst_n]
  connect_bd_net -net clk_100_p_rst_syqn [get_bd_pins Interfaces/s_axi_sreset] [get_bd_pins synq_reset_system/clk_100_p_rst]
  connect_bd_net -net clk_100_rst_n_synq [get_bd_pins Interfaces/p_arst_n_100] [get_bd_pins Memory_Mapped/p_arst_n_100] [get_bd_pins synq_reset_system/clk_100_rst_n]
  connect_bd_net -net cmac_if0_rx_p_rst_n_synq [get_bd_pins Memory_Mapped/i_arst_n_rx_322] [get_bd_pins synq_reset_system/cmac_if0_rx_p_rst_n]
  connect_bd_net -net cmac_if0_rx_rst_n_synq [get_bd_ports cmac_if0_rx_rst_n] [get_bd_pins interface_0_handler/cmac_if0_rx_rst_n] [get_bd_pins synq_reset_system/cmac_if0_rx_rst_n]
  connect_bd_net -net cmac_if0_tx_rst_n_synq [get_bd_pins interface_0_handler/cmac_if0_tx_rst_n] [get_bd_pins synq_reset_system/cmac_if0_tx_rst_n]
  connect_bd_net -net pcie_rst_n_1 [get_bd_ports pcie_rst_n] [get_bd_pins Memory_Mapped/pcie_user_rst_n]
  connect_bd_net -net qsfp_intl_n_1 [get_bd_ports qsfp_if0_intl_n] [get_bd_pins Interfaces/qsfp_if0_intl_n]
  connect_bd_net -net qsfp_modprsl_n_1 [get_bd_ports qsfp_if0_modprsl_n] [get_bd_pins Interfaces/qsfp_if0_modprsl_n]
  connect_bd_net -net top_design_qsfp_lpmode [get_bd_ports qsfp_if0_lpmode] [get_bd_pins Interfaces/qsfp_if0_lpmode]
  connect_bd_net -net top_design_qsfp_modsel_n [get_bd_ports qsfp_if0_modsel_n] [get_bd_pins Interfaces/qsfp_if0_modsel_n]
  connect_bd_net -net top_design_qsfp_reset_n [get_bd_ports qsfp_if0_reset_n] [get_bd_pins Interfaces/qsfp_if0_reset_n]
  connect_bd_net -net traffic_generator_dma_reset_n [get_bd_pins Memory_Mapped/pcie_reset_n] [get_bd_pins synq_reset_system/dma_reset_n]
  connect_bd_net -net traffic_generator_usr_tx_clk [get_bd_pins Interfaces/cmac_if0_tx_clk] [get_bd_pins interface_0_handler/cmac_if0_tx_clk] [get_bd_pins synq_reset_system/cmac_if0_tx_clk]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0x00000000 [get_bd_addr_spaces Interfaces/cmac_sync_0/s_axi] [get_bd_addr_segs Interfaces/cmac_wrapper_0/s_axi4_lite/reg0] SEG_cmac_wrapper_0_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0x00002000 [get_bd_addr_spaces Interfaces/cmac_sync_0/s_axi] [get_bd_addr_segs Interfaces/qsfp28_cage_control_0/QSFP_CONTROL/reg0] SEG_qsfp28_cage_control_0_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0x00000000 [get_bd_addr_spaces Memory_Mapped/jtag_axi_0/Data] [get_bd_addr_segs Interfaces/cmac_wrapper_0/s_axi4_lite/reg0] SEG_cmac_wrapper_0_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0x00001000 [get_bd_addr_spaces Memory_Mapped/jtag_axi_0/Data] [get_bd_addr_segs interface_0_handler/interface_settings_0/S_AXI/reg0] SEG_interface_settings_0_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0x00005000 [get_bd_addr_spaces Memory_Mapped/jtag_axi_0/Data] [get_bd_addr_segs interface_0_handler/TCP/iperf2_client_1/s_axi_settings/Reg] SEG_iperf2_client_1_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x00003000 [get_bd_addr_spaces Memory_Mapped/jtag_axi_0/Data] [get_bd_addr_segs interface_0_handler/performance_debug_reg_0/S_AXI/reg0] SEG_performance_debug_reg_0_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0x00002000 [get_bd_addr_spaces Memory_Mapped/jtag_axi_0/Data] [get_bd_addr_segs Interfaces/qsfp28_cage_control_0/QSFP_CONTROL/reg0] SEG_qsfp28_cage_control_0_reg0
  create_bd_addr_seg -range 0x000100000000 -offset 0x00000000 [get_bd_addr_spaces interface_0_handler/TCP/datamover_TX/Data] [get_bd_addr_segs interface_0_handler/TCP/memory_controller_c0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] SEG_memory_controller_c0_C0_DDR4_ADDRESS_BLOCK


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


