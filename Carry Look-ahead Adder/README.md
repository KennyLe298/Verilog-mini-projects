# Carry Look-ahead Adder

This folder contains a small carry look-ahead adder project built in Verilog. The main design is a 32-bit adder assembled from smaller generate/propagate blocks, along with a simple demo wrapper and testbenches.

## Files

- `cla.v`: Main source file. Defines `gp1`, `gp4`, `gp8`, and the top-level `cla` 32-bit carry look-ahead adder.
- `system.v`: Small demo wrapper (`SystemDemo`) that adds a constant value to the 4 push-button input and drives the result onto LEDs.
- `cla_tb.v`: Testbench for the full 32-bit `cla` module with a few directed test cases.
- `gp4_tb.v`: Randomized testbench for the 4-bit generate/propagate helper block.
- `gp8_tb.v`: Randomized testbench for the 8-bit generate/propagate helper block.

## Notes

- `cla.v` is the core implementation file for this project.
- The testbenches are simulation-only and help verify the helper blocks separately from the full adder.
