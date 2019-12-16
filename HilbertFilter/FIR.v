`timescale 10ns / 10ns
//////////////////////////////////////////////////////////////////////////////////
// Company: IEEE University of Porto Student Branch
// Engineer: Luís Sousa & Sílvia Faria
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
module FIR (
    input clock,
    input reset,
	 input EN,
    input signed [11:0] IN,		// 12 integer bits
    output signed [12:0] Re,		// 13 integer bits
    output signed [12:0] Im		// 13 integer bits
    );
	
	parameter order = 4; // order 8, but 4 coefs are '0'
	parameter [25:0] coef1 = 26'b0_0000_0000_0000__0011_1101_0000_0; // 0.23828125
	parameter [25:0] coef2 = 26'b0_0000_0000_0000__1010_0000_0000_0; // 0.62500000
	parameter cadence = 20-1; // Take an input every 20 clock cycles
	

	reg [4:0] cnt;							// Counter from 19 to 0
	reg [2:0] i;							// 0 to 3 (order = 4)
	reg [11:0] IN_reg;					// 12 int
	reg [11:0] FF_re [order-1:0];		// 12 int
	reg [25:0] FF_conv [order-1:0];	// 13 int + 13 frac
	
	wire [51:0] multBuffer1 = {IN_reg[11], IN_reg, 13'd0}*coef1;	// 26 int + 26 frac
	wire [51:0] multBuffer2 = {IN_reg[11], IN_reg, 13'd0}*coef2;	// 26 int + 26 frac
	wire [25:0] coef1pos = multBuffer1[38:13];	// 13 int + 13 frac
	wire [25:0] coef2pos = multBuffer2[38:13];	// 13 int + 13 frac

	assign Re = {FF_re[order-1][11], FF_re[order-1]};
	assign Im = FF_conv[order-1][25:13];
	
	initial begin
		i = 0;
		IN_reg = 0;
		cnt = cadence;
		for (i=0; i < order; i = i+1) begin
			FF_re[i] = 0;
			FF_conv[i] = 0;
		end
	end
	
	always @(posedge clock) begin
		IN_reg <= IN;
			
		if (reset) begin
			// Reset all registers
			IN_reg <= 0;
			cnt <= cadence;
			for (i=0; i < order; i = i+1) begin
				FF_re[i] <= 0;
				FF_conv[i] <= 0;
			end
		end
		else if (EN) begin
			if (cnt) begin
				cnt <= cnt - 5'd1;
			end
			else begin
				cnt <= cadence;
				
				FF_re[0] <= IN_reg;
			
				for (i=1; i < order; i = i+1) begin
					FF_re[i] <= FF_re[i-1];
				end
				
				FF_conv[0] <= -coef1pos;
				FF_conv[1] <= FF_conv[0] - coef2pos;
				FF_conv[2] <= FF_conv[1] + coef2pos;
				FF_conv[3] <= FF_conv[2] + coef1pos;
			end
		end
	end


endmodule
