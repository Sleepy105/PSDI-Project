`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:53:03 12/23/2019
// Design Name:   phase2speed
// Module Name:   /home/lmsousa/Documents/MIEEC/PSDI/Project 3/HilbertFilter/phase2speed_tb.v
// Project Name:  HilbertFilter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: phase2speed
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module phase2speed_tb;

	// Test Files
	parameter
	CLOCK_PERIOD = 10, // 10ns
	filename_in = "../simdata/phasediff_Y.hex",
	filename_out = "../simdata/speed_Y.hex",
	filename_params = "../simdata/params.hex";
	integer data_file_in;   // file handler
	integer scan_file_in;   // file handler
	integer data_file_out;	// file handler
	integer scan_file_out;	// file handler
	reg signed [15:0] gt; // ground truth
	real error = 0;

	// Inputs
	reg clock;
	reg reset;
	reg sample;
	reg signed [18:0] phase;
	reg [3:0] meanlen [0:0];

	// Outputs
	wire signed [15:0] speed;
	wire ready;

	// Instantiate the Unit Under Test (UUT)
	phase2speed uut (
		.clock(clock), 
		.reset(reset), 
		.sample(sample),
		.meanlen(meanlen[0]),
		.phase(phase), 
		.speed(speed), 
		.ready(ready)
	);

	initial begin
		// Generate the clock signal:
		forever #(CLOCK_PERIOD) clock = ~clock;
	end

	initial begin
		// Initialize Inputs
		clock = 0;
		start = 0;
		reset = 0;
		sample = 0;
		phase = 0;
		$readmemh(filename_params, meanlen);
		data_file_in = $fopen(filename_in, "r");
		data_file_out = $fopen(filename_out, "r");
		scan_file_in <= $fscanf(data_file_in, "%x\n", phase);

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		@(posedge clock);
		#10
		reset = 1;
		@(posedge clock);
		#10
		reset = 0;
		start = 1;
	end
	
	reg start;
	reg [2:0] doit = 3'd4;
	
	always @(posedge clock) begin
		if (start) begin
			if (doit) begin
				doit = doit -1;
				sample <= 0;
			end
			else begin
				doit <= 3'd4;
				sample <= 1;
				if ($feof(data_file_in)) begin
					$finish;
				end
				if (ready) begin
					scan_file_out <= $fscanf(data_file_out, "%x\n", gt);
					error = 100 * ( ($itor(speed)/(2**10)) - ($itor(gt)/(2**10)) ) / ($itor(gt)/(2**10));
					$display("%f <--> %f (error: %f%%)", $itor(speed)/(2**10), $itor(gt)/(2**10), error);
				end
				else
					scan_file_in <= $fscanf(data_file_in, "%x\n", phase);
			end
		end
	end
      
endmodule

