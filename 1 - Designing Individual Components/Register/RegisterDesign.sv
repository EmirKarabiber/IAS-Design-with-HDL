module Register(
    input wire clk,
    input wire load,
    input wire clear,
    input wire inc,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    always @(posedge clk) begin
        if (clear) begin
            data_out <= 8'b0; // Clear
        end else if (load) begin
            data_out <= data_in; // Load
        end else if (inc) begin
            data_out <= data_out + 1; // Increment
        end
    end
endmodule
