# Traffic Light Control System

This folder contains a configurable traffic light controller for two directions. The design uses an FSM to cycle through green, yellow, and red phases, and lets the user adjust timing values with buttons while in set mode.

## Files

- `traffic_top.v`: Top-level module that connects switches, buttons, the clock divider, and the traffic light FSM.
- `traffic_fsm.v`: Core state machine for the traffic light sequence and timing adjustment logic.
- `clock_div.v`: 1 Hz clock divider used to create the timing tick from the 100 MHz input clock.
- `seven_segment_driver.v`: Hex-to-seven-segment decoder helper module.
- `led_mapper.v`: Simple signal pass-through module for LED mapping.
- `traffic_tb.v`: Testbench that exercises reset, normal operation, set mode, and timing updates.
- `Arty-Z7-20-Master.xdc`: Arty Z7-20 constraint file for the LEDs, buttons, switches, and display outputs used here.
- `temp`: Small temporary/scratch file.

## Notes

- `traffic_top.v` and `traffic_fsm.v` are the main implementation files.
- The top-level currently exposes `SEG_A` and `SEG_B` as 4-bit values, so `seven_segment_driver.v` is available as a helper but is not directly instantiated in `traffic_top.v`.
