`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: IEEE University of Porto Student Branch
// Engineer: Luís Miguel Sousa
//
// Create Date:   19:31:14 11/20/2019
// Design Name:   FlipFlop
// Module Name:   Project 3/HilbertFilter/FlipFlop_tb.v
// Project Name:  HilbertFilter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FlipFlop
//
// Dependencies:
// 
// Revision: 1
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FlipFlop_tb;

	parameter CLOCK_PERIOD    = 500; //ns
	parameter FF_size = 2;

	// Inputs
	reg [FF_size-1:0] D;
	reg EN;
	reg RST;
	reg clk;

	// Outputs
	wire [FF_size-1:0] Q;

	// Instantiate the Unit Under Test (UUT)
	FlipFlop uut (
		.D(D), 
		.Q(Q), 
		.EN(EN), 
		.RST(RST), 
		.clk(clk)
	);
	
	initial begin
		// Generate the clock signal:
		forever #(CLOCK_PERIOD/2) clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		D = 0;
		EN = 0;
		RST = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		for (D = 2^(FF_size-1); D != 0; D = D >> 1) begin
			@(posedge clk)
			if (Q != D) begin
				$display("[ERROR] ==> D=%d, Q=%d", D, Q);
			end
		end

	end
      
endmodule

