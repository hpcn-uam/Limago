`timescale 1 ps / 1 ps

module alveou280_fns_single_toe_wrapper (
  output wire         C0_DDR4_act_n,
  output wire  [16:0] C0_DDR4_adr,
  output wire  [ 1:0] C0_DDR4_ba,
  output wire  [ 1:0] C0_DDR4_bg,
  output wire         C0_DDR4_ck_c,
  output wire         C0_DDR4_ck_t,
  output wire         C0_DDR4_cke,
  output wire         C0_DDR4_cs_n,
  inout  wire [71:0]  C0_DDR4_dq,
  inout  wire [17:0]  C0_DDR4_dqs_c,
  inout  wire [17:0]  C0_DDR4_dqs_t,
  output wire         C0_DDR4_odt,
  output wire         C0_DDR4_par,
  output wire         C0_DDR4_reset_n,
  input  wire         ddr4_c0_ref_clk_n,
  input  wire         ddr4_c0_ref_clk_p,
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
  output wire         hbm_cattrip
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
    .C0_DDR4_act_n                (C0_DDR4_act_n),
    .C0_DDR4_adr                  (C0_DDR4_adr),
    .C0_DDR4_ba                   (C0_DDR4_ba),
    .C0_DDR4_bg                   (C0_DDR4_bg),
    .C0_DDR4_ck_c                 (C0_DDR4_ck_c),
    .C0_DDR4_ck_t                 (C0_DDR4_ck_t),
    .C0_DDR4_cke                  (C0_DDR4_cke),
    .C0_DDR4_cs_n                 (C0_DDR4_cs_n),
    .C0_DDR4_dq                   (C0_DDR4_dq),
    .C0_DDR4_dqs_c                (C0_DDR4_dqs_c),
    .C0_DDR4_dqs_t                (C0_DDR4_dqs_t),
    .C0_DDR4_odt                  (C0_DDR4_odt),
    .C0_DDR4_par                  (C0_DDR4_par),
    .C0_DDR4_reset_n              (C0_DDR4_reset_n),
    .ddr4_c0_ref_clk_n            (ddr4_c0_ref_clk_n),
    .ddr4_c0_ref_clk_p            (ddr4_c0_ref_clk_p),
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
    //This pin addresses the AR# 72926  https://www.xilinx.com/support/answers/72926.html
    .hbm_cattrip                  (hbm_cattrip),

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