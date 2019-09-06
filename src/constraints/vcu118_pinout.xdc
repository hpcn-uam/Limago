#------------------------------------------------------------------------------
# CMAC example design-level XDC file
# ----------------------------------------------------------------------------------------------------------------------

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

##########################################
## PCIe
##########################################
set_property PACKAGE_PIN AC8 [get_ports {pcie_refclk_clk_n[0]}]
set_property PACKAGE_PIN AC9 [get_ports {pcie_refclk_clk_p[0]}]

set_property PACKAGE_PIN AM17 [get_ports pcie_rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_rst_n]
set_property PULLUP true [get_ports pcie_rst_n]


##########################################
## QSFP0 CAGE PHYSICAL SIGNALS           #
##########################################
# This interface is the one closest to the PCIe
set_property -dict {PACKAGE_PIN AM21 IOSTANDARD LVCMOS18} [get_ports qsfp_if0_modsel_n]
set_property -dict {PACKAGE_PIN AL21 IOSTANDARD LVCMOS18} [get_ports qsfp_if0_modprsl_n]
set_property -dict {PACKAGE_PIN AP21 IOSTANDARD LVCMOS18} [get_ports qsfp_if0_intl_n]
set_property -dict {PACKAGE_PIN AN21 IOSTANDARD LVCMOS18} [get_ports qsfp_if0_lpmode]
set_property -dict {PACKAGE_PIN BA22 IOSTANDARD LVCMOS18} [get_ports qsfp_if0_reset_n]

##########################################
## QSFP1 CAGE PHYSICAL SIGNALS           #
##########################################
# This interface is the one furthest to the PCIe
set_property -dict {PACKAGE_PIN AN23 IOSTANDARD LVCMOS18} [get_ports qsfp_if1_modsel_n]
set_property -dict {PACKAGE_PIN AN24 IOSTANDARD LVCMOS18} [get_ports qsfp_if1_modprsl_n]
set_property -dict {PACKAGE_PIN AT21 IOSTANDARD LVCMOS18} [get_ports qsfp_if1_intl_n]
set_property -dict {PACKAGE_PIN AT24 IOSTANDARD LVCMOS18} [get_ports qsfp_if1_lpmode]
set_property -dict {PACKAGE_PIN AY22 IOSTANDARD LVCMOS18} [get_ports qsfp_if1_reset_n]

