create_clock -period 10.000 -name pcie_clock [get_ports pcie_refclk_clk_p]
create_clock -period 6.400 -name usr_clk [get_ports sys_clkref_clk_p]

set_false_path -through [get_nets -hierarchical *clk_100_i_rst_n_synq*]
set_false_path -through [get_nets -hierarchical *cmac_if0_rx_p_rst_n_synq*]
set_false_path -through [get_nets -hierarchical *clk_100_rst_n_synq*]
set_false_path -through [get_nets -hierarchical *cmac_if0_rx_rst_n_synq*]
set_false_path -through [get_nets -hierarchical *cmac_if0_tx_rst_n_synq*]
set_false_path -through [get_nets -hierarchical *cmac_if1_rx_rst_n_synq*]
set_false_path -through [get_nets -hierarchical *cmac_if1_tx_rst_n_synq*]
set_false_path -through [get_nets -hierarchical *clk_100_p_rst_syqn*]

