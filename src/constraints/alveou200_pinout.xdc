#------------------------------------------------------------------------------
# CMAC example design-level XDC file
# ----------------------------------------------------------------------------------------------------------------------

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

##########################################
## PCIe
##########################################
set_property PACKAGE_PIN AM10 [get_ports {pcie_refclk_clk_n[0]}]
set_property PACKAGE_PIN AM11 [get_ports {pcie_refclk_clk_p[0]}]

set_property PACKAGE_PIN BD21 [get_ports pcie_rst_n]


##########################################
## Reference clock 156.25 MHz
##########################################
set_property -dict {PACKAGE_PIN AV19 IOSTANDARD LVDS} [get_ports sys_clkref_clk_n]
set_property -dict {PACKAGE_PIN AU19 IOSTANDARD LVDS} [get_ports sys_clkref_clk_p]

##########################################
## QSFP0 CAGE PHYSICAL SIGNALS           #
##########################################
# This interface is the one closest to the PCIe
set_property -dict {PACKAGE_PIN BE16 IOSTANDARD LVCMOS12} [get_ports qsfp_if0_modsel_n]
set_property -dict {PACKAGE_PIN BE20 IOSTANDARD LVCMOS12} [get_ports qsfp_if0_modprsl_n]
set_property -dict {PACKAGE_PIN BE21 IOSTANDARD LVCMOS12} [get_ports qsfp_if0_intl_n]
set_property -dict {PACKAGE_PIN BD18 IOSTANDARD LVCMOS12} [get_ports qsfp_if0_lpmode]
set_property -dict {PACKAGE_PIN BE17 IOSTANDARD LVCMOS12} [get_ports qsfp_if0_reset_n]

set_property -dict {PACKAGE_PIN AT20 IOSTANDARD LVCMOS12} [get_ports {qsfp_if0_freqSel[0]}]
set_property -dict {PACKAGE_PIN AU22 IOSTANDARD LVCMOS12} [get_ports {qsfp_if0_freqSel[1]}]


##########################################
## QSFP1 CAGE PHYSICAL SIGNALS           #
##########################################
# This interface is the one furthest to the PCIe
set_property -dict {PACKAGE_PIN AY20 IOSTANDARD LVCMOS12} [get_ports qsfp_if1_modsel_n]
set_property -dict {PACKAGE_PIN BC19 IOSTANDARD LVCMOS12} [get_ports qsfp_if1_modprsl_n]
set_property -dict {PACKAGE_PIN AV21 IOSTANDARD LVCMOS12} [get_ports qsfp_if1_intl_n]
set_property -dict {PACKAGE_PIN AV22 IOSTANDARD LVCMOS12} [get_ports qsfp_if1_lpmode]
set_property -dict {PACKAGE_PIN BC18 IOSTANDARD LVCMOS12} [get_ports qsfp_if1_reset_n]

set_property -dict {PACKAGE_PIN AR22 IOSTANDARD LVCMOS12} [get_ports {qsfp_if1_freqSel[0]}]
set_property -dict {PACKAGE_PIN AU20 IOSTANDARD LVCMOS12} [get_ports {qsfp_if1_freqSel[1]}]




set_property PULLUP true [get_ports pcie_rst_n]
set_property IOSTANDARD POD12 [get_ports pcie_rst_n]