`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:05:00 01/08/2020 
// Design Name: 
// Module Name:    wind 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module wind(
	 input clock,
    input reset,
	 input enable,
	 input sample,
    input [11:0] rxA,
    input [11:0] rxB,
	 input [3:0] meanlen,
    output [15:0] speed,
	 output ready
    );


wire [12:0] real2cpx_1_Re;
wire [12:0] real2cpx_1_Im;
wire [12:0] real2cpx_2_Re;
wire [12:0] real2cpx_2_Im;

wire [18:0] phasecalc_1_angle;
wire [18:0] phasecalc_2_angle;

wire [18:0] phasediff_1_out;
wire phasediff_1_ready;

// Hilbert Filter (8th order):
real2cpx	real2cpx_1 ( 
	.clock(clock),	// master clock
   .reset(reset),	// master reset, assynchronous, active high
	.EN(enable),
	.sample(sample),
   .IN(rxA),		// 12 integer bits
   .Re(real2cpx_1_Re),		// 13 integer bits
   .Im(real2cpx_1_Im)			// 13 integer bits
);

// CORDIC
phasecalc phasecalc_1 (
    .clock(clock),	// master clock
    .reset(reset),	// master reset, assynchronous, active high
    .start(sample),
    .x(real2cpx_1_Re),
    .y(real2cpx_1_Im),
	 .busy(),
    .angle(phasecalc_1_angle)
    );

// Hilbert Filter (8th order):
real2cpx	real2cpx_2 ( 
	.clock(clock),	// master clock (100MHz)
   .reset(reset),	// master reset, assynchronous, active high
	.EN(enable),
	.sample(sample),
   .IN(rxB),		// 12 integer bits
   .Re(real2cpx_2_Re),		// 13 integer bits
   .Im(real2cpx_2_Im)			// 13 integer bits
);

// CORDIC
phasecalc phasecalc_2 (
    .clock(clock),	// master clock
    .reset(reset),	// master reset, assynchronous, active high
    .start(sample),
    .x(real2cpx_2_Re),
    .y(real2cpx_2_Im),
	 .busy(),
    .angle(phasecalc_2_angle)
    );

// Calculate the phase difference between both sensors on one axis
phasediff phasediff_1 (
	 .clock(clock),	// master clock
    .reset(reset),	// master reset, assynchronous, active high
    .sample(sample),
    .A(phasecalc_1_angle),				// 9Q10
    .B(phasecalc_2_angle),				// 9Q10
    .out(phasediff_1_out),	// 9Q10
	 .ready(phasediff_1_ready)
);

// Convert the phase difference to a speed value
phase2speed phase2speed_1 (
	 .clock(clock),	// master clock
    .reset(reset),	// master reset, assynchronous, active high
    .sample(phasediff_1_ready),
	 .meanlen(meanlen),
    .phase(phasediff_1_out),		// 9Q10
    .speed(speed),	// 6Q10
	 .ready(ready)
    );

endmodule
