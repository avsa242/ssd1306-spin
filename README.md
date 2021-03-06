# ssd1306-spin
--------------

This is a P8X32A/Propeller 1, P2X8C4M64P/Propeller 2 driver object for the Solomon Systech SSD1306 OLED display controller.

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.

## Salient Features

* I2C connection at up to approx 400kHz (unenforced)
(NOTE: Datasheet specifies max I2C clock of 400kHz. May function at higher bus speeds. __YMMV!__)
* SPI connection at fixed 4MHz (P1), up to 10MHz (P2, unenforced)
(NOTE: Datasheet specifies max SPI clock of 10MHz. May function at higher bus speeds. __YMMV!__)
* Supports 128x32 and 128x64 displays
* Display mirroring (horizontal and vertical)
* Inverted display
* Variable contrast
* Low-level display control: Logic voltages, oscillator frequency, addressing mode, row/column mapping
* Supports display modules with or without discrete RESET pin
* Integration with the generic bitmap graphics library

## Requirements

P1/SPIN1:
* spin-standard-library
* P1/SPIN1: 1 extra core/cog for the PASM I2C engine
_or_
* P1/SPIN1: 1 extra core/cog for the PASM SPI engine

P2/SPIN2:
* p2-spin-standard-library

Presence of lib.gfx.bitmap library

## Compiler Compatibility

* P1/SPIN1: OpenSpin (tested with 1.00.81)
* P2/SPIN2: FlexSpin (tested with 5.0.6-beta)
* ~~BST~~ (incompatible - no preprocessor)
* ~~Propeller Tool~~ (incompatible - no preprocessor)
* ~~PNut~~ (incompatible - no preprocessor)

## Limitations

* Doesn't support parallel interface-connected displays (currently unplanned)
* Doesn't support hardware-accelerated scrolling features

## TODO

- [ ] Support hw-accelerated scrolling
- [x] Support SPI-connected displays
- [x] Support display modules that have a discrete RESET pin
