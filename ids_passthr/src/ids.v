`timescale 1ns/1ps

module ids 
   #(
      parameter DATA_WIDTH = 64,
      parameter CTRL_WIDTH = DATA_WIDTH/8,
      parameter UDP_REG_SRC_WIDTH = 2
   )
   (
      input  [DATA_WIDTH-1:0]             in_data,
      input  [CTRL_WIDTH-1:0]             in_ctrl,
      input                               in_wr,
      output                              in_rdy,

      output [DATA_WIDTH-1:0]             out_data,
      output [CTRL_WIDTH-1:0]             out_ctrl,
      output                              out_wr,
      input                               out_rdy,
      
      // --- Register interface
      input                               reg_req_in,
      input                               reg_ack_in,
      input                               reg_rd_wr_L_in,
      input  [`UDP_REG_ADDR_WIDTH-1:0]    reg_addr_in,
      input  [`CPCI_NF2_DATA_WIDTH-1:0]   reg_data_in,
      input  [UDP_REG_SRC_WIDTH-1:0]      reg_src_in,

      output                              reg_req_out,
      output                              reg_ack_out,
      output                              reg_rd_wr_L_out,
      output [`UDP_REG_ADDR_WIDTH-1:0]    reg_addr_out,
      output [`CPCI_NF2_DATA_WIDTH-1:0]   reg_data_out,
      output [UDP_REG_SRC_WIDTH-1:0]      reg_src_out,
      
      // misc
      input                               reset,
      input                               clk
   );

   // ==========================================
   //  1. 信号定义 
   // ==========================================
   // software registers
   wire [31:0] ids_sw_reg;
   wire [31:0] ids_cmd;
   // hardware registers
   reg  [31:0] ids_hw_reg;

   // ==========================================
   //  2. Generic Regs 实例化 
   // ==========================================
   generic_regs
   #( 
      .UDP_REG_SRC_WIDTH   (UDP_REG_SRC_WIDTH),
      .TAG                 (`IDS_BLOCK_ADDR),           // Tag -- eg. MODULE_TAG
      .REG_ADDR_WIDTH      (`IDS_REG_ADDR_WIDTH),       // Width of block addresses
      .NUM_COUNTERS        (0),                         // Number of counters
      .NUM_SOFTWARE_REGS   (2),                         // Number of sw regs
      .NUM_HARDWARE_REGS   (1)                          // Number of hw regs
   ) module_regs (
      .reg_req_in       (reg_req_in),
      .reg_ack_in       (reg_ack_in),
      .reg_rd_wr_L_in   (reg_rd_wr_L_in),
      .reg_addr_in      (reg_addr_in),
      .reg_data_in      (reg_data_in),
      .reg_src_in       (reg_src_in),

      .reg_req_out      (reg_req_out),
      .reg_ack_out      (reg_ack_out),
      .reg_rd_wr_L_out  (reg_rd_wr_L_out),
      .reg_addr_out     (reg_addr_out),
      .reg_data_out     (reg_data_out),
      .reg_src_out      (reg_src_out),

      // --- counters interface
      .counter_updates  (),
      .counter_decrement(),

      // --- SW regs interface
      // 注意：这里把两个 32位 信号拼成 64位 输入
      .software_regs    ({ids_cmd, ids_sw_reg}), 

      // --- HW regs interface
      .hardware_regs    (ids_hw_reg),
      
      .clk              (clk),
      .reset            (reset)
   );

   // ==========================================
   //  3. 逻辑部分
   // ==========================================
   
   // --- Passthrough 直通逻辑 ---
   assign out_data = in_data;
   assign out_ctrl = in_ctrl;
   assign out_wr   = in_wr;
   assign in_rdy   = out_rdy;

   // --- 字节反转逻辑 (Byte Swapping) ---
   // 这是一个简单的测试逻辑：把 sw_reg 的字节序反转后赋给 hw_reg
   always @(posedge clk) begin
      // match is set to the reverse order of the pattern.
      ids_hw_reg <= {ids_sw_reg[7:0], ids_sw_reg[15:8], ids_sw_reg[23:16], ids_sw_reg[31:24]};
   end

endmodule