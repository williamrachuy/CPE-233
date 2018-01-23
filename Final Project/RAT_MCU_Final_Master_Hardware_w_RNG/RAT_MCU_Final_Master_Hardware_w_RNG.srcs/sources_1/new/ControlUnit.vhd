----------------------------------------------------------------------------------
-- Company: The Duckworks
-- Engineer: Michael Hallock & William Rachuy
--
-- Create Date: 02/04/2017 08:07:09 PM
-- Design Name: Control Unit
-- Module Name: ControlUnit - Behavioral
-- Project Name:
-- Target Devices: Bassy3
-- Tool Versions:
-- Description: Control Unit for the RAT MCU
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlUnit is
	Port (
		-- INPUTS
		C_FLAG, Z_FLAG, INT, RESET, CLK : in STD_LOGIC;			-- FLAGS, INTERRUPT, RESET, CLOCK
		OPCODE_HI_5 : in STD_LOGIC_VECTOR (4 downto 0);			-- OPERATION CODES
		OPCODE_LO_2 : in STD_LOGIC_VECTOR (1 downto 0);
		-- OUTPUTS (CONTROL SIGNALS)
		I_SET, I_CLR : out STD_LOGIC;							-- INTERRUPT
		PC_LD, PC_INC : out STD_LOGIC;							-- PROGRAM COUNTER
		PC_MUX_SEL : out STD_LOGIC_VECTOR (1 downto 0);
		ALU_OPY_SEL : out STD_LOGIC;							-- ALU
		ALU_SEL : out STD_LOGIC_VECTOR (3 downto 0);
		RF_WR : out STD_LOGIC;									-- REG FILE
		RF_WR_SEL : out STD_LOGIC_VECTOR (1 downto 0);
		SP_LD, SP_INCR, SP_DECR : out STD_LOGIC;				-- STACK POINTER
		SCR_WE, SCR_DATA_SEL : out STD_LOGIC;					-- SCRATCH RAM
		SCR_ADDR_SEL : out STD_LOGIC_VECTOR (1 downto 0);
		FLG_C_SET, FLG_C_CLR, FLG_C_LD,							-- FLAGS
		FLG_Z_LD, FLG_LD_SEL, FLG_SHAD_LD : out STD_LOGIC;
		RST, IO_STRB : out STD_LOGIC);									-- RESET
end ControlUnit;


architecture Behavioral of ControlUnit is
	type STATE_TYPE is (ST_INIT, ST_FET, ST_EXEC, ST_INTERRUPT);
	signal PS, NS : STATE_TYPE;
	signal OPCODE_7 : STD_LOGIC_VECTOR (6 downto 0);
begin

	OPCODE_7 <= OPCODE_HI_5 & OPCODE_LO_2;						-- concatenate the opcode vectors from 5 and 2 to 7

	STATE_P : process (CLK, RESET)								-- state process
	begin
		if (RESET = '1') then
			PS <= ST_INIT;
		elsif rising_edge(CLK) then
			PS <= NS;
		end if;
	end process;

	COMB_P : process (PS, OPCODE_7)								-- combinational process
	begin

		I_SET <= '0'; I_CLR <= '0';								-- initialize control signals
		PC_INC <= '0';
		PC_LD <= '0'; PC_MUX_SEL <= "00";
		RF_WR <= '0'; RF_WR_SEL <= "00";
		ALU_OPY_SEL <= '0'; ALU_SEL <= "0000";
		FLG_C_SET <= '0'; FLG_C_CLR <= '0'; FLG_C_LD <= '0';
		FLG_Z_LD <= '0'; FLG_LD_SEL <= '0';
		FLG_SHAD_LD <= '0';
		SP_LD <= '0'; SP_INCR <= '0'; SP_DECR <= '0';
		SCR_WE <= '0'; SCR_DATA_SEL <= '0'; SCR_ADDR_SEL <= "00";
        IO_STRB <= '0';
		RST <= '0';

		case (PS) is
			when ST_INIT =>										-- when in INITIATE state
				RST <= '1';
				NS <= ST_FET;
			when ST_FET =>										-- when in FETCH state
				PC_INC <= '1';
				NS <= ST_EXEC;
			when ST_EXEC =>
			    --NS <= ST_FET;
				case (OPCODE_7) is
					when "0000000" =>								-- AND	[rx,ry]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '0'; ALU_SEL <= "0101";
						FLG_C_CLR <= '1'; FLG_Z_LD <= '1';
					when "0000001" =>								-- OR	[rx,ry]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '0'; ALU_SEL <= "0110";
						FLG_C_CLR <= '1'; FLG_Z_LD <= '1';
					when "0000010" =>								-- EXOR	[rx,ry]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '0'; ALU_SEL <= "0111";
						FLG_C_CLR <= '1'; FLG_Z_LD <= '1';
					when "0000011" =>								-- TEST	[rx,ry]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '0'; ALU_SEL <= "1000";
						FLG_C_CLR <= '1'; FLG_Z_LD <= '1';
					when "0000100" =>								-- ADD	[rx,ry]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '0'; ALU_SEL <= "0000";
						FLG_C_LD <= '1'; FLG_Z_LD <= '1';
					when "0000101" =>								-- ADDC	[rx,ry]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '0'; ALU_SEL <= "0001";
						FLG_C_LD <= '1'; FLG_Z_LD <= '1';
					when "0000110" =>								-- SUB	[rx,ry]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '0'; ALU_SEL <= "0010";
						FLG_C_LD <= '1'; FLG_Z_LD <= '1';
					when "0000111" =>								-- SUBC	[rx,ry]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '0'; ALU_SEL <= "0011";
						FLG_C_LD <= '1'; FLG_Z_LD <= '1';
					when "0001000" =>								-- CMP	[rx,ry]
						RF_WR <= '0'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '0'; ALU_SEL <= "0100";
						FLG_C_LD <= '1'; FLG_Z_LD <= '1';
					when "0001001" =>								-- MOV	[rx,ry] DOUBLE CHECK
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '0'; ALU_SEL <= "1110";
					when "0001010" =>								-- LD	[rx,ry] DOUBLE CHECK
						RF_WR <= '1'; RF_WR_SEL <= "01";
						SCR_WE <= '0'; SCR_ADDR_SEL <= "00";
					when "0001011" =>								-- ST	[rx,ry] DOUBLE CHECK
						RF_WR <= '0';
						SCR_WE <= '1'; SCR_DATA_SEL <= '0'; SCR_ADDR_SEL <= "00";
					when "1000000"|"1000001"|"1000010"|"1000011" =>	-- AND	[rx,imm]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '1'; ALU_SEL <= "0101";
						FLG_C_CLR <= '1'; FLG_Z_LD <= '1';
					when "1000100"|"1000101"|"1000110"|"1000111" =>	-- OR	[rx,imm]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '1'; ALU_SEL <= "0110";
						FLG_C_CLR <= '1'; FLG_Z_LD <= '1';
					when "1001000"|"1001001"|"1001010"|"1001011" =>	-- EXOR	[rx,imm]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '1'; ALU_SEL <= "0111";
						FLG_C_CLR <= '1'; FLG_Z_LD <= '1';
					when "1001100"|"1001101"|"1001110"|"1001111" =>	-- TEST	[rx,imm]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '1'; ALU_SEL <= "1000";
						FLG_C_CLR <= '1'; FLG_Z_LD <= '1';
					when "1010000"|"1010001"|"1010010"|"1010011" =>	-- ADD	[rx,imm]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '1'; ALU_SEL <= "0000";
						FLG_C_LD <= '1'; FLG_Z_LD <= '1';
					when "1010100"|"1010101"|"1010110"|"1010111" =>	-- ADDC	[rx,imm]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '1'; ALU_SEL <= "0001";
						FLG_C_LD <= '1'; FLG_Z_LD <= '1';
					when "1011000"|"1011001"|"1011010"|"1011011" =>	-- SUB	[rx,imm]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '1'; ALU_SEL <= "0010";
						FLG_C_LD <= '1'; FLG_Z_LD <= '1';
					when "1011100"|"1011101"|"1011110"|"1011111" =>	-- SUBC	[rx,imm]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '1'; ALU_SEL <= "0011";
						FLG_C_LD <= '1'; FLG_Z_LD <= '1';
					when "1100000"|"1100001"|"1100010"|"1100011" =>	-- CMP	[rx,imm]
						RF_WR <= '0'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '1'; ALU_SEL <= "0100";
						FLG_C_LD <= '1'; FLG_Z_LD <= '1';
					when "1100100"|"1100101"|"1100110"|"1100111" =>	-- IN	[rx,imm]
						RF_WR <= '1'; RF_WR_SEL <= "11";
						IO_STRB <= '0';
					when "1101000"|"1101001"|"1101010"|"1101011" =>	-- OUT	[rx,imm]
						RF_WR <= '0';
						IO_STRB <= '1';
					when "1101100"|"1101101"|"1101110"|"1101111" =>	-- MOV	[rx,imm] DOUBLE CHECK
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_OPY_SEL <= '1'; ALU_SEL <= "1110";
					when "1110000"|"1110001"|"1110010"|"1110011" =>	-- LD	[rx,imm] DOUBLE CHECK
						RF_WR <= '1'; RF_WR_SEL <= "01";
						SCR_WE <= '0'; SCR_ADDR_SEL <= "01";
					when "1110100"|"1110101"|"1110110"|"1110111" =>	-- ST	[rx,imm] DOUBLE CHECK
						RF_WR <= '0';
						SCR_WE <= '1'; SCR_DATA_SEL <= '0'; SCR_ADDR_SEL <= "01";
					when "0010000" =>								-- BRN	[label]
						PC_LD <= '1'; PC_MUX_SEL <= "00";
					when "0010001" =>								-- CALL	[label]
						PC_LD <= '1'; PC_MUX_SEL <= "00";
						SP_DECR <= '1';
						SCR_ADDR_SEL <= "11"; -- double check this is (SP-1) on implemented MUX
						SCR_DATA_SEL <= '1'; SCR_WE <= '1';
					when "0010010" =>								-- BREQ	[label]
						if (Z_FLAG = '1') then
							PC_LD <= '1'; PC_MUX_SEL <= "00";
						end if;
					when "0010011" =>								-- BRNE	[label]
						if (Z_FLAG = '0') then
							PC_LD <= '1'; PC_MUX_SEL <= "00";
						end if;
					when "0010100" =>								-- BRCS	[label]
						if (C_FLAG = '1') then
							PC_LD <= '1'; PC_MUX_SEL <= "00";
						end if;
					when "0010101" =>								-- BRCC	[label]
						if (C_FLAG = '0') then
							PC_LD <= '1'; PC_MUX_SEL <= "00";
						end if;
					when "0100000" =>								-- LSL	[rx]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_SEL <= "1001";
						FLG_C_LD <= '1'; FLG_Z_LD <= '1';
					when "0100001" =>								-- LSR	[rx]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_SEL <= "1010";
						FLG_C_LD <= '1'; FLG_Z_LD <= '1';
					when "0100010" =>								-- ROL	[rx]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_SEL <= "1011";
						FLG_C_LD <= '1'; FLG_Z_LD <= '1';
					when "0100011" =>								-- ROR	[rx]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_SEL <= "1100";
						FLG_C_LD <= '1'; FLG_Z_LD <= '1';
					when "0100100" =>								-- ASR	[rx]
						RF_WR <= '1'; RF_WR_SEL <= "00";
						ALU_SEL <= "1101";
						FLG_C_LD <= '1'; FLG_Z_LD <= '1';
					when "0100101" =>								-- PUSH	[rx]
						SP_DECR <= '1';
						SCR_DATA_SEL <= '0'; SCR_WE <= '1';
						SCR_ADDR_SEL <= "11"; -- double check this is (SP-1) on MUX
					when "0100110" =>								-- POP	[rx]
						RF_WR <= '1'; RF_WR_SEL <= "01"; -- taking scratch ram as input
						SP_INCR <= '1';
						SCR_ADDR_SEL <= "10"; -- make sure this is (SP) in MUX
					when "0101000" =>								-- WSP	[rx]
						SP_LD <= '1';
					when "0110000" =>								-- CLC
						FLG_C_CLR <= '1';
					when "0110001" =>								-- SEC
						FLG_C_SET <= '1';
					when "0110010" =>								-- RET
						PC_LD <= '1'; PC_MUX_SEL <= "01";
						SP_INCR <= '1'; SCR_ADDR_SEL <= "10";
					when "0110100" =>								-- SEI
						I_SET <= '1';
					when "0110101" =>								-- CLI
						I_CLR <= '1';
					when "0110110" =>								-- RETID
						PC_LD <= '1'; PC_MUX_SEL <= "01"; -- make sure this is scratch on MUX
						SP_INCR <= '1'; SCR_ADDR_SEL <= "10"; -- make sure this is PC on MUX
						I_CLR <= '1';
						FLG_C_LD <= '1'; FLG_Z_LD <= '1'; FLG_LD_SEL <= '1';
					when "0110111" =>								-- RETIE
						PC_LD <= '1'; PC_MUX_SEL <= "01"; -- make sure this is scratch on MUX
						SP_INCR <= '1'; SCR_ADDR_SEL <= "10"; -- make sure this is PC on MUX
						I_SET <= '1'; 
						FLG_C_LD <= '1'; FLG_Z_LD <= '1'; FLG_LD_SEL <= '1';
					when OTHERS => RST <= '0';
				end case;
				
				if (INT = '1') then NS <= ST_INTERRUPT; -- interrupt if INT set
				else 
				    NS <= ST_FET;
				end if;
				
			when ST_INTERRUPT => -- interrupt state
			     PC_MUX_SEL <= "10";
			     PC_LD <= '1';
			     SP_DECR <= '1';
			     I_CLR <= '1';
			     SCR_DATA_SEL <= '1';
			     SCR_WE <= '1';
			     SCR_ADDR_SEL <= "11";
			     FLG_SHAD_LD <= '1';	
			     
			     NS <= ST_FET; -- go to fetch cycle following interrupt cycle
				
			when others =>
				NS <= ST_INIT;
		end case;
end process;				

end Behavioral;
