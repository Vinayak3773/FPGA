module u_next_izhikevich (
    input wire signed [15:0] v,  // Current membrane potential
    input wire signed [15:0] u,  // Current recovery variable
    input wire signed [15:0] a,  // Recovery time scale
    input wire signed [15:0] b,  // Sensitivity of u to v
    input wire signed [15:0] dt, // Time step
    output wire signed [31:0] u_next // Next recovery variable
);
    reg signed [31:0] u_next_reg;

    always @(*) begin
        // Calculate the next recovery variable using the Izhikevich equation
        u_next_reg = u + ((dt * (a * (b * v - u))) >>> 8);
    end

    assign u_next = u_next_reg; // Assign the computed value to the output wire
endmodule