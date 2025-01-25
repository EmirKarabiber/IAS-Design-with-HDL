# IAS Design Using Verilog

## Introduction

This project implements the **Instruction Set Architecture (IAS)** using Verilog, a hardware description language (HDL). Designed as part of the **Computer Architecture Course** at my University, this project provides a comprehensive understanding of digital logic and computer organization.

We utilized [EDA Playground](https://www.edaplayground.com/) for coding, simulating, and testing, ensuring an accessible and streamlined development process.

---

## Project Objective

The goal of this project is to design and simulate the IAS model using Verilog. This implementation focuses on key components of the IAS architecture and showcases their interaction to perform basic assembly operations.

---

## Key Components

The IAS architecture includes the following components, each implemented as modular Verilog code:

1. **Memory Module**: Stores instructions and data.
2. **Registers**:
   - **Accumulator (AC)**: For arithmetic operations.
   - **Multiplier Quotient (MQ)**: For multiplication and division.
   - **Program Counter (PC)**: Tracks the next instruction.
   - **Instruction Register (IR)**: Holds the current instruction.
3. **Control Unit**: Executes instructions by managing component interactions.

---

## Features

- Modular Verilog design for easy integration and testing.
- Simulation of basic assembly operations such as `LOAD`, `STORE`, `ADD`, and `SUB`.
- Waveform analysis for functional verification using tools like EPWave on EDA Playground.

---

## How to Run

1. Visit [EDA Playground](https://www.edaplayground.com/).
2. Copy and paste the Verilog code into the respective module files.
3. Set up a testbench for the IAS architecture.
4. Run the simulation to generate waveforms and observe the execution of instructions.

---

## Sample Test Cases

Here are some example assembly operations simulated in this project:

1. **LOAD**: Load data from memory into the Accumulator.
2. **ADD**: Add contents of the MQ register to the Accumulator.
3. **STORE**: Save the Accumulator's data into memory.

---

## Challenges and Solutions

### Challenges:
- Understanding Verilog from scratch.
- Debugging interactions between modules during integration.
- Managing the instruction cycle flow in the control unit.

### Solutions:
- Leveraged introductory Verilog resources provided in the course.
- Modularized the design for easier debugging.
- Implemented detailed test cases to validate functionality.

