----------------------------------------------------------------------------------
-- Company:  RAT Technologies (a subdivision of Cal Poly CENG)
-- Engineer:  Various RAT rats
--
-- Create Date:    02/03/2017
-- Module Name:    RAT_wrapper - Behavioral
-- Target Devices:  Basys3
-- Description: Wrapper for RAT CPU. This model provides a template to interfaces
--    the RAT CPU to the Basys3 development board.
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAT_wrapper is
    Port ( Segments : out   STD_LOGIC_VECTOR (6 downto 0); -- 7 seg display segments
           Digits   : out   STD_LOGIC_VECTOR (3 downto 0); -- 7 seg display digits
           LEDS     : out   STD_LOGIC_VECTOR (7 downto 0); -- LED 0-7
           SWITCHES : in    STD_LOGIC_VECTOR (7 downto 0); -- Switch 0-7
           RST      : in    STD_LOGIC; -- reset button (bottom button)
           INT      : in    STD_LOGIC; -- INT button (left button)
           CLK      : in    STD_LOGIC; -- hardware clock
           
           -- PS/2 signals
           ps2d, ps2c: inout  std_logic;
           
           -- VGA output signals
           VGA_RGB  : out std_logic_vector(7 downto 0);
           R_OUT      : out STD_LOGIC_VECTOR (3 downto 0);
           G_OUT      : out STD_LOGIC_VECTOR (3 downto 0);
           B_OUT      : out STD_LOGIC_VECTOR (3 downto 0);
           VGA_HS   : out std_logic;
           VGA_VS   : out std_logic);         
end RAT_wrapper;

architecture Behavioral of RAT_wrapper is

   -- INPUT PORT IDS -------------------------------------------------------------
   -- Right now, the only possible inputs are the switches
   -- In future labs you can add more port IDs, and you'll have
   -- to add constants here for the mux below
   CONSTANT SWITCHES_ID : STD_LOGIC_VECTOR (7 downto 0) := X"20";
   CONSTANT VGA_READ_ID : STD_LOGIC_VECTOR(7 downto 0) := x"93";
   CONSTANT PS2_KEY_CODE_ID  : STD_LOGIC_VECTOR (7 downto 0) := X"44";
   CONSTANT PS2_STATUS_ID    : STD_LOGIC_VECTOR (7 downto 0) := X"45";
   -------------------------------------------------------------------------------
   
   -------------------------------------------------------------------------------
   -- OUTPUT PORT IDS ------------------------------------------------------------
   -- In future labs you can add more port IDs
   CONSTANT LEDS_ID       : STD_LOGIC_VECTOR (7 downto 0) := X"40";
   CONSTANT SEVENSEGMENT_ID : STD_LOGIC_VECTOR (7 downto 0) := X"81";
   
   CONSTANT VGA_HADDR_ID : STD_LOGIC_VECTOR(7 downto 0) := x"90";
   CONSTANT VGA_LADDR_ID : STD_LOGIC_VECTOR(7 downto 0) := x"91";
   CONSTANT VGA_WRITE_ID : STD_LOGIC_VECTOR(7 downto 0) := x"92";
   CONSTANT PS2_CONTROL_ID   : STD_LOGIC_VECTOR (7 downto 0) := X"46";
   -------------------------------------------------------------------------------

   -- Declare RAT_CPU ------------------------------------------------------------
   component RAT_MCU
       Port ( IN_PORT  : in  STD_LOGIC_VECTOR (7 downto 0);
              OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
              PORT_ID  : out STD_LOGIC_VECTOR (7 downto 0);
              IO_STRB  : out STD_LOGIC;
              RESET    : in  STD_LOGIC;
              INT      : in  STD_LOGIC;
              CLK      : in  STD_LOGIC);
   end component RAT_MCU;
   --------------------------------------------------------------------------------
   
   -- Declare 7 Segment Decoder ---------------------------------------------------
   component Four_Digit_Display 
        Port ( CurrentInput : in STD_LOGIC_VECTOR (7 downto 0);
               Clk : in STD_LOGIC;
               Segments : out STD_LOGIC_VECTOR (6 downto 0);
               Digits : out STD_LOGIC_VECTOR (3 downto 0));
   end component;
   
   -- Declare PS2 Register --------------------------------------------------------
   component PS2_REGISTER is
      PORT (
         PS2_DATA_READY,
         PS2_ERROR            : out STD_LOGIC;  
         PS2_KEY_CODE         : out STD_LOGIC_VECTOR(7 downto 0);  
         PS2_CLK              : inout STD_LOGIC;  
         PS2_DATA             : in STD_LOGIC;
         PS2_CLEAR_DATA_READY : in STD_LOGIC);
   end component;   
   --------------------------------------------------------------------------------
   
   -- Declare VGA components ------------------------------------------------------
   component vgaDriverBuffer is
      Port (CLK, we : in std_logic;
            wa   : in std_logic_vector (10 downto 0);
            wd   : in std_logic_vector (7 downto 0);
            Rout : out std_logic_vector(2 downto 0);
            Gout : out std_logic_vector(2 downto 0);
            Bout : out std_logic_vector(1 downto 0);
            HS   : out std_logic;
            VS   : out std_logic;
            pixelData : out std_logic_vector(7 downto 0));
   end component;
   --------------------------------------------------------------------------------
      
   -- Signals for connecting RAT_CPU to RAT_wrapper -------------------------------
   signal s_input_port  : std_logic_vector (7 downto 0);
   signal s_output_port : std_logic_vector (7 downto 0);
   signal s_port_id     : std_logic_vector (7 downto 0);
   signal s_load        : std_logic;
   signal s_clk_sig     : std_logic := '0';
   --signal s_interrupt   : std_logic; -- not yet used
   
   -- VGA signals
   signal r_vga_we   : std_logic;                       -- Write enable
   signal r_vga_wa   : std_logic_vector(10 downto 0);   -- The address to read from / write to  
   signal r_vga_wd   : std_logic_vector(7 downto 0);    -- The pixel data to write to the framebuffer
   signal r_vgaData  : std_logic_vector(7 downto 0);    -- The pixel data read from the framebuffer


   -- Keyboard signals
   signal kbd_data : std_logic_vector(7 downto 0);
   signal ps2KeyCode, ps2Status, ps2ControlReg       : std_logic_vector (7 downto 0);
   
   -- Register definitions for output devices ------------------------------------
   -- add signals for any added outputs
   signal r_LEDS        : std_logic_vector (7 downto 0);
   signal r_SEVENSEGMENT : std_logic_vector (7 downto 0);
   -------------------------------------------------------------------------------

begin
 
   -- Clock Divider Process ------------------------------------------------------
    clkdiv: process(CLK)
    begin
        if RISING_EDGE(CLK) then

        s_clk_sig <= NOT s_clk_sig;

        end if;
    end process clkdiv;
   -------------------------------------------------------------------------------
   
   
   -- Instantiate RAT_CPU --------------------------------------------------------
   CPU: RAT_MCU
   port map(  IN_PORT  => s_input_port,
              OUT_PORT => s_output_port,
              PORT_ID  => s_port_id,
              RESET    => RST,
              IO_STRB  => s_load,
              INT      => INT,  -- s_interrupt
              CLK      => s_clk_sig);
   -------------------------------------------------------------------------------
   
   -- Instantiate 7 Segment Decoder ----------------------------------------------
   DISPLAY : Four_Digit_Display
   port map( CLK => CLK,
             CurrentInput => r_SEVENSEGMENT,
             Segments => SEGMENTS,
             Digits => DIGITS);
   -------------------------------------------------------------------------------
   
   -- Instantiate VGA ------------------------------------------------------------
   VGA: vgaDriverBuffer
      port map(CLK => CLK,
               WE => r_vga_we,
               WA => r_vga_wa,
               WD => r_vga_wd,
               Rout => R_OUT(3 downto 1),
               Gout => G_OUT(3 downto 1),
               Bout => B_OUT(3 downto 2),
               HS => VGA_HS,
               VS => VGA_VS,
               pixelData => r_vgaData);
    ------------------------------------------------------------------------------                 
    -- Instatiate PS/2 Driver
    PS2_DRIVER : PS2_REGISTER
        port map(PS2_DATA             => PS2D,
             PS2_CLK              => ps2c,
             PS2_CLEAR_DATA_READY => ps2ControlReg(0),
             PS2_KEY_CODE         => ps2KeyCode,
                PS2_DATA_READY       => ps2Status(1),
                PS2_ERROR            => ps2Status(0));
   -------------------------------------------------------------------------------
   
   
   -- MUX for selecting what input to read ---------------------------------------
   -- add conditions and connections for any added PORT IDs
   -------------------------------------------------------------------------------
   inputs: process(clk, s_port_id, SWITCHES, r_vgaData, ps2KeyCode, ps2Status)
   begin
      if (s_port_id = SWITCHES_ID) then
         s_input_port <= SWITCHES;
      elsif (s_port_id = VGA_READ_ID) then
         s_input_port <= r_vgaData;
      elsif (s_port_id = PS2_KEY_CODE_ID) then
         s_input_port <= ps2KeyCode;
      elsif (s_port_id = PS2_STATUS_ID) then
         s_input_port <= ps2Status;             
      else
         s_input_port <= x"00";
      end if;
   end process inputs;
   -------------------------------------------------------------------------------


   -------------------------------------------------------------------------------
   -- MUX for updating output registers ------------------------------------------
   -- Register updates depend on rising clock edge and asserted load signal
   -- add conditions and connections for any added PORT IDs
   -------------------------------------------------------------------------------
   outputs: process(CLK)
   begin
   
   -- DRIVE BOTTOM BITS OF BASYS3 VGA
   R_OUT(0) <= '0';
   G_OUT(0) <= '0';
   B_OUT(1) <= '0';
   B_OUT(0) <= '0';
   
      if (rising_edge(CLK)) then
         if (s_load = '1') then
           
            -- the register definition for the LEDS
            if (s_port_id = LEDS_ID) then
               r_LEDS <= s_output_port;
            elsif (s_port_id = SEVENSEGMENT_ID) then
               r_SEVENSEGMENT <= s_output_port;
			-- PS2 Driver support ------------------------------------
            elsif (s_port_id = PS2_CONTROL_ID)  then
               ps2ControlReg  <= s_output_port;    

                       
            -- VGA support -------------------------------------------
            elsif (s_port_id = VGA_HADDR_ID) then
               r_vga_wa(10 downto 6) <= s_output_port(4 downto 0);
            elsif (s_port_id = VGA_LADDR_ID) then
               r_vga_wa(5 downto 0) <= s_output_port(5 downto 0);
            elsif (s_port_id = VGA_WRITE_ID) then
               r_vga_wd <= s_output_port;
            end if;              
            
            if( s_port_id = VGA_WRITE_ID ) then
               r_vga_we <= '1';
            else
               r_vga_we <= '0';
            end if;            
           
         end if;
      end if;
   end process outputs;
   -------------------------------------------------------------------------------

   -- Register Interface Assignments ---------------------------------------------
   -- add all outputs that you added to this design
   LEDS <= r_LEDS;
  
end Behavioral;
