#------------------------------------------------------------------------------
# CMAC example design-level XDC file
# ----------------------------------------------------------------------------------------------------------------------

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

##########################################
## PCIe
##########################################
set_property PACKAGE_PIN AR14 [get_ports {pcie_refclk_clk_n[0]}]
set_property PACKAGE_PIN AR15 [get_ports {pcie_refclk_clk_p[0]}]

set_property -dict {PACKAGE_PIN BH26 PULLUP true IOSTANDARD POD12} [get_ports pcie_rst_n]

##########################################
## QSFP0 CAGE PHYSICAL SIGNALS           #
##########################################
# This interface is the one closest to the PCIe
# No information about the physical pins of the cage is provided

##########################################
## QSFP1 CAGE PHYSICAL SIGNALS           #
##########################################
# This interface is the one furthest to the PCIe
# No information about the physical pins of the cage is provided

##########################################
## SC temperature controll               #
##########################################
#This pin addressess the AR# 72926  https://www.xilinx.com/support/answers/72926.html
set_property -dict {PACKAGE_PIN D32 PULLDOWN true IOSTANDARD POD12} [get_ports sc_temp_control]