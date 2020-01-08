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
module interpol #(parameter LUTSIZE = 16, parameter COUNTERBITS = 5, parameter N=16, parameter QN=10, parameter M=16, parameter QM=10) (
    input clock,
	 input start,
    input reset,
    output reg ready,
	 input signed [N-1:0] X,
    output reg signed [M-1:0] Y
    );

	// The lookup table, 16 locations, X and Y pairs: 
	reg signed [ N + M - 1 : 0 ] LUT [LUTSIZE-1:0];
	reg [COUNTERBITS-1:0] i;

	reg signed  [N-1:0] xbuff;
	reg signed [15:0] m;
	reg signed [15:0] b;

	// Load initial contents to the LUT from file 'datafile.hex':
	initial begin
		$readmemh( "../simdata/LUTdatafile.hex", LUT ); 
	end
	
	// FSM states:
	reg [2:0] state;
	parameter ST_IDLE 	= 3'b000,
				 ST_SEARCH	= 3'b001,
				 ST_CALCM	= 3'b010,
				 ST_CALCB	= 3'b011,
				 ST_CALCY	= 3'b100;
	 
	always @(posedge clock) begin
		
		if (reset) begin
			// reset values on all registers
			state <= ST_IDLE;
			xbuff <= 0;
			m <= 0;
			b <= 0;
			i <= 0;
			ready <= 1;
		end
		else begin
			// Normal calculation process
			case ( state )
				ST_IDLE:
					if (start) begin
						state <= ST_SEARCH;
						ready <= 0;
						m <= 0;
						b <= 0;
						i <= 0;
						xbuff <= X;
					end
				ST_SEARCH: begin
						if (xbuff < $signed(LUT[i][N+M-1:M])) begin
							state <= ST_CALCM;
							i <= i ? i : 2'b01;
						end
						else if (i < LUTSIZE) begin
							i <= i + 2'b01;
						end
						else begin
							state <= ST_CALCM;
							i <= i ? i : 2'b01;
						end
					end
				ST_CALCM: begin
						m <= ( ($signed($signed(LUT[i][N-1:0])) - $signed(LUT[i-1][N-1:0])) / ($signed($signed(LUT[i][N+M-1:M]) - $signed(LUT[i-1][N+M-1:M])) >>> 7) );
						state <= ST_CALCB;
					end
				ST_CALCB: begin
						b <= $signed(LUT[i][N-1:0]) - ($signed(m*$signed(LUT[i][N+M-1:M]))>>>7);
						state <= ST_CALCY;
					end
				ST_CALCY: begin
						Y <= ((m*xbuff) >>> QN) + b;
						ready <= 1;
						state <= ST_IDLE;
					end
			endcase
		end
	end
endmodule
