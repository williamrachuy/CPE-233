library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC_MUX is
	Port (
		PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0);
		PC_MUX_FROM_IMMED, PC_MUX_FROM_SCR : in STD_LOGIC_VECTOR (9 downto 0);
		PC_MUX_OUT : out STD_LOGIC_VECTOR (9 downto 0));
end PC_MUX;

architecture Behavioral of PC_MUX is
begin

	process (PC_MUX_SEL, PC_MUX_FROM_IMMED, PC_MUX_FROM_SCR) is
	begin
		case PC_MUX_SEL is
			when "00" => PC_MUX_OUT <= PC_MUX_FROM_IMMED;
			when "01" => PC_MUX_OUT <= PC_MUX_FROM_SCR;
			when "10" => PC_MUX_OUT <= "1111111111";
			when others => PC_MUX_OUT <= "0000000000";
		end case;
	end process;

end Behavioral;