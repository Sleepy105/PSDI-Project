`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IEEE University of Porto Student Branch
// Engineer: Luís Miguel Sousa
// 
// Create Date:    18:58:11 11/20/2019 
// Design Name: 	 Variable size FLipFlop Register
// Module Name:    FlipFlop 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 1
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FlipFlop #(parameter size=1) (
    input [size-1:0] D,
    output reg [size-1:0] Q,
    input EN,
    input RST,
	 input clk
    );

always @(posedge clk)
begin
	if (RST) begin
		Q <= 0;
	end
	else if (EN) begin
		Q <= D;
	end
end

endmodule
