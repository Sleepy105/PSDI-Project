`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:19:44 12/27/2019
// Design Name:   phasecalc
// Module Name:   /home/lmsousa/Documents/MIEEC/PSDI/Project 3/HilbertFilter/phasecalc_tb.v
// Project Name:  HilbertFilter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: phasecalc
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module phasecalc_tb;

	// Test Files
	parameter
	CLOCK_PERIOD = 10, // 10ns
	INPUTBITSIZE = 13,
	OUTPUTBITSIZE = 19,
	MAXSIMDATA = 8000,
	filename_phasecalc_X = "../simdata/real_rx4.hex",
	filename_phasecalc_Y = "../simdata/imag_rx4.hex",
	filename_phasecalc_angle = "../simdata/phase_rx4.hex";

	// Inputs
	reg clock;
	reg reset;
	reg start;
	reg signed [INPUTBITSIZE-1:0] X;
	reg signed [INPUTBITSIZE-1:0] Y;

	// Outputs
	wire busy;
	wire signed [OUTPUTBITSIZE-1:0] angle;

	// Instantiate the Unit Under Test (UUT)
	phasecalc uut (
		.clock(clock), 
		.reset(reset), 
		.start(start), 
		.busy(busy), 
		.x(X), 
		.y(Y), 
		.angle(angle)
	);


	// Registers for test values
	reg signed [INPUTBITSIZE-1:0] testX [MAXSIMDATA-1:0];
	reg signed [INPUTBITSIZE-1:0] testY [MAXSIMDATA-1:0];
	reg signed [OUTPUTBITSIZE-1:0] testAngle [MAXSIMDATA-1:0];
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
		Y = 0;

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
		$readmemh( filename_phasecalc_X, testX );
		$readmemh( filename_phasecalc_Y, testY );
		$readmemh( filename_phasecalc_angle, testAngle );
		
		for (i = 8; i < MAXSIMDATA; i = i+1) begin
			X = testX[i];
			Y = testY[i];
			#10;
			@(negedge clock);
			start = 1;
			@(negedge clock);
			start = 0;
			while (!busy) begin
				@(posedge clock);
			end

			error = 100 * ($itor(abs_out(testAngle[i]))/(2**10) - ($itor(abs_out(angle))/(2**10)) ) / ($itor(abs_out(angle))/(2**10)) ;
			if (error > 1 || error < -1) begin
				e_cnt = e_cnt +1;
				$display("%f & %f --> %f <> %f (error: %f%%)", X, Y, $itor(angle)/(2**10), $itor(testAngle[i])/(2**10), error);
			end
		end
		
		$display("\n\n%d ERROR(S) WERE FOUND", e_cnt);
		
		$finish;
	end
	
	function [OUTPUTBITSIZE-1:0] abs_out (input signed [OUTPUTBITSIZE-1:0] a);
		abs_out = (a[OUTPUTBITSIZE-1]) ? -a : a; // MSB check
	endfunction
      
endmodule

