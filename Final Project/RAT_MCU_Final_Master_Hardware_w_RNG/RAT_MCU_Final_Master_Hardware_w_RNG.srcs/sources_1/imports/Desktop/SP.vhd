library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SP is
	Port (
		SP_DATA_IN : in STD_LOGIC_VECTOR (7 downto 0);
		SP_LD, SP_INCR, SP_DECR, SP_RST, CLK : in STD_LOGIC;
		SP_DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end SP;

architecture Behavioral of SP is
begin

	process(CLK) is
		variable varCOUNT : unsigned (7 downto 0) := "11111111";
	begin
		if rising_edge(CLK) then
			if SP_RST = '1' then
				varCOUNT := ( others => '0' );
			elsif SP_LD = '1' then
				varCOUNT := unsigned(SP_DATA_IN);
			elsif SP_INCR = '1' then
				varCOUNT := varCOUNT + 1;
			elsif SP_DECR = '1' then
				varCOUNT := varCOUNT - 1;
			end if;

		end if;
		SP_DATA_OUT <= std_logic_vector(varCOUNT);
	end process;

end Behavioral; 