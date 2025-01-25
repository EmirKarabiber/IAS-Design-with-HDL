`timescale 1ns/1ps
module Register_tb;
    reg clk;
    reg load, clear, inc;
    reg [7:0] data_in;
    wire [7:0] data_out;

    Register uut (
        .clk(clk),
        .load(load),
        .clear(clear),
        .inc(inc),
        .data_in(data_in),
        .data_out(data_out)
    );

    initial begin
        $dumpfile("dump.vcd");       // Specify the VCD file name
        $dumpvars(0, Register_tb);  // Dump all variables in the module
        
        clk = 0;
        forever #5 clk = ~clk;      // Clock generation
    end

    initial begin
        // Test register operations
        load = 1; clear = 0; inc = 0; data_in = 8'b01010101; #10;
        load = 0; inc = 1; #10;
        inc = 0; clear = 1; #10;

        $finish; // End simulation
    end
endmodule