`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:55:11 12/23/2019 
// Design Name: 
// Module Name:    phasecalc 
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
module phasecalc (
    input clock,
    input reset,
    input start,
    output busy,
    input signed [12:0] x,
    input signed [12:0] y,
    output signed [18:0] angle
    );

parameter ROMSIZE = 16;
parameter COUNTERSIZE = 5;
parameter INSIZE = 13;
parameter OUTSIZE = 19;

reg signed [INSIZE-1:0] x_2q;
wire signed [OUTSIZE-1:0] angle_2q;
reg signed [8:0] angle_correction;
reg sign;

always @(posedge start) begin
	//if (start) begin
		x_2q <= (x>=0) ? x : -x;
		sign <= (x>=0) ? 1'b1 : 1'b0;
		angle_correction <= (y>=0) ? 9'd180 : -(9'd180);
	//end
end

assign angle = sign ? angle_2q : $signed({angle_correction, 10'd0}) - angle_2q;

rec2pol_all #(.ROMSIZE(ROMSIZE),
				.COUNTERSIZE(COUNTERSIZE),
				.INSIZE(INSIZE),
				.OUTSIZE(OUTSIZE)
			)
		rec2pol_1 (
			.clock(clock),
			.reset(reset),
			.start(start),
			.busy(busy),
			.x(x_2q),
			.y(y),
			//.mod( mod ),
			.angle( angle_2q )
		);

endmodule
