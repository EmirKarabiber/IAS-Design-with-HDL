`timescale 1ns/1ps
module Memory_tb;
    reg clk;
    reg we;
    reg [3:0] address;
    reg [7:0] data_in;
    wire [7:0] data_out;

    Memory uut (
        .clk(clk),
        .we(we),
        .address(address),
        .data_in(data_in),
        .data_out(data_out)
    );

    initial begin
        $dumpfile("dump.vcd"); // Specify the VCD file name
        $dumpvars(0, Memory_tb); // Dump all variables in the module

        clk = 0;
        forever #5 clk = ~clk; // Clock generation
    end

    initial begin
        // Test write operation
        we = 1; address = 4'b0010; data_in = 8'b10101010; #10;
        we = 1; address = 4'b0001; data_in = 8'b11110000; #10;

        // Test read operation
        we = 0; address = 4'b0010; #10;
        we = 0; address = 4'b0001; #10;

        $finish;
    end
endmodule