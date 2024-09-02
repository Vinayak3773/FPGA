module AdExNeuron_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg signed [15:0] I;
    wire signed [15:0] v;
    wire signed [15:0] u;

    // File handle for output
    integer file_handle;

    // Instantiate the neuron module
    AdExNeuron dut (
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
        // Open file for writing
        file_handle = $fopen("AdExNeuron_data.txt", "w");
        if (file_handle == 0) begin
            $display("Failed to open file for writing");
            $finish;
        end

        // Initialize signals
        clk = 0;
        reset = 1;
        I = 16'sd200; // Constant input current

        // Apply reset
        #10 reset = 0;

        // Let the simulation run for 100 ms (100,000,000 ns)
        #100000000 $stop; // Run simulation for 100 ms

        // Close the file
        $fclose(file_handle);
    end

    // Monitor neuron state and write to file
    initial begin
        $monitor("Time = %0d ns, I = %d, v = %d, u = %d", $time, I, v, u);
        forever begin
            @(posedge clk); // Write on every positive clock edge
            $fwrite(file_handle, "%0d, %d, %d, %d\n", $time, I, v, u);
        end
    end

endmodule
