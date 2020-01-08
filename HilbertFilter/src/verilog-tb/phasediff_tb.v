`timescale 10ns / 10ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:49:06 12/17/2019
// Design Name:   phasediff
// Module Name:   HilbertFilter/phasediff_tb.v
// Project Name:  HilbertFilter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: phasediff
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module phasediff_tb;

	// Test Files
	parameter
	CLOCK_PERIOD = 10, // 10ns
	MAXSIMDATA = 8000,
	filename_phasediff_A = "../simdata/phase_rx1.hex",
	filename_phasediff_B = "../simdata/phase_rx3.hex",
	filename_phasediff_out = "../simdata/phasediff_Y.hex";
	

	// Inputs
	reg signed [18:0] A;
	reg signed [18:0] B;
	reg clock;
	reg reset;
	reg sample;

	// Outputs
	wire [18:0] out;

	// Instantiate the Unit Under Test (UUT)
	phasediff uut (
		.clock(clock),
		.reset(reset),
		.sample(sample),
		.A(A), 
		.B(B), 
		.out(out)
	);

	// Registers for test values
	reg signed [18:0] testA [MAXSIMDATA-1:0];
	reg signed [18:0] testB [MAXSIMDATA-1:0];
	reg signed [18:0] testOut [MAXSIMDATA-1:0];
	integer i = 0,
		e_cnt = 0;
	real error = 0;
	parameter frac_divider = (1<<10);
	
	
	initial begin
		// Generate the clock signal:
		forever #(CLOCK_PERIOD) clock = ~clock;
	end
	
	
	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 0;
		sample = 0;
		A = 0;
		B = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		@(posedge clock);
		#10
		reset = 1;
		@(posedge clock);
		#10
		reset = 0;
		sample = 1;
        
		// Read test values from files
		$readmemh( filename_phasediff_A, testA );
		$readmemh( filename_phasediff_B, testB );
		$readmemh( filename_phasediff_out, testOut );
		
		for (i = 8; i < MAXSIMDATA; i = i+1) begin
			A = testA[i];
			B = testB[i];
			#10;
			@(posedge clock);
			#10
			error = 100 * ( $itor(testOut[i]) - $itor(out) ) / $itor(out);
			if (error > 0.05 || error < -0.05) begin
				e_cnt = e_cnt +1;
				$display("%f - %f = %f <--> %f (error: %f%%)", $itor(A)/(2**10), $itor(B)/(2**10), $itor(out)/(2**10), $itor(testOut[i])/(2**10), error);
			end
		end
		
		$display("\n\n%d ERROR(S) WERE FOUND", e_cnt);
		
		$finish;
	end
      
endmodule

