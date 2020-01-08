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
    output reg ready,
	 input signed [N-1:0] X,
    output reg signed [M-1:0] Y
    );

	// The lookup table, 16 locations, X and Y pairs: 
	reg [ N + M - 1 : 0 ] LUTcalib [15:0];

	reg signed  [N-1:0] xbuff;
	reg signed [M-1:0] ybuff;
	reg [3:0] cnt;
	reg state;
	wire sign;
	assign sign = (xbuff < 0);

	// Load initial contents to the LUT from file 'datafile.hex':
	initial begin
		$readmemh( "../simdata/LUTdatafile.hex", LUTcalib ); 
	end
	
	// FSM states:
	parameter ST_IDLE = 1'b0,
				 ST_RUN  = 1'b1;
	 
	always @(posedge clock) begin
		
		if (reset) begin
			// reset values on all registers
			cnt <= 0;
			xbuff <= 0;
			ybuff <= 0;
		end
		else begin
			// Normal calculation process
			case ( state )
				ST_IDLE:
					if (start) begin
						state <= ST_RUN;
						ready <= 0;
						xbuff <= X;
					end
				ST_RUN: begin
					xbuff <= sign ? (xbuff + LUTcalib[cnt][N+M-1:M]) : (xbuff - LUTcalib[cnt][N+M-1:M]);
					ybuff <= sign ? (ybuff - LUTcalib[cnt][N-1:0]) : (ybuff + LUTcalib[cnt][N-1:0]);
					// operations are in reverse

					if ( cnt == 15 ) begin
						cnt <= 1'b0;
						Y <= ybuff;
						ready <= 1;
						state <= ST_IDLE;
					end
					else begin
						cnt <= cnt + 1;
					end
				end
			endcase
		end
	end
endmodule
