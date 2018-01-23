library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMErIC_STD.ALL;

entity SCR is
	Port (
		SCR_ADDR : in STD_LOGIC_VECTOR (7 downto 0);
		SCR_DATA_IN : in STD_LOGIC_VECTOR (9 downto 0);
		SCR_WE, CLK : in STD_LOGIC;
		SCR_DATA_OUT : out STD_LOGIC_VECTOR (9 downto 0));
end SCR;

architecture Behavioral of SCR is
	type memory is array (0 to 255) of STD_LOGIC_VECTOR (9 downto 0);
	signal REG : memory := (others => (others => '0'));
begin

	SCR_DATA_OUT <= REG(to_integer(unsigned(SCR_ADDR)));

	process(CLK) begin
		if rising_edge(CLK) then
			if (SCR_WE = '1') then
				REG(to_integer(unsigned(SCR_ADDR))) <= SCR_DATA_IN;
			end if;
		end if;
	end process;

end Behavioral; 