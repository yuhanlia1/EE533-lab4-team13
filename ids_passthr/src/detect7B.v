////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /    Vendor: Xilinx 
// \   \   \/     Version : 10.1
//  \   \         Application : sch2verilog
//  /   /         Filename : detect7B.vf
// /___/   /\     Timestamp : 01/30/2026 00:32:04
// \   \  /  \ 
//  \___\/\___\ 
//
//Command: C:\Xilinx\10.1\ISE\bin\nt\unwrapped\sch2verilog.exe -intstyle ise -family virtex2p -w C:/EE533/lab3/mini-ids3/detect7B.sch detect7B.vf
//Design Name: detect7B
//Device: virtex2p
//Purpose:
//    This verilog netlist is translated from an ECS schematic.It can be 
//    synthesized and simulated, but it should not be modified. 
//
`timescale 1ns / 1ps

module detect7B(ce, 
                clk, 
                hwregA, 
                match_en, 
                mrst, 
                pipe1, 
                match);

    input ce;
    input clk;
    input [63:0] hwregA;
    input match_en;
    input mrst;
    input [71:0] pipe1;
   output match;
   
   wire [63:0] pipe;
   wire [71:0] pipe0;
   wire XLXN_2;
   wire XLXN_5;
   wire [111:0] XLXN_8;
   wire XLXN_15;
   wire match_DUMMY;
   
   assign match = match_DUMMY;
   busmerge XLXI_1 (.da(pipe0[47:0]), 
                    .db(pipe[63:0]), 
                    .q(XLXN_8[111:0]));
   reg9B XLXI_3 (.ce(ce), 
                 .clk(clk), 
                 .clr(XLXN_15), 
                 .d(pipe1[71:0]), 
                 .q(pipe0[71:0]));
   wordmatch XLXI_4 (.datacomp(hwregA[55:0]), 
                     .datain(XLXN_8[111:0]), 
                     .wildcard(hwregA[62:56]), 
                     .match(XLXN_2));
   AND3B1 XLXI_5 (.I0(match_DUMMY), 
                  .I1(match_en), 
                  .I2(XLXN_2), 
                  .O(XLXN_5));
   FDCE XLXI_6 (.C(clk), 
                .CE(XLXN_5), 
                .CLR(XLXN_15), 
                .D(XLXN_5), 
                .Q(match_DUMMY));
   defparam XLXI_6.INIT = 1'b0;
   FD XLXI_7 (.C(clk), 
              .D(mrst), 
              .Q(XLXN_15));
   defparam XLXI_7.INIT = 1'b0;
endmodule
