library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity REG_FILE is
	Port (
		RF_DATA_IN : in STD_LOGIC_VECTOR (7 downto 0);
		RF_ADRX, RF_ADRY : in STD_LOGIC_VECTOR (4 downto 0);
		RF_WR, CLK : in STD_LOGIC;
		RF_DX_OUT, RF_DY_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end REG_FILE;

architecture Behavioral of REG_FILE is
	type memory is array (0 to 31) of std_logic_vector(7 downto 0);
	signal REG : memory := (others => (others => '0'));
begin

	RF_DX_OUT <= REG(to_integer(unsigned(RF_ADRX)));
	RF_DY_OUT <= REG(to_integer(unsigned(RF_ADRY)));

	process(CLK) is
	begin
		if rising_edge(CLK) then
			if (RF_WR = '1') then
				REG(to_integer(unsigned(RF_ADRX))) <= RF_DATA_IN;
			end if;
		end if;
	end process;

end Behavioral;