library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC is
	Port (
		PC_DATA_IN : in STD_LOGIC_VECTOR (9 downto 0);
		PC_LD, PC_INC, PC_RST, CLK : in STD_LOGIC;
		PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0));
end PC;

architecture Behavioral of PC is
begin

	process(CLK) is
		variable varCOUNT : unsigned (9 downto 0);
	begin
		if rising_edge(CLK) then
			if PC_RST = '1' then
				varCOUNT := ( others => '0' );
			elsif PC_LD = '1' then
				varCOUNT := unsigned(PC_DATA_IN);
			elsif PC_INC = '1' then
				varCOUNT := varCOUNT + 1;
			end if;
			PC_COUNT <= std_logic_vector(varCOUNT);
		end if;
	end process;

end Behavioral; 