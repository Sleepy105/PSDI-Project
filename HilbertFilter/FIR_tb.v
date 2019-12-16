`timescale 10ns / 10ns

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

	parameter CLOCK_PERIOD = 10; // ns

	// Inputs
	reg clock;
	reg [11:0] IN;
	reg reset;
	reg EN;

	// Outputs
	wire [12:0] Re;
	wire [12:0] Im;

	// Instantiate the Unit Under Test (UUT)
	FIR uut (
		.clock(clock), 
		.IN(IN),
		.EN(EN),
		.reset(reset), 
		.Re(Re), 
		.Im(Im)
	);
	
	integer               data_file1    ; // file handler
	integer               scan_file1    ; // file handler
	integer               data_file2    ; // file handler
	integer               scan_file2    ; // file handler
	integer               data_file3    ; // file handler
	integer               scan_file3    ; // file handler
	real error;
	reg   [11:0] rxuw;
	reg   [11:0] realuw;
	reg   [11:0] imaguw;
	reg	[4:0]	 cnt;
	`define NULL 0
	
	parameter cadence = 20-1;
	
	initial begin
		// Generate the clock signal:
		forever #(CLOCK_PERIOD) clock = ~clock;
	end

	initial begin
		// Initialize Inputs
		clock = 0;
		IN = 0;
		reset = 0;
		EN = 0;
		cnt = cadence;

		// Wait 100 ns for global reset to finish
		#50;
		$display("Starting\n");
		
		data_file1 = $fopen("text1.txt", "r");
		data_file2 = $fopen("text2.txt", "r");
		data_file3 = $fopen("text3.txt", "r");
		if (data_file1 == `NULL) begin
			$display("data_file handle was NULL");
			$finish;
		end
        
		// Add stimulus here
		@(posedge clock);
		#10
		reset = 1;
		@(posedge clock);
		#10
		reset = 0;
		EN = 1;
		scan_file1 = $fscanf(data_file1, "%b\n", rxuw);
		scan_file2 = $fscanf(data_file2, "%b\n", realuw);
		scan_file3 = $fscanf(data_file3, "%b\n", imaguw);
	end

	always @(posedge clock) begin
		if (EN) begin
			if (cnt) begin
				cnt <= cnt - 5'd1;
			end
			else begin
				cnt <= cadence;
			
				scan_file1 = $fscanf(data_file1, "%b\n", rxuw);
				scan_file2 = $fscanf(data_file2, "%b\n", realuw);
				scan_file3 = $fscanf(data_file3, "%b\n", imaguw);
				IN = rxuw;

				if (!$feof(data_file1)) begin
					$display("[file]->%x,%x,%x", rxuw, {realuw[11], realuw}, {imaguw[11], imaguw});
					#1
					error = 100 * ( {imaguw[11], imaguw} - Im ) / Im;
					$display("[firm]->%x,%x,%x --> delta: %f%%\n", IN, Re, Im, error);
				end
				else begin
					$finish;
				end
			end
		end
	end

	
	
	/*initial begin
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
	end*/
      
endmodule

