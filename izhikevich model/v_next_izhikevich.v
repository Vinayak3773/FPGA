module v_next_izhikevich (
    input wire signed [15:0] v,  // Current membrane potential
    input wire signed [15:0] u,  // Current recovery variable
    input wire signed [15:0] I,  // Input current
    input wire signed [15:0] dt, // Time step
    output wire signed [31:0] v_next // Next membrane potential
);
    // Internal variables for intermediate calculations
    reg signed [31:0] v_term1;
    reg signed [31:32] v_term2;
    reg signed [31:0] v_term3;
    reg signed [31:0] v_term4;
    reg signed [31:0] v_next_reg;

    always @(*) begin
        // Breaking down the complex equation into parts
        v_term1 = 16'sd4 * v * v / 10000;        // v^2 term scaled by 100 (division by 10000 to account for 0.04)
        v_term2 = 16'sd5 * v / 100;              // 5*v term scaled by 100
        v_term3 = 16'sd140;                      // Constant term 140
        v_term4 = v_term1 + v_term2 + v_term3 - u + I; // Combine terms

        // Calculate next v with correct scaling
        v_next_reg = v + (dt * v_term4);
    end

    assign v_next = v_next_reg;
endmodule
