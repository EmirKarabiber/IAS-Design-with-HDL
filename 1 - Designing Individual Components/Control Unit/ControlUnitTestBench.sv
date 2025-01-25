`timescale 1ns/1ps
module ControlUnit_tb;
    reg clk, reset;
    wire [1:0] state;

    ControlUnit uut (
        .clk(clk),
        .reset(reset),
        .state(state)
    );

    initial begin
        $dumpfile("dump.vcd");       // Specify the VCD file name
        $dumpvars(0, ControlUnit_tb); // Dump all variables in the module

        clk = 0;
        forever #5 clk = ~clk;      // Clock generation
    end

    initial begin
        reset = 1; #10;            // Assert reset
        reset = 0; #50;            // Deassert reset and observe states

        $finish;                   // End simulation
    end
endmodule