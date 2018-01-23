library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REG_FILE_MUX is
	Port (
		RF_WR_SEL : in STD_LOGIC_VECTOR (1 downto 0);
		RF_MUX_FROM_SCR, RF_MUX_FROM_ALU : in STD_LOGIC_VECTOR (7 downto 0);
		RF_MUX_FROM_SP, RF_MUX_FROM_IN_PORT : in STD_LOGIC_VECTOR (7 downto 0);
		RF_MUX_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end REG_FILE_MUX;

architecture Behavioral of REG_FILE_MUX is
begin

	process (RF_WR_SEL, RF_MUX_FROM_SCR, RF_MUX_FROM_ALU, RF_MUX_FROM_SP, RF_MUX_FROM_IN_PORT) is
	begin
		case RF_WR_SEL is
			when "00" => RF_MUX_OUT <= RF_MUX_FROM_ALU;
			when "01" => RF_MUX_OUT <= RF_MUX_FROM_SCR;
			when "10" => RF_MUX_OUT <= RF_MUX_FROM_SP;
			when "11" => RF_MUX_OUT <= RF_MUX_FROM_IN_PORT;
			when others => RF_MUX_OUT <= x"FF";
		end case;
	end process;
    --process (RF_WR_SEL = "00") else

end Behavioral;