`timescale 1 ps / 1 ps

module alveou200_fns_single_toe_wrapper (
  output wire         C3_DDR4_act_n,
  output wire  [16:0] C3_DDR4_adr,
  output wire  [ 1:0] C3_DDR4_ba,
  output wire  [ 1:0] C3_DDR4_bg,
  output wire         C3_DDR4_ck_c,
  output wire         C3_DDR4_ck_t,
  output wire         C3_DDR4_cke,
  output wire         C3_DDR4_cs_n,
  inout  wire [71:0]  C3_DDR4_dq,
  inout  wire [17:0]  C3_DDR4_dqs_c,
  inout  wire [17:0]  C3_DDR4_dqs_t,
  output wire         C3_DDR4_odt,
  output wire         C3_DDR4_par,
  output wire         C3_DDR4_reset_n,
  input  wire         ddr4_c3_ref_clk_clk_n,
  input  wire         ddr4_c3_ref_clk_clk_p,
  input  wire         gt_if0_ref_clk_clk_n,
  input  wire         gt_if0_ref_clk_clk_p,
  input  wire  [3:0]  gt_if0_rx_gtx_n,
  input  wire  [3:0]  gt_if0_rx_gtx_p,
  output wire  [3:0]  gt_if0_tx_gtx_n,
  output wire  [3:0]  gt_if0_tx_gtx_p,
  input  wire         pcie_mgt_rxn,
  input  wire         pcie_mgt_rxp,
  output wire         pcie_mgt_txn,
  output wire         pcie_mgt_txp,
  input  wire  [0:0]  pcie_refclk_clk_n,
  input  wire  [0:0]  pcie_refclk_clk_p,
  input  wire         pcie_rst_n,
  input  wire         qsfp_if0_intl_n,
  output wire         qsfp_if0_lpmode,
  input  wire         qsfp_if0_modprsl_n,
  output wire         qsfp_if0_modsel_n,
  output wire         qsfp_if0_reset_n,
  input  wire         sys_clkref_clk_n,
  input  wire         sys_clkref_clk_p,
  output wire  [1:0]  qsfp_if0_freqSel
);


  wire         cmac_if0_rx_clk;
  wire         cmac_if0_rx_rst_n;
  wire  [71:0] toe2cuckoo_lookup_request_V_TDATA;
  wire         toe2cuckoo_lookup_request_V_TVALID;
  wire         toe2cuckoo_lookup_request_V_TREADY;
  wire  [87:0] toe2cuckoo_update_request_V_TDATA;
  wire         toe2cuckoo_update_request_V_TVALID;
  wire         toe2cuckoo_update_request_V_TREADY;
  wire  [87:0] cuckoo2toe_lookup_reply_V_TDATA;
  wire         cuckoo2toe_lookup_reply_V_TVALID;
  wire         cuckoo2toe_lookup_reply_V_TREADY;
  wire  [87:0] cuckoo2toe_update_replay_V_TDATA;
  wire         cuckoo2toe_update_replay_V_TVALID;
  wire         cuckoo2toe_update_replay_V_TREADY;



  bd_wrapper bd_wrapper_i (
    .C3_DDR4_act_n                (C3_DDR4_act_n),
    .C3_DDR4_adr                  (C3_DDR4_adr),
    .C3_DDR4_ba                   (C3_DDR4_ba),
    .C3_DDR4_bg                   (C3_DDR4_bg),
    .C3_DDR4_ck_c                 (C3_DDR4_ck_c),
    .C3_DDR4_ck_t                 (C3_DDR4_ck_t),
    .C3_DDR4_cke                  (C3_DDR4_cke),
    .C3_DDR4_cs_n                 (C3_DDR4_cs_n),
    .C3_DDR4_dq                   (C3_DDR4_dq),
    .C3_DDR4_dqs_c                (C3_DDR4_dqs_c),
    .C3_DDR4_dqs_t                (C3_DDR4_dqs_t),
    .C3_DDR4_odt                  (C3_DDR4_odt),
    .C3_DDR4_par                  (C3_DDR4_par),
    .C3_DDR4_reset_n              (C3_DDR4_reset_n),
    .ddr4_c3_ref_clk_clk_n        (ddr4_c3_ref_clk_clk_n),
    .ddr4_c3_ref_clk_clk_p        (ddr4_c3_ref_clk_clk_p),
    .gt_if0_ref_clk_clk_n         (gt_if0_ref_clk_clk_n),
    .gt_if0_ref_clk_clk_p         (gt_if0_ref_clk_clk_p),
    .gt_if0_rx_gtx_n              (gt_if0_rx_gtx_n),
    .gt_if0_rx_gtx_p              (gt_if0_rx_gtx_p),
    .gt_if0_tx_gtx_n              (gt_if0_tx_gtx_n),
    .gt_if0_tx_gtx_p              (gt_if0_tx_gtx_p),
    .pcie_mgt_rxn                 (pcie_mgt_rxn),
    .pcie_mgt_rxp                 (pcie_mgt_rxp),
    .pcie_mgt_txn                 (pcie_mgt_txn),
    .pcie_mgt_txp                 (pcie_mgt_txp),
    .pcie_refclk_clk_n            (pcie_refclk_clk_n),
    .pcie_refclk_clk_p            (pcie_refclk_clk_p),
    .pcie_rst_n                   (pcie_rst_n),
    .qsfp_if0_intl_n              (qsfp_if0_intl_n),
    .qsfp_if0_lpmode              (qsfp_if0_lpmode),
    .qsfp_if0_modprsl_n           (qsfp_if0_modprsl_n),
    .qsfp_if0_modsel_n            (qsfp_if0_modsel_n),
    .qsfp_if0_reset_n             (qsfp_if0_reset_n),
    .sys_clkref_clk_n             (sys_clkref_clk_n),
    .sys_clkref_clk_p             (sys_clkref_clk_p),
    .qsfp_if0_freqSel             (qsfp_if0_freqSel),

    .cmac_if0_rx_clk              (cmac_if0_rx_clk),
    .cmac_if0_rx_rst_n            (cmac_if0_rx_rst_n),
    .m_axis_session_lup_req_tdata (toe2cuckoo_lookup_request_V_TDATA),
    .m_axis_session_lup_req_tready(toe2cuckoo_lookup_request_V_TREADY),
    .m_axis_session_lup_req_tvalid(toe2cuckoo_lookup_request_V_TVALID),

    .m_axis_session_upd_req_tdata (toe2cuckoo_update_request_V_TDATA),
    .m_axis_session_upd_req_tready(toe2cuckoo_update_request_V_TREADY),
    .m_axis_session_upd_req_tvalid(toe2cuckoo_update_request_V_TVALID),

    .s_axis_session_lup_rsp_tdata (cuckoo2toe_lookup_reply_V_TDATA),
    .s_axis_session_lup_rsp_tvalid(cuckoo2toe_lookup_reply_V_TVALID),
    .s_axis_session_lup_rsp_tready(cuckoo2toe_lookup_reply_V_TREADY),

    .s_axis_session_upd_rsp_tdata (cuckoo2toe_update_replay_V_TDATA),
    .s_axis_session_upd_rsp_tready(cuckoo2toe_update_replay_V_TREADY),
    .s_axis_session_upd_rsp_tvalid(cuckoo2toe_update_replay_V_TVALID)
  );


  /* CuckooCAM instantiation */

  cuckoo_cam  cuckoo_cam_i (
    .ap_clk                   (cmac_if0_rx_clk                   ),
    .ap_rst_n                 (cmac_if0_rx_rst_n                 ),

    .s_lookup_request_V_TDATA (toe2cuckoo_lookup_request_V_TDATA ),
    .s_lookup_request_V_TVALID(toe2cuckoo_lookup_request_V_TVALID),
    .s_lookup_request_V_TREADY(toe2cuckoo_lookup_request_V_TREADY),

    .s_update_request_V_TDATA (toe2cuckoo_update_request_V_TDATA ),
    .s_update_request_V_TVALID(toe2cuckoo_update_request_V_TVALID),
    .s_update_request_V_TREADY(toe2cuckoo_update_request_V_TREADY),

    .m_lookup_reply_V_TDATA   (cuckoo2toe_lookup_reply_V_TDATA   ),
    .m_lookup_reply_V_TVALID  (cuckoo2toe_lookup_reply_V_TVALID  ),
    .m_lookup_reply_V_TREADY  (cuckoo2toe_lookup_reply_V_TREADY  ),

    .m_update_replay_V_TDATA  (cuckoo2toe_update_replay_V_TDATA  ),
    .m_update_replay_V_TVALID (cuckoo2toe_update_replay_V_TVALID ),
    .m_update_replay_V_TREADY (cuckoo2toe_update_replay_V_TREADY ),
    .free_slots_V             (                                  ),
    .free_stash_V             (                                  )
  );


endmodule