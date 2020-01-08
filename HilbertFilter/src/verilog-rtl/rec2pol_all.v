/*

    Integrated Master in Electrical and Computer Engineering - FEUP
	
	EEC0055 - Digital Systems Design 2019/2020
	
	----------------------------------------------------------------------
	module rec2pol 
	
	Summary
	CORDIC vectoring mode - convert rectangular coords to polar coords
	
	----------------------------------------------------------------------	
	Date created: 1 Nov 2019
	Author: jca@fe.up.pt

	----------------------------------------------------------------------		
	This Verilog code is property of the University of Porto, Portugal
	Its utilization beyond the scope of the course Digital Systems Design
	(Projeto de Sistemas Digitais) of the Integrated Master in Electrical 
	and Computer Engineering requires explicit authorization from the author.

*/

module rec2pol_all #(parameter ROMSIZE = 32, parameter COUNTERSIZE = 6, parameter INSIZE = 32, parameter OUTSIZE = 32) ( 
                input clock,
				input reset,
				input start,               // set to 1 for one clock to start 
				output busy,
				input  signed [INSIZE-1:0] x,    // X component, 16Q16
				input  signed [INSIZE-1:0] y,    // Y component, 16Q16
				output signed [OUTSIZE-1:0] mod,  // Modulus, 16Q16
				output signed [OUTSIZE-1:0] angle // Angle in degrees, 8Q24
			  );

// Instantiate the rec2pol module (datapath)
rec2pol #(.rom_size(ROMSIZE),
				.counter_bit_size(COUNTERSIZE),
				.in_size(INSIZE),
				.out_size(OUTSIZE)
			)
		rec2pol_1 (
			.clock(clock),
			.reset(reset),
			.start(start),
			.enable(enable),
			.x(x),
			.y(y),
			.mod( mod ),
			.angle( angle )
		);

// Instantiate the controller
rec2pol_control #(.count_to(ROMSIZE+1), .bit_size(COUNTERSIZE)) rec2pol_control_1 (
		.clock(clock),
		.reset(reset),
		.start(start),
		.busy(busy),
		.enable(enable)
		);

endmodule