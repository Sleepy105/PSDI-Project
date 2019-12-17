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
    input signed [18:0] A,
    input signed [18:0] B,
    output reg signed [18:0] out
    );
	
	wire signed [18:0] diff = $signed(A) - $signed(B);
	
	parameter signed threashold = $signed({9'd180,10'd0});
	parameter signed adjustment = $signed({9'd360,10'd0});
	
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
