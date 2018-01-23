----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2017 08:23:48 PM
-- Design Name: 
-- Module Name: SCR_DATA_MUX - Behavioral
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

entity SCR_DATA_MUX is
    Port ( SCR_DATA_SEL : in STD_LOGIC;
           SCR_DATA_FROM_RF : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_DATA_FROM_PC : in STD_LOGIC_VECTOR (9 downto 0);
           SCR_DATA_MUX_OUT : out STD_LOGIC_VECTOR (9 downto 0));
end SCR_DATA_MUX;

architecture Behavioral of SCR_DATA_MUX is

begin
    process(SCR_DATA_SEL, SCR_DATA_FROM_RF, SCR_DATA_FROM_PC) is
    begin
        case SCR_DATA_SEL is
            when '0' => SCR_DATA_MUX_OUT <= "00" & SCR_DATA_FROM_RF;
            when others => SCR_DATA_MUX_OUT <= SCR_DATA_FROM_PC;
        end case;
    end process;


end Behavioral;
