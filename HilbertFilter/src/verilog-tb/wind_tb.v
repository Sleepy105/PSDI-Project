`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:07:37 01/08/2020
// Design Name:   wind
// Module Name:   /home/lmsousa/Documents/MIEEC/PSDI/Project 3/HilbertFilter/src/verilog-tb/wind_tb.v
// Project Name:  HilbertFilter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: wind
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module wind_tb;

	// Test Files
	parameter
	CLOCK_PERIOD = 10, // 10ns
	INPUTBITSIZE = 13,
	OUTPUTBITSIZE = 19,
	MAXSIMDATA = 8000,
	filename_rx1 = "../simdata/real_rx1.hex",
	filename_rx3 = "../simdata/imag_rx3.hex",
	filename_out = "../simdata/speed_Y.hex",
	filename_params = "../simdata/params.hex";

	// Inputs
	reg clock;
	reg reset;
	reg enable;
	reg sample;
	reg [11:0] rxA;
	reg [11:0] rxB;
	reg [3:0] meanlen [0:0];

	// Outputs
	wire [15:0] speed;
	wire ready;

	// Instantiate the Unit Under Test (UUT)
	wind uut (
		.clock(clock), 
		.reset(reset), 
		.enable(enable), 
		.sample(sample), 
		.rxA(rxA), 
		.rxB(rxB), 
		.meanlen(meanlen[0]), 
		.speed(speed), 
		.ready(ready)
	);
	
	// Registers for test values
	reg signed [INPUTBITSIZE-1:0] testRX1 [MAXSIMDATA-1:0];
	reg signed [INPUTBITSIZE-1:0] testRX3 [MAXSIMDATA-1:0];
	reg signed [OUTPUTBITSIZE-1:0] testOut [MAXSIMDATA-1:0];
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
		enable = 0;
		sample = 0;
		rxA = 0;
		rxB = 0;
		meanlen[0] = 4'd6;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		@(posedge clock);
		#10
		reset = 1;
		@(posedge clock);
		#10
		reset = 0;
		enable = 1;
		sample = 1;
		
		// Read test values from files
		$readmemh( filename_rx1, testRX1 );
		$readmemh( filename_rx3, testRX3 );
		$readmemh( filename_out, testOut );
		$readmemh( filename_params, meanlen );
		
		for (i = 8; i < MAXSIMDATA; i = i+1) begin
			rxA = testRX1[i];
			rxB = testRX3[i];
			#10;
			while (!ready) begin
				@(posedge clock);
			end

			error = ($itor(testOut[i])/(2**10)) - ($itor(speed)/(2**10));
			//if (error > 0.05 || error < -0.05) begin
				e_cnt = e_cnt +1;
				$display("%d & %d --> %f <> %f (error: %f)", rxA, rxB, $itor(speed)/(2**10), $itor(testOut[i])/(2**10), error);
			//end
		end
		
		$display("\n\n%d ERROR(S) WERE FOUND", e_cnt);
		
		$finish;

	end
      
endmodule

