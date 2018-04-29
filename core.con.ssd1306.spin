{
    --------------------------------------------
    Filename: core.con.ssd1306.spin
    Author: Jesse Burt
    Description: SSD1306 OLED/PLED Display driver registers/command set
    Copyright (c) 2018
    See end of file for terms of use.
    --------------------------------------------
}

CON

  DATABIT               = %01_000000      'OR your data byte with one of these two to tell the US2066 whether the following byte is a data byte
  CMDBIT                = %00_000000      ' or a command byte
'  CONTBIT               = %10_000000      'Continuation bit

  CTRLBYTE_CMD            = $00
  CTRLBYTE_DATA           = $40

'FUNDAMENTAL COMMAND SET
  SSD1306_CMD_CONTRAST    = $81 'Double byte command - send 8-bit contrast value after this command
  SSD1306_CMD_RAMDISP_ON  = $A4
  SSD1306_CMD_ENTDISP_ON  = $A5
  SSD1306_CMD_DISP_NORM   = $A6
  SSD1306_CMD_DISP_INVERT = $A7  
  SSD1306_CMD_DISP_OFF    = $AE
  SSD1306_CMD_DISP_ON     = $AF

'SCROLLING COMMAND TABLE
  SSD1306_CMD_HSCROLL_R   = $26 '\
  SSD1306_CMD_HSCROLL_L   = $27 '- 7 byte command - send $00 dummy byte, Page start, Time interval, Page end, $00, $FF dummy bytes after this command
  SSD1306_CMD_VSCROLL_R   = $29 '\
  SSD1306_CMD_VSCROLL_L   = $2A '- 6 byte command - send $00 dummy byte, Page start, Time interval, Page end, Vert. scroll offset
  SSD1306_CMD_STOPSCROLL  = $2E ' Stop any of the above
  SSD1306_CMD_STARTSCROLL = $2F ' Stop any of the above
  SSD1306_CMD_VSCROLL_AREA= $A3 '- 3 byte command - send no. of rows in top fixed area (bits 5..0), no. of rows in scroll area after this command (bits 6..0)

'ADDRESSING SETTING COMMAND TABLE
  SSD1306_CMD_MEM_ADDRMODE= $20 '- 2 byte command - send addressing mode after this byte
  SSD1306_CMD_SET_COLADDR = $21 '- 3 byte command - send column start address, column end address after this byte
  SSD1306_CMD_SET_PAGEADDR= $22 '- 3 byte command - send page start address, page end address after this byte

'HARDWARE CONFIGURATION
  SSD1306_CMD_SEG_MAP0    = $A0 ' Column address 0 is mapped to SEG0
  SSD1306_CMD_SEG_MAP127  = $A1 ' Column address 127 is mapped to SEG0
  SSD1306_CMD_SETMUXRATIO = $A8  
  SSD1306_CMD_COMDIR_NORM = $C0
  SSD1306_CMD_COMDIR_RMAP = $C8
  SSD1306_CMD_SETCOM_CFG  = $DA

  SSD1306_CMD_SETDISPOFFS = $D3
  SSD1306_CMD_SETOSCFREQ  = $D5
  SSD1306_CMD_CHARGEPUMP  = $8D


'US2066
'Command set: (POR) indicates Power On Reset, or default value.
'-FUNDAMENTAL COMMAND SET-------
  'SD bit set 0
  CLEAR_DISPLAY     = %0000_0001      '$01 Clear Display
  'RE bit set 0, SD bit set 0
  HOME_DISPLAY      = %0000_0010      '$02 Return Home (set DDRAM address to $00 and return cursor to its original position if shifted. The contents of DDRAM are not changed.
' OR ( | ) bitmasks below together in a command, to set individual flags
' Example:
' command(ENTRY_MODE_SET | LTR | NOSHIFT)
  'RE bit set 0, SD bit set 0
  ENTRY_MODE_SET    = %0000_0100      '$04 Entry Mode Set
   LTR              =        %1 << 1  '(POR) Cursor/blink moves to right and DDRAM addr is inc by 1
   RTL              =        %0 << 1  ' Cursor/blink moves to left and DDRAM addr is dec by 1
   SHIFT            =         %1      ' Make display shift of the enabled lines by the DS4 to DS1 bits in the shift enable instruction. Left/right direction depends on I/D bit selection
   NOSHIFT          =         %0      '(POR) Display shift disable

  'RE bit set 1, SD bit set 0
   COM31_0          =        %0 << 1  '$04 Common bi-direction function COM31 > COM0
   COM0_31          =        %1 << 1  'COM0 > COM31
   SEG99_0          =         %0      'Segment bi-direction function SEG99 > SEG0
   SEG0_99          =         %1      'SEG0 > SEG99

  'RE bit set 0, SD bit set 0
  DISPLAY_ONOFF     = %0000_1000      '$08 Display ON/OFF, Cursor ON/OFF, Cursor Blink ON/OFF control
    DISP_ON         =       %1  << 2  'Display ON
    DISP_OFF        =       %0  << 2  '(POR) Display OFF
    CURSOR_ON       =        %1 << 1  'Cursor ON
    CURSOR_OFF      =        %0 << 1  '(POR) Cursor OFF
    BLINK_ON        =         %1      'Blink ON
    BLINK_OFF       =         %0      '(POR) Blink OFF

  'RE bit set 1, SD bit set 0
  EXTENDED_FUNCSET  = %0000_1000      'Assign font width, black/white inverting of cursor, and 4-line display mode control bit
    FONTWIDTH_6     =       %1  << 2  '6-dot font width
    FONTWIDTH_5     =       %0  << 2  '(POR) 5-dot font width
    CURSOR_INVERT   =        %1 << 1  'Black/white inverting of cursor enabled
    CURSOR_NORMAL   =        %0 << 1  '(POR) Black/white inverting of cursor disabled
    NW_3_4_LINE     =         %1      '3 line or 4 line display mode
    NW_1_2_LINE     =         %0      '1 line or 2 line display mode

  'IS bit set 0, RE bit set 0, SD bit set 0
  CURS_DISP_SHIFT   = %0001_0000      '$10 Set cursor moving and display shift control and direction (doesn't change DDRAM data)
    CURS_LEFT       =      %00  << 2
    CURS_RIGHT      =      %01  << 2
    DISP_LEFT       =      %10  << 2
    DISP_RIGHT      =      %11  << 2

  'IS bit set 0, RE bit set 1, SD bit set 0
  DBLHEIGHT         = %0001_0000      '$10 Double-height font setting (POR=%xxxx_11xx)
    DBLHEIGHT_BOTTOM=      %00  << 2  'Top two rows standard-height, Bottom row double height
    DBLHEIGHT_MIDDLE=      %01  << 2  'Top row standard-height, middle row double-height, bottom row standard-height
    DBLHEIGHT_BOTH  =      %10  << 2  'Two double-height rows
    DBLHEIGHT_TOP   =      %11  << 2  'TOP row double height, bottom two rows standard-height
    DISP_SHIFT_EN   =         %1      'Display shift enable
    DOT_SCROLL_EN   =         %0      '(POR) Dot scroll enable

  'IS bit set 1, RE bit set 1, SD bit set 0
  SHIFT_SCROLL_ENA  = %0001_0000      '$10 Set line(s) with display shift enabled (%1111 (POR). Shift when DH = 1, Scroll when DH = 0 (DISP_SHIFT_EN, DOT_SCROLL_EN)
    SHFT_SCRL_LINE1 =         %1      '1st line display shift/scroll enable
    SHFT_SCRL_LINE2 =        %1 << 1  '2nd line display shift/scroll enable
    SHFT_SCRL_LINE3 =       %1  << 2  '3rd line display shift/scroll enable
    SHFT_SCRL_LINE4 =      %1   << 3  '4th line display shift/scroll enable

  'RE bit set 0, SD bit set 0  
  FUNCTION_SET_0    = %0010_0000      ' $20 Function set 0      XXX - This section candidate for cleanup
    DISP_LINES_2_4  =      %1   << 3  ' 2-line (NW=%0) or 4 line (NW=%1)
    DISP_LINES_1_3  =      %0   << 3  ' 1-line (NW=%0) or 3 line (NW=%1)
    DBLHT_FONT_EN   =       %1  << 2  ' Double height font control for 2-line mode
    DBLHT_FONT_DIS  =       %0  << 2  ' (POR) Double height font control for 2-line mode
    EXT_REG_RE      =        %1 << 1  ' Extension register RE (POR 0)
    EXT_REG_IS      =         %1      ' Extension register IS

  CMDSET_EXTENDED   = FUNCTION_SET_0 | EXT_REG_RE
  CMDSET_FUNDAMENTAL= FUNCTION_SET_0

  'RE bit set 1, SD bit set 0  
  FUNCTION_SET_1    = %0010_0010      ' $22 Function set 1 (RE register 1)    XXX - This section candidate for cleanup
    CGRAM_BLINK_EN  =       %1  << 2  ' CGRAM blink enable
    CGRAM_BLINK_DIS =       %0  << 2  ' (POR) CGRAM blink disable
    REVERSE_DISPLAY =         %1      ' Reverse display
    NORMAL_DISPLAY  =         %0      ' (POR) Normal display

  SET_CGRAM_ADDR    = %0100_0000      ' $40 Set CGRAM address in address counter (POR=%00_0000)
  SET_DDRAM_ADDR    = %1000_0000      ' $80 Set DDRAM address in address counter (POR=%000_0000)
  SET_SCROLL_QTY    = %1000_0000      ' $80 (with RE bit set) Set the quantity of horizontal dot scroll (POR=%00_0000 - Maximum: %11_0000)

'-EXTENDED COMMAND SET---
''To use, first set RE to 1
''These are two-byte commands.
''First send the command, then a data byte appropriate to your application, as prescribed by the comment next to the command.
''Example:
''  command (FUNCTION_SEL_A)
''  data ($00)

  FUNCTION_SEL_A    = %0111_0001      ' $71 Enable/Disable internal 5V regulator
' $00 - Disable internal regulator (Low-voltage I/O mode). $5C(POR) - Enable internal regulator (5V I/O mode)
    INT_REG_DISABLE = $00
    INT_REG_ENABLE  = $5C
  FUNCTION_SEL_B    = %0111_0010      ' $72 %xxxx_ROM1_ROM0_OPR1_OPR0
    CHAR_ROM_A      =      %00  << 2
    CHAR_ROM_B      =      %01  << 2
    CHAR_ROM_C      =      %10  << 2
    CG_ROM_RAM_240_8=        %00
    CG_ROM_RAM_248_8=        %01
    CG_ROM_RAM_250_6=        %10
    CG_ROM_RAM_256_0=        %11
' OPR: Select the character no. of character generator.  ROM: Select character ROM
'       CGROM   CGRAM                                       ROM
'   %00 240     8                                       %00 A
'   %01 248     8                                       %01 B
'   %10 250     6                                       %10 C
'   %11 256     0                                       %11 Invalid


'-OLED COMMAND SET-----
  OLED_CHARACTERIZE = %0111_1000      ' OLED Characterization
    OLED_CMDSET_ENA =         %1      ' $79 %0111_100_1   SD = %1: OLED Command set enabled
    OLED_CMDSET_DIS =         %0      ' $78 %0111_100_0   SD = %0: (POR) OLED Command set enabled
''These are two-byte commands.
''First send the command, then a second command byte appropriate to your application, as prescribed by the comment next to the command.
''Example:
''  command (SET_CONTRAST)
''  command ($7F)
  SET_CONTRAST      = %1000_0001      ' $81 Select contrast. %0000_0000 .. %1111_1111 (POR %0111_1111)
  DISP_CLKDIV_OSC   = %1101_0101      ' $D5 Oscillator freq (4 MSBs, POR=%0111). Display clock divisor (4 LSBs, POR=%0000, divisor=value+1). Range for both is %0000-%1111
  SET_PHASE_LEN     = %1101_1001      ' $D9 Segment waveform length (unit=DCLKs). Phase 2 (MSBs, POR=%0111) range %0001..%1111, Phase 1 (LSBs, POR=%1000) range %0010..%1111
' NOTE: Phase 1 period up to 32 DCLK. Clock 0 is a valid entry with 2 DCLK
' NOTE: Phase 2 period up to 15 DCLK. Clock 0 is invalid

  SET_SEG_PINS      = %1101_1010      ' $DA Set SEG pins hardware configuration
    SEG_LR_REMAP_EN = %1      <<5
    SEG_LR_REMAP_DIS= %0      <<5
    SEQ_SEGPINCFG   =  %1     <<4
    ALT_SEGPINCFG   =  %0     <<4 
' Bit 5: %0(POR) Disable SEG L/R Remap %1: Enable L/R Remap
' Bit 4: %0 Sequential SEG pin cfg     %1(POR) Alternating (odd/even) SEG pin cfg

  SET_VCOMH_DESEL   = %1101_1011      ' $DB Adjust Vcomh regulator output
' Bits 6..4 (Hex)   Vcomh 4deselect level
' %000      $00     ~0.65 * Vcc
' %001      $10     ~0.71 * Vcc
' %010      $20     ~0.77 * Vcc (POR)
' %011      $30     ~0.83 * Vcc
' %100      $40     ~1.00 * Vcc

  FUNCTION_SEL_C    = %1101_1100      ' $DC Set VSL/GPIO
    VSL_INTERNAL    = %0        << 7
    VSL_EXTERNAL    = %1        << 7
    GPIO_HIZ_INP_DIS=        %00
    GPIO_HIZ_INP_ENA=        %01
    GPIO_OUT_LOW    =        %10
    GPIO_OUT_HIGH   =        %11
' Bit 7: %0: (POR) Internal VSL %1: Enable external VSL
' Bits 1..0 Condition
' %00       GPIO pin HiZ, input disabled (always read as low)
' %01       GPIO pin HiZ, input enabled
' %10       GPIO pin output low (RESET)
' %11       GPIO pin output high

  FADEOUT_BLINK     = %0010_0011      '$23 Set fade out and blinking.
    FADE_BLINK_DIS  =   %00     << 4
    FADE_OUT_ENA    =   %10     << 4
    BLINK_ENA       =   %11     << 4
' Bits 5..4: %00: Disable Fade Out/Blinking (RESET)
'            %10: Enable Fade Out. Once fade mode is enabled, contrast decreases gradually until all pixels OFF. Output follows RAM content when fade mode disabled.
' Bits 3..0: Time interval for each fade step
'            %0000: 8 Frames .. %1111: 128 Frames

PUB null
''This is not a top-level object

DAT
{
    --------------------------------------------------------------------------------------------------------
    TERMS OF USE: MIT License

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
    associated documentation files (the "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
    following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial
    portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
    LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    --------------------------------------------------------------------------------------------------------
}
