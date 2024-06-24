module neuron_multiplier(
    input signed [7:0] in1, // 8-bit input 1
    input signed [7:0] in2, // 8-bit input 2
    input signed [7:0] in3, // 8-bit input 3
    output signed [15:0] out1, // 16-bit output for weighted input 1
    output signed [15:0] out2, // 16-bit output for weighted input 2
    output signed [15:0] out3  // 16-bit output for weighted input 3
);

    // Weight as a fixed-point number with 8 bits for the fractional part
    parameter signed [15:0] weight = 16'b00000000_01011001; // 0.35 in 8.8 fixed-point format

    // Multiply inputs by the weight
    assign out1 = in1 * weight;
    assign out2 = in2 * weight;
    assign out3 = in3 * weight;

endmodule
	
module neuron_adder(
	input signed [15,0] in1,
	input signed [15,0] in2,
	input signed [15,0] in3,
	output signed [15,0] netout
);
	always @* begin
		netout = in1+in2+in3;
	end
endmodule

module neuron_comparator(
	input signed [15,0] netout,
	outout unsigned [7,0] outt
);
	parameter signed [15,0] threshold = 16'b00000000_01110000; //.456
	
	always @*begin
		if(netout > threshold) begin
			outt =1;
		end else begin
			outt = 0;
		end
	end
endmodule