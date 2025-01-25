module Memory(
    input wire clk,
    input wire we,              // Write Enable
    input wire [3:0] address,   // 4-bit address for 16 locations
    input wire [7:0] data_in,   // 8-bit data input
    output reg [7:0] data_out   // 8-bit data output
);
    reg [7:0] mem [15:0];       // 16x8 memory array

    always @(posedge clk) begin
        if (we) begin
            mem[address] <= data_in;  // Write data
        end else begin
            data_out <= mem[address]; // Read data
        end
    end
endmodule

