`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:52:28 11/26/2019 
// Design Name: 
// Module Name:    FIR 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FIR
	#(parameter total_bits=12) (
    input clock,
    input reset,
    input [total_bits-1:0] IN,
    output [total_bits-1:0] Re,
    output [total_bits-1:0] Im
    );
	
	parameter order = 8;
	parameter [total_bits-1:0] coef1 = 12'b0001_1110_1000; // 0.23828125
	parameter [total_bits-1:0] coef3 = 12'b0101_0000_0000; // 0.625
	
	wire [total_bits-1:0] coef1pos = IN*coef1;
	wire [total_bits-1:0] coef3pos = IN*coef3;
	
	reg [3:0] i;
	reg [total_bits-1:0] FF_re [order:0];
	reg [total_bits-1:0] FF_conv [order-1:0];

	assign Re = FF_re[order];
	assign Im = FF_conv[order-1];
	
	always @(posedge clock) begin
		FF_re[0] <= IN;
	
		if (reset) begin
			for (i=0; i < order; i = i+1) begin
				FF_conv[i] <= 0;
			end
			for (i=0; i < order+1; i = i+1) begin
				FF_re[i] <= 0;
			end
		end
		else begin
			for (i=1; i < order+1; i = i+1) begin
				FF_re[i] <= FF_re[i-1];
			end
			
			FF_conv[0] = -coef1pos;
			FF_conv[1] = FF_conv[0];
			FF_conv[2] = FF_conv[1] - coef3pos;
			FF_conv[3] = FF_conv[2];
			FF_conv[4] = FF_conv[3] + coef3pos;
			FF_conv[5] = FF_conv[4];
			FF_conv[6] = FF_conv[5] + coef1pos;
			FF_conv[7] = FF_conv[6];
		end
	end


endmodule
