`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/08 09:51:03
// Design Name: 
// Module Name: uart_cmd_decode
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


module uart_cmd_decode(
	input		wire				clk,
	input		wire				reset,
	input		wire				dout_v,
	input		wire	[7:0]		dout,
	output		reg					wr_en,
	output		reg		[31:0]		wr_addr=0,
	output		reg		[15:0]		wr_data=0,
	output		reg					rd_en,
	output		reg		[31:0]		rd_addr=0
    );
	
	reg			[7:0]	data_reg0;
	reg			[7:0]	data_reg1;
	reg			[7:0]	data_reg2;
	reg			[7:0]	data_reg3;
	reg			[7:0]	data_reg4;
	reg			[7:0]	data_reg5;
	reg			[7:0]	data_reg6;
	reg			[7:0]	data_reg7;
	reg			[7:0]	data_reg8;
	reg			[7:0]	data_reg9;
	
	reg					clear_en=0;
	reg			[2:0]	state;
	
	always @ (posedge clk) begin
		if (reset | clear_en) begin
			data_reg0 <= 8'd0;
			data_reg1 <= 8'd0;
			data_reg2 <= 8'd0;
			data_reg3 <= 8'd0;
			data_reg4 <= 8'd0;
			data_reg5 <= 8'd0;
			data_reg6 <= 8'd0;
			data_reg7 <= 8'd0;
			data_reg8 <= 8'd0;
			data_reg9 <= 8'd0;
		end
		else if (dout_v) begin
			data_reg0 <= dout;
			data_reg1 <= data_reg0;
			data_reg2 <= data_reg1;
			data_reg3 <= data_reg2;
			data_reg4 <= data_reg3;
			data_reg5 <= data_reg4;
			data_reg6 <= data_reg5;
			data_reg7 <= data_reg6;
			data_reg8 <= data_reg7;
			data_reg9 <= data_reg8;
		end
	end
	//识别指令
	always @ (posedge clk) begin
		if (reset) begin
			state <= 3'd0;
			wr_en <= 1'b0;
			rd_en <= 1'b0;
		end
		else begin
			case (state)
				3'd0	:	begin
					if (data_reg9 == 8'hAA && data_reg8 == 8'h55 && data_reg1 == 8'h00 && data_reg0 == 8'hFF) begin
						state <= 3'd1;
					end
					else if (data_reg9 == 8'hAA && data_reg8 == 8'h66 && data_reg1 == 8'h00 && data_reg0 == 8'hFF) begin
						state <= 3'd2;
					end
				end
				3'd1	:	begin
					wr_en <= 1'b1;
					wr_addr <= {data_reg7,data_reg6,data_reg5,data_reg4};
					wr_data <= {data_reg3,data_reg2};
					state <= 3'd3;
				end
				3'd2	:	begin
					rd_en <= 1'b1;
					rd_addr <= {data_reg7,data_reg6,data_reg5,data_reg4};
					state <= 3'd3;
				end
				3'd3	:	begin
					wr_en <= 1'b0;
					rd_en <= 1'b0;
					clear_en <= 1'b1;
					state <= 3'd4;
				end
				3'd4	:	begin
					clear_en <= 1'b0;
					state <= 3'd0;
				end
			endcase
		end
	end
endmodule
