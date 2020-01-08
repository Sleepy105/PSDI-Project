`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:17:41 01/08/2020
// Design Name:   interpol
// Module Name:   /home/lmsousa/Documents/MIEEC/PSDI/Project 3/HilbertFilter/src/verilog-tb/interpol_tb.v
// Project Name:  HilbertFilter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: interpol
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module interpol_tb;

	// Test Files
	parameter
	CLOCK_PERIOD = 10, // 10ns
	INPUTBITSIZE = 16,
	OUTPUTBITSIZE = 16,
	MAXSIMDATA = 60000,
	filename_out = "../simdata/calib.hex";

	// Inputs
	reg clock;
	reg reset;
	reg start;
	reg signed [INPUTBITSIZE-1:0] X;

	// Outputs
	wire ready;
	wire signed [OUTPUTBITSIZE-1:0] Y;

	// Instantiate the Unit Under Test (UUT)
	interpol #(.LUTSIZE(16), .COUNTERBITS(5), .N(INPUTBITSIZE), .QN(10), .M(OUTPUTBITSIZE), .QM(10)) uut (
		.clock(clock), 
		.start(start), 
		.reset(reset), 
		.ready(ready), 
		.X(X), 
		.Y(Y)
	);

	
	// Registers for test values
	reg signed [INPUTBITSIZE-1:0] testOut [MAXSIMDATA-1:0];
	integer i = 0,
		e_cnt = 0;
	real error = 0;



	initial begin
		// Generate the clock signal:
		forever #(CLOCK_PERIOD) clock = ~clock;
	end


	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 0;
		start = 0;
		X = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		@(posedge clock);
		#10
		reset = 1;
		@(posedge clock);
		#10
		reset = 0;

		// Read test values from files
		$readmemh( filename_out, testOut );
		
		for (i = 0; i < MAXSIMDATA; i = i+1) begin
			X = i - (MAXSIMDATA/2);
			#10;
			@(posedge clock);
			start = 1;
			@(posedge clock);
			@(negedge clock);
			start = 0;
			while (!ready) begin
				@(posedge clock);
			end

			error = (testOut[i] - Y);
			//if (error > 0.05 || error < -0.05) begin
				e_cnt = e_cnt +1;
				$display("%d --> %d <> %d (error: %d)", X, Y, testOut[i], error);
			//end
		end
		
		$display("\n\n%d ERROR(S) WERE FOUND", e_cnt);
		
		$finish;

	end
      
endmodule

