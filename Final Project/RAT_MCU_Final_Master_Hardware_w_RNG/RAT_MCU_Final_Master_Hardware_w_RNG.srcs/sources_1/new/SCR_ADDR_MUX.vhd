----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2017 08:29:22 PM
-- Design Name: 
-- Module Name: SCR_ADDR_MUX - Behavioral
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

entity SCR_ADDR_MUX is
    Port ( SCR_ADDR_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           SCR_ADDR_FROM_RF : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_ADDR_FROM_IR : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_ADDR_FROM_SP : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_ADDR_FROM_SP_DEC : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_ADDR_MUX_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end SCR_ADDR_MUX;

architecture Behavioral of SCR_ADDR_MUX is

begin
    process(SCR_ADDR_SEL, SCR_ADDR_FROM_RF, SCR_ADDR_FROM_SP,
            SCR_ADDR_FROM_IR, SCR_ADDR_FROM_SP_DEC) is
    begin
    case SCR_ADDR_SEL is
        when "00" => SCR_ADDR_MUX_OUT <= SCR_ADDR_FROM_RF;
        when "01" => SCR_ADDR_MUX_OUT <= SCR_ADDR_FROM_IR;
        when "10" => SCR_ADDR_MUX_OUT <= SCR_ADDR_FROM_SP;
        when others => SCR_ADDR_MUX_OUT <= SCR_ADDR_FROM_SP_DEC;
    end case;
    end process;


end Behavioral;
