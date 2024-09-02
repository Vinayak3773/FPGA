module izhikevich_neuron_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg signed [15:0] I;
    wire signed [15:0] v;
    wire signed [15:0] u;

    // Instantiate the neuron module
    izhikevich_neuron dut (
        .clk(clk),
        .reset(reset),
        .I(I),
        .v(v),
        .u(u)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 10ns period -> 100 MHz clock
    end

    // Testbench sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        I = 16'sd20;  // Constant input current set to 20

        // Apply reset
        #10 reset = 0;

        // Observe neuron behavior with constant input current
        #500 $stop;  // Run simulation for a longer duration if needed
    end

    // Monitor neuron state
    initial begin
        $monitor("Time = %0d ns, I = %d, v = %d, u = %d", $time, I, v, u);
    end

endmodule