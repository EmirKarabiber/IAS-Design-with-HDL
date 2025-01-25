`timescale 1ns/1ps

// Testbench for IAS
module IAS_tb;
    reg clk, reset;             // Clock and reset signals
    wire [7:0] ac_out;          // Output of the Accumulator (AC)

    // Instantiate the IAS module
    IAS uut (
        .clk(clk),
        .reset(reset),
        .ac_out(ac_out)
    );

    // Initialize simulation
    initial begin
        $dumpfile("ias.vcd");   // File to store waveform data
        $dumpvars(0, IAS_tb);   // Dump all signals for waveform analysis

        clk = 0;                // Initialize clock
        reset = 1;              // Assert reset
        #10 reset = 0;          // Deassert reset after 10 time units

        // Preload Memory with Instructions and Data
        uut.memory_inst.mem[0] = 8'b00010001; // Load from address 1
        uut.memory_inst.mem[1] = 8'h0A;      // Data for address 1
        uut.memory_inst.mem[2] = 8'b00100010; // Store to address 2
        uut.memory_inst.mem[3] = 8'h05;      // Data for address 2
        uut.memory_inst.mem[4] = 8'b00110011; // Add data from address 3
        uut.memory_inst.mem[5] = 8'h03;      // Data for address 3

        #200;                 // Run simulation for 200 time units
        $finish;              // End simulation
    end

    // Clock generation (period = 10 time units)
    always #5 clk = ~clk;
endmodule
