module izhikevich_neuron (
    input wire clk,
    input wire reset,
    input wire signed [15:0] I,  // Input current
    output reg signed [15:0] v,  // Membrane potential
    output reg signed [15:0] u   // Recovery variable
);

    // Parameters
    parameter signed [15:0] a = 16'sd2;     // Recovery time scale
    parameter signed [15:0] b = 16'sd1;     // Sensitivity of u to v
    parameter signed [15:0] c = -16'sd65;   // After-spike reset value of v
    parameter signed [15:0] d = 16'sd8;     // After-spike reset of u
    parameter signed [15:0] dt = 16'sd1;    // Time step

    // Internal variables - changed from reg to wire
    wire signed [31:0] v_next;
    wire signed [31:0] u_next;

    // Instantiate v_next_izhikevich and u_next_izhikevich modules
    v_next_izhikevich v_calc (
        .v(v),
        .u(u),
        .I(I),
        .dt(dt),
        .v_next(v_next)
    );

    u_next_izhikevich u_calc (
        .v(v),
        .u(u),
        .a(a),
        .b(b),
        .dt(dt),
        .u_next(u_next)
    );

    // FSM for updating neuron state
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            v <= -16'sd70;  // Initial value of v
            u <= 16'sd0;    // Initial value of u
        end else begin
            // Check for spike condition
            if (v_next >= 30) begin
                v <= c;     // Reset v to c after a spike
                u <= u + d; // Update u after a spike
            end else begin
                v <= v_next; // Update v
                u <= u_next; // Update u
            end
        end
    end
endmodule
