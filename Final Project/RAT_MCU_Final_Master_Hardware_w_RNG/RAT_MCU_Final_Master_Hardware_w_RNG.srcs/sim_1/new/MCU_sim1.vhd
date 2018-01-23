----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/10/2017 11:21:55 AM
-- Design Name: 
-- Module Name: MCU_sim1 - Behavioral
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

entity MCU_sim1 is
--  Port ( );
end MCU_sim1;

architecture Behavioral of MCU_sim1 is

    component RAT_MCU
    Port ( IN_PORT : in STD_LOGIC_VECTOR (7 downto 0);
           RESET : in STD_LOGIC;
           INT : in STD_LOGIC;
           CLK : in STD_LOGIC;
           OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID : out STD_LOGIC_VECTOR (7 downto 0);
           IO_STRB : out STD_LOGIC);
    end component;
    
    signal RESET, INT, CLK, IO_STRB : std_logic := '0';
    signal IN_PORT, OUT_PORT, PORT_ID : std_logic_vector(7 downto 0) := "00000000";

begin

    UUT : RAT_MCU
    port map( IN_PORT => IN_PORT,
              RESET => RESET,
              INT => INT,
              CLK => CLK,
              OUT_PORT => OUT_PORT,
              PORT_ID => PORT_ID,
              IO_STRB => IO_STRB );
              
    process is            
    begin
        CLK <= not CLK;
        wait for 5 ns;
    end process;
    
    process is
    begin
        IN_PORT <= "00000000";
        RESET <= '0';
        INT <= '0';
        wait for 10 ns;
        
        IN_PORT <= "00001111";
        
        wait;
    end process;
    

end Behavioral;
