# String Bit LED Circuit

This folder contains a small LED pattern controller. The project shifts a 4-bit LED pattern left or right, supports pause/reset modes through buttons, and also sends the current LED pattern out over UART.

## Files

- `exercise3_top.v`: Top-level module that wires together the clock divider, mode FSM, LED shifter, and UART transmitter.
- `mode_fsm.v`: Button-driven mode controller for reset, shift-left, shift-right, and pause states.
- `led_shift.v`: Updates the 4-bit LED pattern according to the selected mode on each tick.
- `clock_divider.v`: Generates a slower tick from the 100 MHz board clock. The current top-level instantiation uses a 1-second interval.
- `uart_tx.v`: UART transmitter used to send the current LED pattern as an 8-bit frame.
- `temp`: Small temporary/scratch file.

## Notes

- `exercise3_top.v` is the best starting point for understanding the full project flow.
- The UART output mirrors the LED state, which makes this project useful for both board output and serial monitoring.
