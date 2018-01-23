----------------------------------------------------------------------------------
-- Company: Hall/ock Electronic Alligator-Based Game Systems, Incorperated
-- Engineer: Lexa Hall & Michael Hallock
-- 
-- Create Date: 12/03/2016 03:54:01 PM
-- Design Name: Clock Divider
-- Module Name: ClkDiv - Behavioral
-- Project Name: Wacky Gator
-- Target Devices: Basys3
-- Description: A clock divider which will divider an incoming clock signal by
--              an arbitrary divisor
--              The diviser indicates one half period and as such
--              must be half the number of clock cycles of the desired clock period
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ClkDiv is
	port(ClkIn : in STD_LOGIC;
		ClkOut : out STD_LOGIC;
		Diviser : in STD_LOGIC_VECTOR (31 downto 0));

end ClkDiv;

architecture Behavioral of ClkDiv is
	
	signal ClkToggle : std_logic := '0';	

begin
	ClkOut <= ClkToggle;

	process (ClkIn) is -- x in front of number makes it hex
		variable counter : unsigned (31 downto 0) := x"00000000";
	begin 
		if rising_edge(ClkIn) then
			counter := counter + 1;
			if (std_logic_vector(counter) = Diviser) then
				ClkToggle <= not ClkToggle;
				counter := x"00000000";
			end if;
		end if;
	end process;

end Behavioral;