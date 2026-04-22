# Seven-Segment LED Decoration System

This folder contains a small display effect project for a four-digit seven-segment setup. The design scrolls the pattern `2` and `5` with two effects: wrap mode and bounce mode, with speed control from buttons.

## Files

- `deco_top.v`: Top-level module that connects switches, buttons, the clock divider, and the scrolling FSM.
- `scroller_fsm.v`: Core control logic for the two display effects and the speed-adjust button handling.
- `clock_divider.v`: Generates a 100 Hz tick from the 100 MHz board clock.
- `display_driver.v`: Seven-segment scanning/decoder helper module for multiplexed display driving.
- `deco_tb.v`: Testbench for the top-level decoration system.
- `Arty-Z7-20-Master.xdc`: Board constraint file for the Arty Z7-20 pin mapping used by this project.
- `temp`: Small temporary/scratch file.

## Notes

- `deco_top.v` and `scroller_fsm.v` are the main files to read first.
- `display_driver.v` looks like a helper for real hardware display driving, while `deco_top.v` currently exposes digit codes directly as `DIGIT0` through `DIGIT3`.
