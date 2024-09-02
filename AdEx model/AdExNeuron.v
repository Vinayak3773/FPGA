module AdExNeuron (
    input wire clk,
    input wire reset,
    input wire signed [15:0] I,  // Input current
    output reg signed [15:0] v,  // Membrane potential
    output reg signed [15:0] u   // Adaptation current
);

    // Parameters
    parameter signed [15:0] v_t = 16'sd30;          // Threshold for spiking
    parameter signed [15:0] dt = 16'sd5;            // Time step
    parameter signed [15:0] v_reset = -16'sd65;     // Reset value for membrane potential
    parameter signed [15:0] u_reset = 16'sd0;       // Reset value for adaptation current
    parameter signed [15:0] u_spike = 16'sd200;     // Spike increment for adaptation current

    // Internal signals
    wire signed [31:0] VNext;
    wire signed [31:0] UNext;

    // Instantiate the modules
    v_next_calculation v_calc (
        .v(v),
        .u(u),
        .I(I),
        .dt(dt),
        .v_next(VNext)
    );

    u_next_calculation u_calc (
        .v(v),
        .u(u),
        .dt(dt),
        .u_next(UNext)
    );

    // FSM for updating neuron state
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            v <= v_reset;  // Reset membrane potential
            u <= u_reset;  // Reset adaptation current
        end else begin
            if (v >= v_t) begin
                v <= v_reset;  // Spike: reset v
                u <= u + u_spike;  // Increase adaptation current
            end else begin
                v <= VNext[15:0];  // Update v
                u <= UNext[15:0];  // Update u
            end
        end
    end
endmodule

