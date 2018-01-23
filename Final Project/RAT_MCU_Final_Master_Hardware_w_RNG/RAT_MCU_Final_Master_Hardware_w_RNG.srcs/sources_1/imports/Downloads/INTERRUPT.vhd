library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity INTERRUPT is
	Port ( INTERRUPT_SET, INTERRUPT_CLR, CLK : in STD_LOGIC;
		INTERRUPT_OUT : out STD_LOGIC);
end INTERRUPT;

architecture Behavioral of INTERRUPT is
begin

    process(CLK) is
    begin
    
        if rising_edge(CLK) then
            if (INTERRUPT_SET = '1') then
                INTERRUPT_OUT <= '1';
            elsif (INTERRUPT_CLR = '1') then
                INTERRUPT_OUT <= '0';
            end if;
        end if;

    end process;

end Behavioral;