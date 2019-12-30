`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:30:58 12/30/2019 
// Design Name: 
// Module Name:    interpol 
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
module interpol #(parameter N=16, parameter M=16) (
    input clock,
	 input start,
    input reset,
    output ready,
	 input [N-1:0] X,
    output [M-1:0] Y
    );

// The lookup table, 16 locations, X and Y pairs: 
reg [ N + M - 1 : 0 ] LUTcalib[15:0];

//reg delta [N-1:0];
reg [4:0] ll;
reg [4:0] ul;
reg [4:0] i;
reg [4:0] sel;
reg [M -1 : 0] out;

assign Y = out;

// Load initial contents to the LUT from file datafile.hex: 
initial 
begin   
	$readmemh( "../simdata/atanLUT.hex", LUTcalib ); 
	ll = 0;
	ul = N;
	i = N;
	sel = N/2;
end 
 
always @(posedge clock) begin
	for (i = N; i > 0; i = i >> 1) begin
		if (X > LUTcalib[sel][N+M-1:M]) begin
			//greater
			if (!i) begin
				out <= (LUTcalib[sel][M-1:0] + LUTcalib[sel+1][M-1:0]) >> 1;
			end
			else begin	
				ll <= sel;
				sel <= sel+(ul-sel)/2;
			end
		end
		
		else if (X < LUTcalib[sel][N+M-1:M])begin
			//lower
			if (!i) begin
				out <= (LUTcalib[sel][M-1:0] + LUTcalib[sel-1][M-1:0]) >> 1;
			end
			else begin
				sel <= sel-(sel-ll)/2;
				ul <= sel;
			end
		end
		
		else begin
			if (!i) begin
				out <= LUTcalib[sel][M-1:0];
			end
			i = 0;
		end		
	end


	if (X > LUTcalib[sel][N+M-1:M]) begin
		out <= (LUTcalib[sel][M-1:0] + LUTcalib[sel+1][M-1:0]) >> 1;
	end
	else if (X < LUTcalib[sel][N+M-1:M]) begin
		out <= (LUTcalib[sel][M-1:0] + LUTcalib[sel-1][M-1:0]) >> 1;
	end
	else begin
		out <= LUTcalib[sel][M-1:0];
	end
	
end
endmodule
