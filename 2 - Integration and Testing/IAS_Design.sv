`timescale 1ns/1ps

// Memory Module: Represents the 16x8 memory used to store data and instructions
module Memory(
    input wire clk,             // Clock signal to synchronize read/write operations
    input wire we,              // Write Enable (1 = write, 0 = read)
    input wire [3:0] address,   // 4-bit address (can address 16 memory locations)
    input wire [7:0] data_in,   // Data input for write operations
    output reg [7:0] data_out   // Data output for read operations
);
    reg [7:0] mem [15:0]; // Define a memory array of 16 locations, each 8 bits wide

    always @(posedge clk) begin
        if (we) begin
            // Write operation: Store 'data_in' at the given 'address'
            mem[address] <= data_in;
        end else begin
            // Read operation: Output data from the given 'address'
            data_out <= mem[address];
        end
    end
endmodule

// Register Module: Represents an 8-bit register with features like load, clear, and increment
module Register(
    input wire clk,             // Clock signal to synchronize operations
    input wire load,            // Load enable (1 = load 'data_in' into register)
    input wire clear,           // Clear enable (1 = reset the register to 0)
    input wire inc,             // Increment enable (1 = increment the register by 1)
    input wire [7:0] data_in,   // Data input for loading into the register
    output reg [7:0] data_out   // Data output (current value of the register)
);
    always @(posedge clk) begin
        if (clear) begin
            // If 'clear' is active, reset the register to 0
            data_out <= 8'b0;
        end else if (load) begin
            // If 'load' is active, update the register with 'data_in'
            data_out <= data_in;
        end else if (inc) begin
            // If 'inc' is active, increment the register value by 1
            data_out <= data_out + 1;
        end
    end
endmodule

// Integrated IAS Architecture: Implements the Instruction Fetch-Decode-Execute cycle
module IAS (
    input wire clk,               // Clock signal
    input wire reset,             // Reset signal to initialize the system
    output wire [7:0] ac_out      // Output value of the Accumulator (AC)
);
    // Memory signals
    reg [3:0] mem_address;        // 4-bit address for accessing memory
    reg [7:0] mem_data_in;        // Data to write into memory
    wire [7:0] mem_data_out;      // Data read from memory
    reg mem_we;                   // Memory write enable signal

    // Register signals
    wire [7:0] ac_data_out;       // Output of the Accumulator register (AC)
    reg ac_load, ac_clear;        // Load and clear controls for AC

    wire [7:0] pc_data_out;       // Output of the Program Counter (PC)
    reg pc_inc, pc_clear;         // Increment and clear controls for PC

    wire [7:0] ir_data_out;       // Output of the Instruction Register (IR)
    reg ir_load;                  // Load control for IR

    // Control Unit state machine signals
    reg [1:0] state;              // Current state of the Control Unit
    parameter FETCH = 2'b00,      // State 0: Fetch instruction from memory
              DECODE = 2'b01,     // State 1: Decode the instruction
              EXECUTE = 2'b10;    // State 2: Execute the instruction

    // Memory instance
    Memory memory_inst (
        .clk(clk),
        .we(mem_we),
        .address(mem_address),
        .data_in(mem_data_in),
        .data_out(mem_data_out)
    );

    // Accumulator register (AC) instance
    Register ac_inst (
        .clk(clk),
        .load(ac_load),
        .clear(ac_clear),
        .inc(1'b0),          // Accumulator does not increment
        .data_in(mem_data_out),
        .data_out(ac_data_out)
    );

    // Program Counter (PC) register instance
    Register pc_inst (
        .clk(clk),
        .load(1'b0),         // PC only increments and cannot be directly loaded
        .clear(pc_clear),
        .inc(pc_inc),
        .data_in(8'b0),
        .data_out(pc_data_out)
    );

    // Instruction Register (IR) instance
    Register ir_inst (
        .clk(clk),
        .load(ir_load),
        .clear(1'b0),        // IR cannot be cleared
        .inc(1'b0),          // IR cannot increment
        .data_in(mem_data_out),
        .data_out(ir_data_out)
    );

    // Connect Accumulator output
    assign ac_out = ac_data_out;

    // Control Unit: Implements the Fetch-Decode-Execute cycle
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, go to FETCH state and clear the PC
            state <= FETCH;
            pc_clear <= 1;
        end else begin
            pc_clear <= 0; // Release the PC clear signal
            case (state)
                FETCH: begin
                    // Fetch the instruction from memory at PC address
                    mem_address <= pc_data_out[3:0]; // Set memory address to PC
                    mem_we <= 0;                    // Read from memory
                    ir_load <= 1;                   // Load the instruction into IR
                    pc_inc <= 1;                    // Increment the PC
                    state <= DECODE;                // Move to DECODE state
                end
                DECODE: begin
                    // Decode the opcode (upper 4 bits of IR)
                    ir_load <= 0;                   // Stop loading IR
                    pc_inc <= 0;                    // Stop incrementing PC
                    case (ir_data_out[7:4])         // Decode based on opcode
                        4'b0001: begin // Load instruction
                            mem_address <= ir_data_out[3:0];
                            ac_load <= 1;           // Load data into AC
                            state <= EXECUTE;       // Move to EXECUTE state
                        end
                        4'b0010: begin // Store instruction
                            mem_address <= ir_data_out[3:0];
                            mem_data_in <= ac_data_out;
                            mem_we <= 1;            // Enable memory write
                            state <= EXECUTE;       // Move to EXECUTE state
                        end
                        default: state <= FETCH;    // Invalid opcode, restart FETCH
                    endcase
                end
                EXECUTE: begin
                    // Execute the instruction (common cleanup)
                    ac_load <= 0;                   // Stop loading AC
                    mem_we <= 0;                    // Stop writing to memory
                    state <= FETCH;                 // Return to FETCH state
                end
            endcase
        end
    end
endmodule
