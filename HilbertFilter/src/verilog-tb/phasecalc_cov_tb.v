`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:58:07 12/27/2019
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

module phasecalc_cov_tb;

	parameter
	CLOCK_PERIOD = 10, // 10ns
	// set to zero to disable printing the simulation results 
	// by the task "execcordic"
	printresults = 1;

	// Inputs
	reg clock;
	reg reset;
	reg start;
	reg [12:0] x;
	reg [12:0] y;

	// Outputs
	wire busy;
	wire [18:0] angle;

	// Instantiate the Unit Under Test (UUT)
	phasecalc uut (
		.clock(clock), 
		.reset(reset), 
		.start(start), 
		.busy(busy), 
		.x(x), 
		.y(y), 
		.angle(angle)
	);

	// Generate the clock (10 ns period, frequency = 100 MHz)
	initial begin
		// Generate the clock signal:
		forever #(CLOCK_PERIOD) clock = ~clock;
	end
	
	reg [31:0] i;
	reg [31:0] j;

	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 0;
		start = 0;
		x = 0;
		y = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		@(posedge clock);
		#10
		reset = 1;
		@(posedge clock);
		#10
		reset = 0;
		
		#10
		// Wait for realising the reset:
		@(negedge reset);
		// Wait 10 clock cycles
		//	This is not required but helps analysing the signals in the
		//    waveform window.
		repeat (10)
		@(negedge clock);

		// Call the task to start a conversion:
		execcordic(1, 123, 0, 456, 0 );
		execcordic(1, 0, 0, 456, 0 );
		execcordic(1, -123, 0, 456, 0 );
		execcordic(1, -123, 0, 0, 0 );
		execcordic(1, -123, 0, -456, 0 );
		execcordic(1, 0, 0, -456, 0 );
		execcordic(1, 123, 0, -456, 0 );
		execcordic(1, 123, 0, 0, 0 );
		execcordic(1, 0, 0, 0, 0 );

		i = 32'h80000000;
		while (i > 0) begin
			j = 32'h80000000;
			while (j > 0) begin
				execcordic(0, i[31:16], i[15:0], j[31:16], j[15:0] );
				j = j >> 1;
			end
			i = i >> 1;
		end
		execcordic(0, 0, 0, 0, 0 );

		$finish;

	end


	//--------------------------------------------------------------------
	// float parameters to convert the integer results to fractional results:
	real fracfactor = 1<<16;
	real fracfactorangle = 1<<23;
	real PI = 3.1415926536;
	
	// The X and Y in float format, required to compute the real values:
	real Xr, Yr;
	
	// The "true" values of modules, angle and the % errors:
	real real_mod, real_atan, err_mod, err_atan;
	
	//--------------------------------------------------------------------
	// Execute a CORDIC: 
	//   apply inputs, set enable to 1, raise start for 1 clock cycle, wait 32 clock cyles
	// set variable "printresults" to 1 to enable printing the results during simulation
	task execcordic;
	input print;
	input signed [8:0] X;
	input signed [9:0] X_dec;
	input signed [8:0] Y;
	input signed [9:0] Y_dec;
	reg signed [18:0] x0;
	reg signed [18:0] y0;
	begin
	   x0 = {X,X_dec};
	   y0 = {Y,Y_dec};
	   
	   start = 1;
	   @(negedge clock);
	   start = 0;
	   
	   
	   // Wait some clocks to separate the calls to the task
	   repeat( 10 )
	   	@(negedge clock);
	   
	   if ( printresults )
	   begin  
	   	// Calculate the expected results:
	   	  Xr = X;
	   	  Yr = Y;
	   	  //real_mod = $sqrt( Xr*Xr+Yr*Yr);
	   	  real_atan = $atan2(Yr,Xr) * 180 / PI;
	   	  //err_mod = 100 * ( real_mod - (mod / fracfactor) ) / (mod / fracfactor);
	   	  err_atan = 100 * ( real_atan - (angle / fracfactorangle) ) / (angle / fracfactorangle);
	          
		  if (print)
		  begin
	   	  	$display("Xi=%d, Yi = %d, Angle=%f drg Exptd: A=%f drg (ERRORs = %f%%)",
	   	  		       X, Y, angle / fracfactorangle,
	   	  		       real_atan, err_atan );
		  end
	    end
	
	end
	endtask
      
endmodule

