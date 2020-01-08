`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:05:50 12/30/2019 
// Design Name: 
// Module Name:    windrec2pol 
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
module windrec2pol(
	 input clock,
    input reset,
    input start,
    input signed [15:0] speedX,
    input signed [15:0] speedY,
	 output busy,
    output signed [15:0] mod,
    output signed [15:0] angle
    );


parameter ROMSIZE = 16;
parameter COUNTERSIZE = 5;
parameter INSIZE = 16;
parameter OUTSIZE = 19;

reg signed [INSIZE-1:0] x_2q;
wire signed [OUTSIZE-1:0] mod_19;
wire signed [OUTSIZE-1:0] angle_2q;
wire signed [OUTSIZE-1:0] angle_19;
reg signed [8:0] angle_correction;
reg sign;

initial begin
	x_2q = 0;
end

always @(posedge start) begin
	//if (start) begin
		x_2q <= (speedX>=0) ? speedX : -speedX;
		sign <= (speedX>=0) ? 1'b1 : 1'b0;
		angle_correction <= (speedY>=0) ? 9'd180 : -(9'd180);
	//end
end

assign mod = mod_19[15:0];
assign angle_19 = sign ? angle_2q : $signed({angle_correction, 10'd0}) - angle_2q;
assign angle = angle_19[18:3];

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
			.y(speedY),
			.mod( mod_19 ),
			.angle( angle_2q )
		);

endmodule
