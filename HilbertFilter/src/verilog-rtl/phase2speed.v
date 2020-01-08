`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:03:55 12/17/2019 
// Design Name: 
// Module Name:    phase2speed 
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
module phase2speed #(parameter N = 6) (
	 input clock,
	 input reset,
	 input sample,
    input signed [18:0] phase,		// 9Q10
    output reg signed [15:0] speed,	// 6Q10
	 output reg ready
    );

	reg signed [18+N:0] sum; // (9+N)Q10
	reg [N+1:0] cnt;
	reg signed [18:0] avg;	// 9Q10
	
	parameter start_cnt = 2**N;
	parameter signed scale_factor = 15'd20450; // divided by 2^5 / 2^12
	
	wire [43:0] mult_buffer = ($signed({avg[18], avg[18], avg, 1'b0}) * $signed({1'b0, scale_factor, 6'b0}));

	always @(posedge clock) begin
		if (reset) begin
			sum <= 0;
			ready <= 0;
			cnt <= start_cnt;
			avg <= 0;
		end
		else if (sample) begin
			if (cnt) begin
				cnt <= cnt - 1'd1;
				sum <= sum + phase;
				ready <= 0;
			end
			else begin
				avg <= sum[18+N:N];
				sum <= 0;
				ready <= 1;
				cnt <= start_cnt;
			end
		end
	end
	
	always @* begin
		speed = mult_buffer[39:24];
	end


endmodule
