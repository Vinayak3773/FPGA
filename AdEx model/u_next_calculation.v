module u_next_calculation (
    input wire signed [15:0] v,  // Current membrane potential
    input wire signed [15:0] u,  // Current adaptation current
    input wire signed [15:0] dt, // Time step
    output reg signed [31:0] u_next // Next adaptation current
);
    // Parameters for the AdEx model
    parameter signed [15:0] a = 16'sd2;   // Adaptation coupling, scaled for fixed-point
    parameter signed [15:0] E_L = -16'sd70; // Leak reversal potential

    reg signed [31:0] u_diff; // Differential term for u

    always @(*) begin
        u_diff = ((a * (v - E_L)) >>> 12) - u;   // Calculate the differential term with scaling
        u_next = u + ((dt * u_diff) >>> 12);     // Euler integration with scaling
    end
endmodule
