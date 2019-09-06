
`timescale 1 ns / 1 ps

module cuckooCamWrapper (
      (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ap_clk CLK" *)
      (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF s_lookup_request_V:m_lookup_reply_V:s_update_request_V:m_update_replay_V , ASSOCIATED_RESET ap_rst_n" *)
      input  wire         ap_clk,
      (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ap_rst_n RST" *)
      (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)   
      input  wire         ap_rst_n,
      input  wire  [71:0] s_lookup_request_V_TDATA,
      input  wire         s_lookup_request_V_TVALID,
      output wire         s_lookup_request_V_TREADY,
      output wire  [87:0] m_lookup_reply_V_TDATA,
      output wire         m_lookup_reply_V_TVALID,
      input  wire         m_lookup_reply_V_TREADY,
      input  wire  [87:0] s_update_request_V_TDATA,
      input  wire         s_update_request_V_TVALID,
      output wire         s_update_request_V_TREADY,
      output wire  [87:0] m_update_replay_V_TDATA,
      output wire         m_update_replay_V_TVALID,
      input  wire         m_update_replay_V_TREADY
);

  cuckoo_cam  cuckoo_cam_i (
    .ap_clk                   (ap_clk                   ),        
    .ap_rst_n                 (ap_rst_n                 ),       
    .s_lookup_request_V_TDATA (s_lookup_request_V_TDATA ),       
    .s_lookup_request_V_TVALID(s_lookup_request_V_TVALID),       
    .s_lookup_request_V_TREADY(s_lookup_request_V_TREADY),       
    .m_lookup_reply_V_TDATA   (m_lookup_reply_V_TDATA   ),       
    .m_lookup_reply_V_TVALID  (m_lookup_reply_V_TVALID  ),       
    .m_lookup_reply_V_TREADY  (m_lookup_reply_V_TREADY  ),       
    .s_update_request_V_TDATA (s_update_request_V_TDATA ),       
    .s_update_request_V_TVALID(s_update_request_V_TVALID),       
    .s_update_request_V_TREADY(s_update_request_V_TREADY),       
    .m_update_replay_V_TDATA  (m_update_replay_V_TDATA  ),       
    .m_update_replay_V_TVALID (m_update_replay_V_TVALID ),       
    .m_update_replay_V_TREADY (m_update_replay_V_TREADY ),       
    .free_slots_V             (                         ),       
    .free_stash_V             (                         )        
  );

endmodule