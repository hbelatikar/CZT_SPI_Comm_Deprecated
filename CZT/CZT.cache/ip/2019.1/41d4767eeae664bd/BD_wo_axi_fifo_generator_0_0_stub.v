// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Wed Feb 19 11:16:04 2020
// Host        : DESKTOP-HM1JLKG running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ BD_wo_axi_fifo_generator_0_0_stub.v
// Design      : BD_wo_axi_fifo_generator_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_4,Vivado 2019.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(rst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, 
  almost_full, wr_ack, overflow, empty, almost_empty, rd_data_count, wr_data_count, prog_full, 
  prog_empty)
/* synthesis syn_black_box black_box_pad_pin="rst,wr_clk,rd_clk,din[63:0],wr_en,rd_en,dout[31:0],full,almost_full,wr_ack,overflow,empty,almost_empty,rd_data_count[14:0],wr_data_count[13:0],prog_full,prog_empty" */;
  input rst;
  input wr_clk;
  input rd_clk;
  input [63:0]din;
  input wr_en;
  input rd_en;
  output [31:0]dout;
  output full;
  output almost_full;
  output wr_ack;
  output overflow;
  output empty;
  output almost_empty;
  output [14:0]rd_data_count;
  output [13:0]wr_data_count;
  output prog_full;
  output prog_empty;
endmodule
