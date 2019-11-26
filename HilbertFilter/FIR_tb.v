`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: IEEE University of Porto Student Branch
// Engineer: Luís Miguel Sousa
//
// Create Date:   19:15:26 11/20/2019
// Design Name:   FIR
// Module Name:   Project 3/HilbertFilter/FIR_tb.v
// Project Name:  HilbertFilter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FIR
//
// Dependencies:
// 
// Revision: 1
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FIR_tb;

	parameter CLOCK_PERIOD = 500; // ns

	// Inputs
	reg clock;
	reg [11:0] IN;
	reg reset;

	// Outputs
	wire [11:0] Re;
	wire [11:0] Im;

	// Instantiate the Unit Under Test (UUT)
	FIR #(12, 11) uut (
		.clock(clock), 
		.IN(IN), 
		.reset(reset), 
		.Re(Re), 
		.Im(Im)
	);
	
	initial begin
		// Generate the clock signal:
		forever #(CLOCK_PERIOD/2) clock = ~clock;
	end

	initial begin
		// Initialize Inputs
		clock = 0;
		IN = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		@(posedge clock);
		reset = 1;
		@(negedge clock);
		reset = 0;
	end
	
	initial begin
		#10
		@(negedge reset);
		repeat(10)
			@(negedge clock);
		
		@(posedge clock);
		IN = 0;
		@(negedge clock);
		IN = 12'b1000_0000_0000;
		
		while (IN != 0) begin
			@(posedge clock);
			IN = IN >> 1;
			@(negedge clock);
		end
		
		$finish;
	end
      
endmodule

