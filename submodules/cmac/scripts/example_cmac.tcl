# create a dummy project
create_project deleteme /tmp/deleteme -part xcvu9p-flga2104-2L-e
set_property board_part xilinx.com:vcu118:part0:2.0 [current_project]

# Include CMAC into the project

create_ip -name cmac_usplus -vendor xilinx.com -library ip -module_name cmac_usplus_0

set_property -dict [list \
    CONFIG.CMAC_CAUI4_MODE           {1} \
    CONFIG.NUM_LANES                 {4} \
    CONFIG.GT_REF_CLK_FREQ           {161.1328125} \
    CONFIG.CMAC_CORE_SELECT          {CMACE4_X0Y6} \
    CONFIG.GT_GROUP_SELECT           {X1Y48~X1Y51} \
    CONFIG.INCLUDE_SHARED_LOGIC      {2} \
    CONFIG.LANE5_GT_LOC              {NA} \
    CONFIG.LANE6_GT_LOC              {NA} \
    CONFIG.LANE7_GT_LOC              {NA} \
    CONFIG.LANE8_GT_LOC              {NA} \
    CONFIG.LANE9_GT_LOC              {NA} \
    CONFIG.LANE10_GT_LOC             {NA} \
    CONFIG.OPERATING_MODE            {Duplex} \
    CONFIG.TX_FLOW_CONTROL           {0} \
    CONFIG.RX_FLOW_CONTROL           {0} \
    CONFIG.ENABLE_AXI_INTERFACE      {1} \
    CONFIG.RX_CHECK_ACK              {1} \
    CONFIG.ENABLE_TIME_STAMPING      {0} \
    CONFIG.TX_PTP_1STEP_ENABLE       {2} \
    CONFIG.PTP_TRANSPCLK_MODE        {0} \
    CONFIG.TX_PTP_LATENCY_ADJUST     {0} \
    CONFIG.ENABLE_PIPELINE_REG       {1} \
] [get_ips cmac_usplus_0]

# open example design
open_example_project -force -dir /tmp [get_ips  cmac_usplus_0]

exit
exit