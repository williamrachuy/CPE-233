----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2017 08:48:16 PM
-- Design Name: 
-- Module Name: RAT_MCU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity RAT_MCU is
    Port ( IN_PORT : in STD_LOGIC_VECTOR (7 downto 0);
           RESET : in STD_LOGIC;
           INT : in STD_LOGIC;
           CLK : in STD_LOGIC;
           OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID : out STD_LOGIC_VECTOR (7 downto 0);
           IO_STRB : out STD_LOGIC);
end RAT_MCU;

architecture Behavioral of RAT_MCU is

    component ControlUnit 
    port (
		  -- INPUTS
        C_FLAG, Z_FLAG, INT, RESET, CLK : in STD_LOGIC;            -- FLAGS, INTERRUPT, RESET, CLOCK
        OPCODE_HI_5 : in STD_LOGIC_VECTOR (4 downto 0);            -- OPERATION CODES
        OPCODE_LO_2 : in STD_LOGIC_VECTOR (1 downto 0);
        -- OUTPUTS (CONTROL SIGNALS)
        I_SET, I_CLR : out STD_LOGIC;                            -- INTERRUPT
        PC_LD, PC_INC : out STD_LOGIC;                            -- PROGRAM COUNTER
        PC_MUX_SEL : out STD_LOGIC_VECTOR (1 downto 0);
        ALU_OPY_SEL : out STD_LOGIC;                            -- ALU
        ALU_SEL : out STD_LOGIC_VECTOR (3 downto 0);
        RF_WR : out STD_LOGIC;                                    -- REG FILE
        RF_WR_SEL : out STD_LOGIC_VECTOR (1 downto 0);
        SP_LD, SP_INCR, SP_DECR : out STD_LOGIC;                -- STACK POINTER
        SCR_WE, SCR_DATA_SEL : out STD_LOGIC;                    -- SCRATCH RAM
        SCR_ADDR_SEL : out STD_LOGIC_VECTOR (1 downto 0);
        FLG_C_SET, FLG_C_CLR, FLG_C_LD,                            -- FLAGS
        FLG_Z_LD, FLG_LD_SEL, FLG_SHAD_LD : out STD_LOGIC;
        RST, IO_STRB : out STD_LOGIC);                                    -- RESET
    end component;
    
    component ALU
    port(
        CIN : in STD_LOGIC;
        SEL : in STD_LOGIC_VECTOR (3 downto 0);
        A : in STD_LOGIC_VECTOR (7 downto 0);
        B : in STD_LOGIC_VECTOR (7 downto 0);
        RESULT : out STD_LOGIC_VECTOR (7 downto 0);
        C : out STD_LOGIC;
        Z : out STD_LOGIC);
    end component;
    
    component ALU_MUX
    port(
        ALU_OPY_SEL : in STD_LOGIC;
        ALU_MUX_FROM_RF : in STD_LOGIC_VECTOR (7 downto 0);
        ALU_MUX_FROM_IMMED : in STD_LOGIC_VECTOR (7 downto 0);
        ALU_MUX_OUT : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component FLAGS
    port(
        FLG_C_IN, FLG_Z_IN,
        FLG_C_SET, FLG_C_CLR, FLG_C_LD,
        FLG_Z_LD, FLG_LD_SEL,
        FLG_SHAD_LD, CLK : in STD_LOGIC;
        FLG_C_OUT, FLG_Z_OUT : out STD_LOGIC);
    end component;
    
    component PC
    port(
    	PC_DATA_IN : in STD_LOGIC_VECTOR (9 downto 0);
        PC_LD, PC_INC, PC_RST, CLK : in STD_LOGIC;
        PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0));
    end component;
    
    component PC_MUX
    port(
    	PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0);
        PC_MUX_FROM_IMMED, PC_MUX_FROM_SCR : in STD_LOGIC_VECTOR (9 downto 0);
        PC_MUX_OUT : out STD_LOGIC_VECTOR (9 downto 0));
    end component;
    
    component REG_FILE
    port(
    	RF_DATA_IN : in STD_LOGIC_VECTOR (7 downto 0);
        RF_ADRX, RF_ADRY : in STD_LOGIC_VECTOR (4 downto 0);
        RF_WR, CLK : in STD_LOGIC;
        RF_DX_OUT, RF_DY_OUT : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component REG_FILE_MUX 
    port(
		RF_WR_SEL : in STD_LOGIC_VECTOR (1 downto 0);
        RF_MUX_FROM_SCR, RF_MUX_FROM_ALU : in STD_LOGIC_VECTOR (7 downto 0);
        RF_MUX_FROM_SP, RF_MUX_FROM_IN_PORT : in STD_LOGIC_VECTOR (7 downto 0);
        RF_MUX_OUT : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component SP 
    port(
        SP_DATA_IN : in STD_LOGIC_VECTOR (7 downto 0);
        SP_LD, SP_INCR, SP_DECR, SP_RST, CLK : in STD_LOGIC;
        SP_DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component SCR
    port(
        SCR_ADDR : in STD_LOGIC_VECTOR (7 downto 0);
        SCR_DATA_IN : in STD_LOGIC_VECTOR (9 downto 0);
        SCR_WE, CLK : in STD_LOGIC;
        SCR_DATA_OUT : out STD_LOGIC_VECTOR (9 downto 0));   
    end component;
    
    component SCR_ADDR_MUX
    port ( SCR_ADDR_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           SCR_ADDR_FROM_RF : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_ADDR_FROM_IR : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_ADDR_FROM_SP : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_ADDR_FROM_SP_DEC : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_ADDR_MUX_OUT : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component SCR_DATA_MUX
    port ( SCR_DATA_SEL : in STD_LOGIC;
           SCR_DATA_FROM_RF : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_DATA_FROM_PC : in STD_LOGIC_VECTOR (9 downto 0);
           SCR_DATA_MUX_OUT : out STD_LOGIC_VECTOR (9 downto 0));
    end component;
    
    component prog_rom 
    port (     ADDRESS : in std_logic_vector(9 downto 0); 
           INSTRUCTION : out std_logic_vector(17 downto 0); 
                   CLK : in std_logic);  
    end component;
    
    component INTERRUPT
    port ( INTERRUPT_SET, INTERRUPT_CLR, CLK : in STD_LOGIC;
           INTERRUPT_OUT : out STD_LOGIC);
    end component;
    
    signal C_FLAG, Z_FLAG : std_logic; -- control unit signals
    signal INSTRUCTION : std_logic_vector(17 downto 0);
    signal I_SET, I_CLR : std_logic;
    signal PC_LD, PC_INC : std_logic;
    signal PC_MUX_SEL : std_logic_vector(1 downto 0);
    signal ALU_OPY_SEL : std_logic;
    signal ALU_SEL : std_logic_vector(3 downto 0);
    signal RF_WR : std_logic;
    signal RF_WR_SEL : std_logic_vector(1 downto 0);
    signal SP_LD, SP_INCR, SP_DECR : std_logic;
    signal SCR_WE, SCR_DATA_SEL : std_logic;
    signal SCR_ADDR_SEL : std_logic_vector(1 downto 0);
    signal FLG_C_SET, FLG_C_CLR, FLG_C_LD : std_logic;
    signal FLG_Z_LD, FLG_LD_SEL, FLG_SHAD_LD : std_logic;
    signal RST : std_logic;
    
    signal ALU_MUX_OUT, DX_OUT, DY_OUT, RESULT : std_logic_vector(7 downto 0);
    signal ALU_C_OUT, ALU_Z_OUT : std_logic;
    
    signal PC_MUX_OUT, PC_COUNT, SCR_DATA_OUT : std_logic_vector(9 downto 0);
    
    signal RF_MUX_OUT : std_logic_vector(7 downto 0);
    
    signal SP_DATA_OUT, SP_DATA_OUT_DEC : std_logic_vector(7 downto 0);
    signal SCR_DATA_MUX_OUT : std_logic_vector(9 downto 0);
    signal SCR_ADDR_MUX_OUT : std_logic_vector(7 downto 0);
    
    signal INTERRUPT_ENABLE, INT_AND : std_logic;
   
begin
    OUT_PORT <= DX_OUT;
    PORT_ID <= INSTRUCTION(7 downto 0);
    INT_AND <= (INT AND INTERRUPT_ENABLE); -- AND gate to enable or disable INT
    SP_DATA_OUT_DEC <= std_logic_vector(unsigned(SP_DATA_OUT)-1); -- signal 1 less than current SP
    
    TheControlUnit : ControlUnit port map(
        C_FLAG => C_FLAG, Z_FLAG => Z_FLAG, INT => INT_AND,
        RESET => RESET, 
        OPCODE_HI_5 => INSTRUCTION(17 downto 13),
        OPCODE_LO_2 => INSTRUCTION(1 downto 0),
        CLK => CLK,
        I_SET => I_SET, I_CLR => I_CLR,
        PC_LD => PC_LD, PC_INC => PC_INC,
        PC_MUX_SEL => PC_MUX_SEL,
        ALU_OPY_SEL => ALU_OPY_SEL,
        ALU_SEL => ALU_SEL,
        RF_WR => RF_WR, RF_WR_SEL => RF_WR_SEL,
        SP_LD => SP_LD, SP_INCR => SP_INCR, SP_DECR => SP_DECR,
        SCR_WE => SCR_WE, SCR_ADDR_SEL => SCR_ADDR_SEL,
        SCR_DATA_SEL => SCR_DATA_SEL,
        FLG_C_SET => FLG_C_SET, FLG_C_CLR=> FLG_C_CLR,
        FLG_C_LD => FLG_C_LD, FLG_Z_LD => FLG_Z_LD,
        FLG_LD_SEL => FLG_LD_SEL, FLG_SHAD_LD => FLG_SHAD_LD,
        RST => RST, IO_STRB => IO_STRB);
        
    TheALU : ALU port map(
        CIN => C_FLAG,
        SEL => ALU_SEL, A => DX_OUT, B => ALU_MUX_OUT,
        RESULT => RESULT, 
        C => ALU_C_OUT, Z => ALU_Z_OUT);
    
    TheALU_MUX : ALU_MUX port map(
        ALU_OPY_SEL => ALU_OPY_SEL,
        ALU_MUX_FROM_RF => DY_OUT,
        ALU_MUX_FROM_IMMED => INSTRUCTION(7 downto 0),
        ALU_MUX_OUT => ALU_MUX_OUT);
    
    TheFLAGS : FLAGS port map(
        FLG_C_IN => ALU_C_OUT, FLG_Z_IN => ALU_Z_OUT,
        FLG_C_SET => FLG_C_SET, FLG_C_CLR => FLG_C_CLR,
        FLG_C_LD => FLG_C_LD, FLG_Z_LD => FLG_Z_LD,
        FLG_LD_SEL => FLG_LD_SEL, FLG_SHAD_LD => FLG_SHAD_LD,
        FLG_C_OUT => C_FLAG, FLG_Z_OUT => Z_FLAG,
        CLK => CLK);
        
    ThePC : PC port map(
        PC_DATA_IN => PC_MUX_OUT, CLK => CLK,
        PC_RST => RST, PC_LD => PC_LD,
        PC_INC => PC_INC, PC_COUNT => PC_COUNT);
        
    ThePC_MUX : PC_MUX port map(
        PC_MUX_SEL => PC_MUX_SEL,
        PC_MUX_FROM_IMMED => INSTRUCTION(12 downto 3),
        PC_MUX_FROM_SCR => SCR_DATA_OUT,
        PC_MUX_OUT => PC_MUX_OUT);
        
    TheREG_FILE : REG_FILE port map(
        RF_DATA_IN => RF_MUX_OUT, 
        RF_ADRX => INSTRUCTION(12 downto 8),
        RF_ADRY => INSTRUCTION(7 downto 3),
        RF_WR => RF_WR, CLK => CLK,
        RF_DX_OUT => DX_OUT, RF_DY_OUT => DY_OUT);
        
    TheREG_FILE_MUX : REG_FILE_MUX port map(
        RF_WR_SEL => RF_WR_SEL, 
        RF_MUX_FROM_SCR => SCR_DATA_OUT(7 downto 0),
        RF_MUX_FROM_ALU => RESULT,
        RF_MUX_FROM_SP => SP_DATA_OUT,
        RF_MUX_FROM_IN_PORT => IN_PORT,
        RF_MUX_OUT => RF_MUX_OUT);
        
    TheSP : SP port map(
        SP_RST => RST,
        CLK => CLK,
        SP_LD => SP_LD,
        SP_INCR => SP_INCR,
        SP_DECR => SP_DECR,
        SP_DATA_IN => DX_OUT,
        SP_DATA_OUT => SP_DATA_OUT);
        
    TheSCR : SCR port map(
        SCR_ADDR => SCR_ADDR_MUX_OUT,
        SCR_DATA_IN => SCR_DATA_MUX_OUT,
        SCR_WE => SCR_WE, CLK => CLK,
        SCR_DATA_OUT => SCR_DATA_OUT);
        
    TheSCR_ADDR_MUX : SCR_ADDR_MUX port map(
        SCR_ADDR_SEL => SCR_ADDR_SEL,
        SCR_ADDR_FROM_RF => DY_OUT,
        SCR_ADDR_FROM_IR => INSTRUCTION(7 downto 0),
        SCR_ADDR_FROM_SP => SP_DATA_OUT,
        SCR_ADDR_FROM_SP_DEC => SP_DATA_OUT_DEC,
        SCR_ADDR_MUX_OUT => SCR_ADDR_MUX_OUT);
        
    TheSCR_DATA_MUX : SCR_DATA_MUX port map(
        SCR_DATA_SEL => SCR_DATA_SEL,
        SCR_DATA_FROM_RF => DX_OUT,
        SCR_DATA_FROM_PC => PC_COUNT,
        SCR_DATA_MUX_OUT => SCR_DATA_MUX_OUT);
        
    TheProg_ROM : prog_rom port map(
        ADDRESS => PC_COUNT,
        INSTRUCTION => INSTRUCTION,
        CLK => CLK);
        
    TheINTERRUPT : INTERRUPT port map(
        INTERRUPT_SET => I_SET,
        INTERRUPT_CLR => I_CLR,
        INTERRUPT_OUT => INTERRUPT_ENABLE,
        CLK => CLK);
        
        
end Behavioral;
