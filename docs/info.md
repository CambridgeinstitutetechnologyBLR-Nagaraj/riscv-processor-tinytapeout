<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The design implements a 32-bit pipelined RISC-V processor using Verilog and SKY130 technology.
The processor operates through the following stages:
Instruction Fetch (IF): Fetches instructions from instruction memory.
Instruction Decode (ID): Decodes instructions and reads register values.
Execute (EX): Performs arithmetic and logical operations using the ALU.
Memory Access (MEM): Reads or writes data memory when required.
Write Back (WB): Writes the execution or memory result back into the register file.
The Tiny Tapeout interface uses GPIO signals to provide access to selected processor debug outputs, including the program counter and writeback data.

## How to test

Apply the clock signal to run the processor.
Apply the reset signal to initialize the processor.
Enable the design using the ena input.
Run the provided Verilog testbench.
Observe the program counter through the output GPIO pins.
Observe the writeback data through the bidirectional GPIO pins.
Verify the processor operation using simulation waveforms.

## External hardware

List external hardware used in your project (e.g. PMOD, LED display, etc), if any
