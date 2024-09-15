`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:42:21 08/06/2022
// Design Name:
// Module Name:    ax309
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module ax309(
  input  wire       CLK_50MHZ,         // 50MHz system clock signal
  input  wire       BTN_nRESET,        // reset push button

  output wire       VGA_HSYNC,         // vga hsync signal
  output wire       VGA_VSYNC,         // vga vsync signal
  output wire [3:0] VGA_RED,           // vga red signal
  output wire [3:0] VGA_GREEN,         // vga green signal
  output wire [3:0] VGA_BLUE,          // vga blue signal

  output wire       AUDIO_L,             // pwm output audio channel
  output wire       AUDIO_R,             // pwm output audio channel
  
 // output wire [3:0] led,               // led
  input  wire [3:0] key_in,            // key_in
  
  input  wire SW_COIN,
  input  wire SW_START,
  input  wire SW_LEFT,
  input  wire SW_RIGHT,
  input  wire SW_FIRE,
  
  output wire [7:0] hex					// 7 seg display

 // inout         usb_dp,
 // inout         usb_dm
    );

// ERROR:Place:1108 - A clock IOB / BUFGMUX clock component pair have been found
//   that are not placed at an optimal clock IOB / BUFGMUX site pair. The clock
//   IOB component <BTN_nRESET> is placed at site <L3>. The corresponding BUFG
//   component <BTN_nRESET_IBUF_BUFG> is placed at site <BUFGMUX_X2Y1>. There is
//   only a select set of IOBs that can use the fast path to the Clocker buffer,
//   and they are not being used. You may want to analyze why this problem exists
//   and correct it. If this sub optimal condition is acceptable for this design,
//   you may use the CLOCK_DEDICATED_ROUTE constraint in the .ucf file to demote
//   this message to a WARNING and allow your design to continue. However, the use
//   of this override is highly discouraged as it may lead to very poor timing
//   results. It is recommended that this error condition be corrected in the
//   design. A list of all the COMP.PINs used in this clock placement rule is
// ERROR:Pack:1654 - The timing-driven placement phase encountered an error.
// wire I_RESET_SWn = !BTN_nRESET; ERROR

wire I_RESET_SWn = !BTN_nRESET & VGA_VSYNC;

// wire I_RESET_SWn = 1'b1;

wire CLK_24MHzU;
wire CLK_36MHz;
wire RESET = 1'b0;

  dcm dcm
   (// Clock in ports
    .CLK_IN1(CLK_50MHZ),      // IN 50MHz
    // Clock out ports
    .CLK_OUT1(CLK_24MHzU),    // OUT 24.000MHz
    .CLK_OUT2(CLK_36MHz),     // OUT 36.864MHz
    // Status and control signals
    .RESET(RESET),// IN
    .LOCKED());      // OUT

// JOYPAD
wire [ 7:0] joypad_cfg;
wire        joypad_cfg_upd;

// Instantiate the module
wire [7:0] usb_gamepad_data;
wire usb_gamepad_ena;
wire usb_out_gate;
wire usb_dp_o;
wire usb_dm_o;
//usb_gamepad_module usb_gamepad_module (
//    .clk24(CLK_24MHzU),
//    .rst(!BTN_nRESET),
//    .uart_rx(1'b0),
//    .uart_tx(),
//    .usb_gamepad_data(usb_gamepad_data),
//	.usb_gamepad_ena(usb_gamepad_ena),
//    .usb_out_gate(usb_out_gate),
//    .usb_dp_in(usb_dp),
//    .usb_dm_in(usb_dm),
//    .usb_dp_out(usb_dp_o),
//    .usb_dm_out(usb_dm_o)
//    );

//assign usb_dp = usb_out_gate ? usb_dp_o : 1'bz;
//assign usb_dm = usb_out_gate ? usb_dm_o : 1'bz;

//assign led = usb_gamepad_data[3:0]; // START, SELECT, B, A

// Instantiate the module
   wire [8:0] I_SW;
   wire [3:0] O_VIDEO_R;          // vga red signal
   wire [3:0] O_VIDEO_G;          // vga green signal
   wire [3:0] O_VIDEO_B;          // vga blue signal

galaxian_top u1 (
    .CLK_36M(CLK_36MHz),
    .I_SW(I_SW),
    .JOYSTICK_GND(),
	 .hex(hex),
    .I_RESET_SWn(I_RESET_SWn),
    .O_AUDIO_L(O_AUDIO_L),
    .O_AUDIO_R(O_AUDIO_R),
    .O_VIDEO_R(O_VIDEO_R),
    .O_VIDEO_G(O_VIDEO_G),
    .O_VIDEO_B(O_VIDEO_B),
    .O_HSYNC(O_HSYNC),
    .O_VSYNC(O_VSYNC)
    );


wire U1 = usb_gamepad_data[4];
wire D1 = usb_gamepad_data[5];
wire L1 = ~SW_LEFT; // usb_gamepad_data[6];
wire R1 = ~SW_RIGHT; // usb_gamepad_data[7];
wire J1 = ~SW_FIRE; // usb_gamepad_data[0];

wire S1 = ~key_in[1]; // usb_gamepad_data[3];
wire S2 = 1'b0;

wire C1 = ~key_in[0]; // usb_gamepad_data[2];
wire C2 = 1'b0;
assign I_SW = { C2, S2, C1, S1, J1, L1, R1, D1, U1 };

assign VGA_HSYNC = O_HSYNC;
assign VGA_VSYNC = O_VSYNC;
assign VGA_RED   = O_VIDEO_R;
assign VGA_GREEN = O_VIDEO_G;
assign VGA_BLUE  = O_VIDEO_B;
assign AUDIO_L = O_AUDIO_L;
assign AUDIO_R = O_AUDIO_R;

endmodule
