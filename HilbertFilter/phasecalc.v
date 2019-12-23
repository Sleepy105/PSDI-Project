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
    input [12:0] x,
    input [12:0] y,
    output [18:0] angle
    );

parameter ROMSIZE = 16;
parameter COUNTERSIZE = 5;
parameter INSIZE = 13;
parameter OUTSIZE = 19;

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
			.x(x),
			.y(y),
			//.mod( mod ),
			.angle( angle )
		);

endmodule
