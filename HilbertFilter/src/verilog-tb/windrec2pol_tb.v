`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:07:09 01/07/2020
// Design Name:   windrec2pol
// Module Name:   /home/lmsousa/Documents/MIEEC/PSDI/Project 3/HilbertFilter/windrec2pol_tb.v
// Project Name:  HilbertFilter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: windrec2pol
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module windrec2pol_tb;

	// Test Files
	parameter
	CLOCK_PERIOD = 10, // 10ns
	INPUTBITSIZE = 16,
	OUTPUTBITSIZE = 16,
	MAXSIMDATA = 8000,
	filename_speedX = "../simdata/speed_X.hex",
	filename_speedY = "../simdata/speed_Y.hex",
	filename_speed = "../simdata/speed.hex",
	filename_dir = "../simdata/dir.hex";

	// Inputs
	reg clock;
	reg reset;
	reg start;
	reg signed [INPUTBITSIZE-1:0] speedX;
	reg signed [INPUTBITSIZE-1:0] speedY;

	// Outputs
	wire busy;
	wire signed [OUTPUTBITSIZE-1:0] mod;
	wire signed [OUTPUTBITSIZE-1:0] angle;

	// Instantiate the Unit Under Test (UUT)
	windrec2pol uut (
		.clock(clock), 
		.reset(reset), 
		.start(start), 
		.speedX(speedX), 
		.speedY(speedY), 
		.busy(busy), 
		.mod(mod), 
		.angle(angle)
	);


	// Registers for test values
	reg signed [INPUTBITSIZE-1:0] testX [MAXSIMDATA-1:0];
	reg signed [INPUTBITSIZE-1:0] testY [MAXSIMDATA-1:0];
	reg signed [OUTPUTBITSIZE-1:0] testMod [MAXSIMDATA-1:0];
	reg signed [OUTPUTBITSIZE-1:0] testAngle [MAXSIMDATA-1:0];
	integer i = 0,
		e_cnt = 0;
	real error_mod = 0,
		error_angle = 0;


	initial begin
		// Generate the clock signal:
		forever #(CLOCK_PERIOD) clock = ~clock;
	end


	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 0;
		start = 0;
		speedX = 0;
		speedY = 0;

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
		$readmemh( filename_speedX, testX );
		$readmemh( filename_speedY, testY );
		$readmemh( filename_speed, testMod );
		$readmemh( filename_dir, testAngle );
		
		for (i = 0; i < MAXSIMDATA; i = i+1) begin
			speedX = testX[i];
			speedY = testY[i];
			#10;
			@(negedge clock);
			start = 1;
			@(negedge clock);
			start = 0;
			while (!busy) begin
				@(posedge clock);
			end

			error_mod = ($itor(testMod[i])/(2**10)) - ($itor(mod)/(2**10));
			error_angle = ($itor(testAngle[i])/(2**7)) - ($itor(angle)/(2**7));
			//if ((error_mod > 0.05 || error_mod < -0.05) || (error_angle > 0.05 || error_angle < -0.05)) begin
				e_cnt = e_cnt +1;
				$display("%f & %f --> %f : %f <> %f (error: %f) : %f (error: %f)", $itor(speedX)/(2**10), $itor(speedY)/(2**10), $itor(mod)/(2**10), $itor(angle)/(2**7), $itor(testMod[i])/(2**10), error_mod, $itor(testAngle[i])/(2**7), error_angle);
			//end
		end
		
		$display("\n\n%d ERROR(S) WERE FOUND", e_cnt);
		
		$finish;
	end
      
endmodule

