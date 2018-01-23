library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FLAGS is
	Port (
		FLG_C_IN, FLG_Z_IN,
		FLG_C_SET, FLG_C_CLR, FLG_C_LD,
		FLG_Z_LD, FLG_LD_SEL,
		FLG_SHAD_LD, CLK : in STD_LOGIC;
		FLG_C_OUT, FLG_Z_OUT : out STD_LOGIC);
end FLAGS;

architecture Behavioral of FLAGS is

	signal Z_MUX_OUT, C_MUX_OUT : STD_LOGIC;
	signal C_OUT, Z_OUT, SHAD_C_OUT, SHAD_Z_OUT : std_logic;

begin

    MUXES: process (FLG_C_IN, FLG_Z_IN, -- MUXES to choose input to C and Z flag
		SHAD_Z_OUT, SHAD_C_OUT, FLG_LD_SEL) is
	begin
	
	   case FLG_LD_SEL is
	       when ('0') => -- ALU
	           C_MUX_OUT <= FLG_C_IN;
	           Z_MUX_OUT <= FLG_Z_IN;
	       when others => -- shadow flags
	           C_MUX_OUT <= SHAD_C_OUT;
	           Z_MUX_OUT <= SHAD_Z_OUT;
	   end case;
	       
	end process MUXES;
    
    
    FLAGS : process (CLK, C_OUT, Z_OUT) is

    begin
	   if rising_edge(CLK) then
	       if (FLG_C_LD = '1') then -- C Flag
	           C_OUT <= C_MUX_OUT;
		   elsif (FLG_C_SET = '1') then
			   C_OUT <= '1';
		   elsif (FLG_C_CLR = '1') then
			   C_OUT <= '0';
		   end if;
		   
		   if (FLG_Z_LD = '1') then -- Z Flag
			   Z_OUT <= Z_MUX_OUT;
		   end if;
        
           if (FLG_SHAD_LD = '1') then
               SHAD_C_OUT <= C_OUT;
               SHAD_Z_OUT <= Z_OUT;
           end if;
		    
	   end if;
	   
	   FLG_C_OUT <= C_OUT;
	   FLG_Z_OUT <= Z_OUT;
	   
    end process;
    

    
end Behavioral;














