
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pseudo_random is

port (
   clk : in std_logic;
   pseudo_random_num : out std_logic_vector (7 downto 0)
	);          
end pseudo_random;


architecture Behavioral of pseudo_random is
begin
   process(clk)
   variable rand_temp : std_logic_vector(7 downto 0):=(7 => '1',others => '0');
   variable temp : std_logic := '0';

   begin
   if(rising_edge(clk)) then
      temp := rand_temp(7) xor rand_temp(6);
      rand_temp(7 downto 1) := rand_temp(4 downto 2) & rand_temp(1 downto 0) & rand_temp(6 downto 5);
      rand_temp(0) := temp;
   end if;
   
	pseudo_random_num <= rand_temp;
	
   end process;
end;