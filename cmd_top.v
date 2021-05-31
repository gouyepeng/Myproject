`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/08 10:59:13
// Design Name: 
// Module Name: cmd_top
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


module cmd_top(
	input		wire				clk,
	input		wire				reset,
	input		wire				wr_en,
	input		wire		[31:0]	wr_addr,
	input		wire		[15:0]	wr_data,
	input		wire				rd_en,
	input		wire		[31:0]	rd_addr,
	output		reg					time_control_en,
	output		reg			[7:0]	time_num,
	output		reg			[3:0]	time_unit,
	output		reg					led_mode_en,
	output		reg			[3:0]	led_mode,
	output		reg					rd_led_mode_en,
	output		reg					rd_led_time_en
	);
	
	reg						wr_en_dly1;
	reg						wr_en_dly2;
	reg			[31:0]		wr_addr_dly1;
	reg			[31:0]		wr_addr_dly2;
	reg			[15:0]		wr_data_dly1;
	reg			[15:0]		wr_data_dly2;
	reg						rd_en_dly1;
	reg						rd_en_dly2;
	reg			[31:0]		rd_addr_dly1;
	reg			[31:0]		rd_addr_dly2;
	
	//对输入信号进行打拍操作
	always @ (posedge clk) begin
		wr_en_dly1 <= wr_en;
		wr_en_dly2 <= wr_en_dly1;
		wr_addr_dly1 <= wr_addr;
		wr_addr_dly2 <= wr_addr_dly1;
		wr_data_dly1 <= wr_data;
		wr_data_dly2 <= wr_data_dly1;
		rd_en_dly1 <= rd_en;
		rd_en_dly2 <= rd_en_dly1;
		rd_addr_dly1 <= rd_addr;
		rd_addr_dly2 <= rd_addr_dly1;
	end
	//-----写操作-------------
	always @ (posedge clk) begin
		if (reset) begin
			//只对关键信号进行复位
			time_control_en <= 1'b0;
			led_mode_en <= 1'b0;
			time_num <= 8'd3;
		end
		else if (wr_en_dly2) begin	//wr_en信号有效
			case (wr_addr_dly2)		//判断wr_addr
				32'd0	:	begin
					time_control_en <= 1'b1;
					time_num <= wr_data_dly2[15:8];
					time_unit <= wr_data_dly2[7:4];
				end
				32'd1	:	begin
					led_mode_en <= 1'b1;
					led_mode <= wr_data_dly2[3:0];
				end
				default	:	begin
					time_control_en <= 1'b0;
					led_mode_en <= 1'b0;
				end
 			endcase
		end
		else begin
			time_control_en <= 1'b0;
			led_mode_en <= 1'b0;
		end
	end
	
	//---------读----------------
	always @ (posedge clk) begin
		if (reset) begin
			rd_led_mode_en <= 1'b0;
			rd_led_time_en <= 1'b0;
		end
		else if (rd_en_dly2) begin
			case (rd_addr_dly2)
				32'd0	:	begin
					rd_led_mode_en <= 1'b1;
					rd_led_time_en <= 1'b0;
				end
				32'd1	:	begin
					rd_led_mode_en <= 1'b0;
					rd_led_time_en <= 1'b1;
				end
				default :	begin
					rd_led_mode_en <= 1'b0;
					rd_led_time_en <= 1'b0;
				end	
			endcase
		end
		else begin
			rd_led_mode_en <= 1'b0;
			rd_led_time_en <= 1'b0;
		end
	end
endmodule
