module ControlUnit(
    input wire clk,
    input wire reset,
    output reg [1:0] state
);
    parameter FETCH = 2'b00, DECODE = 2'b01, EXECUTE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= FETCH;
        end else begin
            case (state)
                FETCH: state <= DECODE;
                DECODE: state <= EXECUTE;
                EXECUTE: state <= FETCH;
                default: state <= FETCH;
            endcase
        end
    end
endmodule
