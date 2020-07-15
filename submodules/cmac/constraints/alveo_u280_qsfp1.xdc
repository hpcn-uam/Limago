################################################################################################
# alveoU280_qsfp1 constraint 
################################################################################################

set_property PACKAGE_PIN P43 [get_ports gt_ref_clk_n]
set_property PACKAGE_PIN P42 [get_ports gt_ref_clk_p]
create_clock -period 6.4 [get_ports gt_ref_clk_p]