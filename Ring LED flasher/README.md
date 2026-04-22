# Ring LED Flasher

This folder contains a small LED animation project. The design lights a 16-bit LED ring in one direction and then partially reverses, with a repeat control and a matching simulation testbench.

## Files

- `ring_flasher.v`: Main RTL module. Implements the timer and FSM that control the LED ring pattern.
- `tb_ring.v`: Testbench that exercises reset behavior, repeat control, single-shot operation, and back-to-back patterns.
- `simulation/`: Saved simulation images and temporary artifacts.
- `simulation/temp`: Small scratch file or placeholder generated during simulation work.
- `simulation/*.png`: Captured screenshots/images of simulation results.

## Notes

- `ring_flasher.v` is the main design file.
- The `simulation` folder appears to be for waveform screenshots and visual reference rather than source code.
