#Clock
set_property PACKAGE_PIN W5 [get_ports {CLK}]
set_property IOSTANDARD LVCMOS33 [get_ports {CLK}]
create_clock -add -name sys_clk_pin -period 10.0 -waveform {0 5} [get_ports {CLK}]

#Reset button
set_property PACKAGE_PIN U17 [get_ports {RST}]
set_property IOSTANDARD LVCMOS33 [get_ports {RST}]

#Interrupt button
set_property PACKAGE_PIN W19 [get_ports {INT}]
set_property IOSTANDARD LVCMOS33 [get_ports {INT}]

#Switches
set_property PACKAGE_PIN V17 [get_ports {SWITCHES[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[0]}]

set_property PACKAGE_PIN V16 [get_ports {SWITCHES[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[1]}]

set_property PACKAGE_PIN W16 [get_ports {SWITCHES[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[2]}]

set_property PACKAGE_PIN W17 [get_ports {SWITCHES[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[3]}]

set_property PACKAGE_PIN W15 [get_ports {SWITCHES[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[4]}]

set_property PACKAGE_PIN V15 [get_ports {SWITCHES[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[5]}]

set_property PACKAGE_PIN W14 [get_ports {SWITCHES[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[6]}]

set_property PACKAGE_PIN W13 [get_ports {SWITCHES[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[7]}]


#LEDs
set_property PACKAGE_PIN U16 [get_ports {LEDS[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[0]}]

set_property PACKAGE_PIN E19 [get_ports {LEDS[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[1]}]

set_property PACKAGE_PIN U19 [get_ports {LEDS[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[2]}]

set_property PACKAGE_PIN V19 [get_ports {LEDS[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[3]}]

set_property PACKAGE_PIN W18 [get_ports {LEDS[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[4]}]

set_property PACKAGE_PIN U15 [get_ports {LEDS[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[5]}]

set_property PACKAGE_PIN U14 [get_ports {LEDS[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[6]}]

set_property PACKAGE_PIN V14 [get_ports {LEDS[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[7]}]

#Digits
set_property PACKAGE_PIN W4 [get_ports {Digits[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Digits[3]}]

set_property PACKAGE_PIN V4 [get_ports {Digits[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Digits[2]}]

set_property PACKAGE_PIN U4 [get_ports {Digits[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Digits[1]}]

set_property PACKAGE_PIN U2 [get_ports {Digits[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Digits[0]}]

#7 SEGMENT
#Segments
set_property PACKAGE_PIN W7 [get_ports {Segments[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Segments[6]}]

set_property PACKAGE_PIN W6 [get_ports {Segments[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Segments[5]}]

set_property PACKAGE_PIN U8 [get_ports {Segments[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Segments[4]}]

set_property PACKAGE_PIN V8 [get_ports {Segments[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Segments[3]}]

set_property PACKAGE_PIN U5 [get_ports {Segments[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Segments[2]}]

set_property PACKAGE_PIN V5 [get_ports {Segments[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Segments[1]}]

set_property PACKAGE_PIN U7 [get_ports {Segments[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Segments[0]}]


##USB HID (PS/2)
set_property PACKAGE_PIN C17 [get_ports ps2c]						
	set_property IOSTANDARD LVCMOS33 [get_ports ps2c]
	set_property PULLUP true [get_ports ps2c]
set_property PACKAGE_PIN B17 [get_ports ps2d]					
	set_property IOSTANDARD LVCMOS33 [get_ports ps2d]	
	set_property PULLUP true [get_ports ps2d]

#VGA OUTPUTS
#############################################################
##VGA Connector
## RED
set_property PACKAGE_PIN G19 [get_ports {R_OUT[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {R_OUT[0]}]
set_property PACKAGE_PIN H19 [get_ports {R_OUT[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {R_OUT[1]}]
set_property PACKAGE_PIN J19 [get_ports {R_OUT[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {R_OUT[2]}]
set_property PACKAGE_PIN N19 [get_ports {R_OUT[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {R_OUT[3]}]
	
## BLUE	
set_property PACKAGE_PIN N18 [get_ports {B_OUT[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {B_OUT[0]}]       
set_property PACKAGE_PIN L18 [get_ports {B_OUT[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {B_OUT[1]}]
set_property PACKAGE_PIN K18 [get_ports {B_OUT[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {B_OUT[2]}]
set_property PACKAGE_PIN J18 [get_ports {B_OUT[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {B_OUT[3]}]
	
## GREEN
set_property PACKAGE_PIN J17 [get_ports {G_OUT[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {G_OUT[0]}]       
set_property PACKAGE_PIN H17 [get_ports {G_OUT[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {G_OUT[1]}]
set_property PACKAGE_PIN G17 [get_ports {G_OUT[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {G_OUT[2]}]
set_property PACKAGE_PIN D17 [get_ports {G_OUT[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {G_OUT[3]}]
	
## HORIZONTAL AND VERTICAL SYNC	
set_property PACKAGE_PIN P19 [get_ports VGA_HS]						
	set_property IOSTANDARD LVCMOS33 [get_ports VGA_HS]
set_property PACKAGE_PIN R19 [get_ports VGA_VS]						
	set_property IOSTANDARD LVCMOS33 [get_ports VGA_VS]


