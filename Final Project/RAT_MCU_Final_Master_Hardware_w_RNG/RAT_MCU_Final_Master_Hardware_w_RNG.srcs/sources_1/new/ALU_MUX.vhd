----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2017 08:16:04 PM
-- Design Name: 
-- Module Name: ALU_MUX - Behavioral
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

entity ALU_MUX is
    Port ( ALU_OPY_SEL : in STD_LOGIC;
           ALU_MUX_FROM_RF : in STD_LOGIC_VECTOR (7 downto 0);
           ALU_MUX_FROM_IMMED : in STD_LOGIC_VECTOR (7 downto 0);
           ALU_MUX_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end ALU_MUX;

architecture Behavioral of ALU_MUX is

begin
    process(ALU_OPY_SEL, ALU_MUX_FROM_RF, ALU_MUX_FROM_IMMED) is
    begin
        case ALU_OPY_SEL is
            when '0' => ALU_MUX_OUT <= ALU_MUX_FROM_RF;
            when others => ALU_MUX_OUT <= ALU_MUX_FROM_IMMED;
        end case;
    
    end process;


end Behavioral;
