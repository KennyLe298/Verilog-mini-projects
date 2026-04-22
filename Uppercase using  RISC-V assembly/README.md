# Uppercase Using RISC-V Assembly

This folder contains a small RISC-V assembly exercise rather than a Verilog design. The program walks through a string in memory and converts lowercase ASCII letters to uppercase in place.

## Files

- `uppercase.S`: Assembly source that loads `input_string`, checks each byte, and subtracts 32 from lowercase letters (`a` to `z`) to convert them to uppercase.

## Notes

- The program ends in an infinite loop after processing the string.
- `tohost` and `fromhost` are included as data locations commonly used with Spike-based workflows.
