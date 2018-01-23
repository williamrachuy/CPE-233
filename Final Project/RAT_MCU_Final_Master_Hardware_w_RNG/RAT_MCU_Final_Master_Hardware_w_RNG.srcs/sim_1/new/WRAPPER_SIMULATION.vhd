----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/10/2017 07:12:44 PM
-- Design Name: 
-- Module Name: RAT_Wrapper_sim1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAT_Wrapper_sim1 is
--  Port ( );
end RAT_Wrapper_sim1;

architecture Behavioral of RAT_Wrapper_sim1 is

    component RAT_Wrapper
        Port ( Segments : out   STD_LOGIC_VECTOR (6 downto 0); -- 7 seg display segments
               Digits   : out   STD_LOGIC_VECTOR (3 downto 0); -- 7 seg display digits
               LEDS     : out   STD_LOGIC_VECTOR (7 downto 0);
               SWITCHES : in    STD_LOGIC_VECTOR (7 downto 0);
               RST      : in    STD_LOGIC;
               INT      : in    STD_LOGIC;
               CLK      : in    STD_LOGIC);
    end component;
    
    signal LEDS, SWITCHES : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    signal RST, CLK, INT : STD_LOGIC := '0';
    signal Segments : STD_LOGIC_VECTOR (6 downto 0);
    signal Digits : STD_LOGIC_VECTOR (3 downto 0);
    
begin
    
    UUT : RAT_Wrapper
        port map( LEDS => LEDS,
             SWITCHES => SWITCHES,
             RST => RST,
             CLK => CLK,
             INT => INT, 
             Segments => Segments,
             Digits => Digits);
             
     process is            
     begin
         CLK <= not CLK;
         wait for 10 ns;
     end process;

    process is
    begin
        SWITCHES <= "00000000";
        RST <= '0';
        wait for 300 ns;

        INT <= '1';
        
        wait for 300 ns;
        
        INT <= '0';
        
        wait for 300 ns;
        
        INT <= '1';
        
        wait for 2000 ns; 
        
        INT <= '0';
        wait;
    end process;

end Behavioral;
