`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:37:32 12/17/2019 
// Design Name: 
// Module Name:    phasediff 
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
module phasediff (
	 input clock,
	 input reset,
	 input sample,
    input signed [18:0] A,				// 9Q10
    input signed [18:0] B,				// 9Q10
    output reg signed [18:0] out,	// 9Q10
	 output ready
    );

	assign ready = reset ? 1'b0 : sample;

	reg signed [18:0] FF_A;
	reg signed [18:0] FF_B;

	wire signed [18:0] diff = $signed(FF_A) - $signed(FF_B);

	parameter signed threashold = $signed({9'd180,10'd0});
	parameter signed adjustment = $signed({9'd360,10'd0});
	
	always @(posedge clock) begin
		if (reset) begin
			FF_A <= 0;
			FF_B <= 0;
		end
		else if (sample) begin
			FF_A <= A;
			FF_B <= B;
		end
	end
	
	always @* begin
		if ( diff > threashold ) begin
			out = $signed(diff) - $signed(adjustment);
		end
		else if ( diff < -threashold ) begin
			out = $signed(diff) + $signed(adjustment);
		end
		else begin
			out = $signed(diff);
		end
	end


endmodule
