`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/08 09:50:18
// Design Name: 
// Module Name: system_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module system_top(
	input		wire				clk,
	input		wire				uart_rx,
	output		wire				uart_tx,
	output		wire	[3:0]		led_out
    );
	//pll
	wire				clk_25m;
	wire				locked;
	//uart_ip
	wire				din_v;
	wire		[7:0]	din;
	wire				dout_v;
	wire		[7:0]	dout;
	wire				tx_busy;
	//uart_cmd_decode
	wire				wr_en;
	wire		[31:0]	wr_addr;
	wire		[15:0]	wr_data;
	wire				rd_en;
	wire		[31:0]	rd_addr;
	//cmd_top
	wire				time_control_en;
	wire		[7:0]	time_num;
	wire		[3:0]	time_unit;
	wire				led_mode_en;
	wire		[3:0]	led_mode;
	wire				rd_led_mode_en;
	wire				rd_led_time_en;
	
	PLL_25m PLL_25m_inst(
						// Clock out ports
						.clk_out1(clk_25m),     // output clk_out1
						// Status and control signals
						.locked(locked),       // output locked
					   // Clock in ports
						.clk_in1(clk)
						); 
	uart_ip uart_ip_inst(
					    .clk_25m(clk_25m),  // input wire clk_25m
					    .reset(locked),      // input wire reset
					    .din_v(din_v),      // input wire din_v
					    .din(din),          // input wire [7 : 0] din
					    .uart_tx(uart_tx),  // output wire uart_tx
					    .uart_rx(uart_rx),  // input wire uart_rx
					    .dout_v(dout_v),    // output wire dout_v
					    .dout(dout),        // output wire [7 : 0] dout
					    .tx_busy(tx_busy)  // output wire tx_busy
					  );
	uart_cmd_decode uart_cmd_decode_inst(
						.clk(clk_25m),
						.reset(locked),
						.dout_v(dout_v),
						.dout(dout),
						.wr_en(wr_en),
						.wr_addr(wr_addr),
						.wr_data(wr_data),
						.rd_en(rd_en),
						.rd_addr(rd_addr)
						);
	cmd_top cmd_top_inst(
						.clk(clk_25m),
						.reset(locked),
						.wr_en(wr_en),
						.wr_addr(wr_addr),
						.wr_data(wr_data),
						.rd_en(rd_en),
						.rd_addr(rd_addr),
						.time_control_en(time_control_en),
						.time_num(time_num),
						.time_unit(time_unit),
						.led_mode_en(led_mode_en),
						.led_mode(led_mode),
						.rd_led_mode_en(rd_led_mode_en),
						.rd_led_time_en(rd_led_time_en)
						);
endmodule
