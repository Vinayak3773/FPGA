module v_next_calculation (
    input wire signed [15:0] v,  // Current membrane potential
    input wire signed [15:0] u,  // Current adaptation current
    input wire signed [15:0] I,  // Input current
    input wire signed [15:0] dt, // Time step
    output reg signed [31:0] v_next // Next membrane potential
);
    // Parameters for the AdEx model
    parameter signed [15:0] C = 16'sd200;         // Membrane capacitance
    parameter signed [15:0] g_L = 16'sd10;        // Leak conductance
    parameter signed [15:0] E_L = -16'sd70;       // Leak reversal potential
    parameter signed [15:0] Delta_T = 16'sd2;     // Slope factor
    parameter signed [15:0] V_T = -16'sd55;       // Spike threshold

    reg signed [31:0] exp_term;                   // Exponential term
    reg signed [31:0] v_leak;                     // Leak term
    reg signed [31:0] v_diff;                     // Differential term

    always @(*) begin
        // Calculate terms with no scaling to observe values
        exp_term = g_L * Delta_T * ($exp((v - V_T) / Delta_T)); 
        v_leak = g_L * (v - E_L);
        v_diff = ((v_leak - u + I) + exp_term) / C;
        v_next = v + dt * v_diff;

        // Debugging: Add display statements
        $display("v: %d, v_leak: %d, exp_term: %d, v_diff: %d, v_next: %d", v, v_leak, exp_term, v_diff, v_next);
    end
endmodule

