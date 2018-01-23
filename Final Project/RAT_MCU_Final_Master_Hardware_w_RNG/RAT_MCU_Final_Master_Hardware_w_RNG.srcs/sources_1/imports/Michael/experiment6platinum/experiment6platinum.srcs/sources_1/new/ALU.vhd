----------------------------------------------------------------------------------
-- Company: The Duckworks
-- Engineer: Michael Hallock & William Rachuy
-- 
-- Create Date: 01/30/2017 12:41:10 PM
-- Design Name: Arithmetic Logic Unit
-- Module Name: ALU - Behavioral
-- Project Name: Experiment 6
-- Description: An ALU creatd for the RAT MCU
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port ( CIN : in STD_LOGIC;
           SEL : in STD_LOGIC_VECTOR (3 downto 0);
           A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           RESULT : out STD_LOGIC_VECTOR (7 downto 0);
           C : out STD_LOGIC;
           Z : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

begin

    process (CIN, SEL, A, B) is
        variable tempRESULT : std_logic_vector(8 downto 0) := "000000000";
        variable tempZ : std_logic := '0';
    begin
        tempRESULT := "000000000";
        case SEL is 
            when "0000" => -- ADD
                tempRESULT := std_logic_vector(unsigned('0' & A) + unsigned('0' & B));          
            when "0001" => -- ADDC
                tempRESULT := std_logic_vector(unsigned('0' & A) +  unsigned('0' & B) + ('0' & CIN)); 
            when "0010"|"0100" => -- SUB/CMP 
                tempRESULT := std_logic_vector(unsigned(('0' & A)) - unsigned(('0' & B)));                
            when "0011" => -- SUBC
                tempRESULT := std_logic_vector(unsigned('0' & A) - unsigned('0' & B) - ('0' & CIN)); 
                
            when "0101"|"1000" => tempRESULT := '0' & (A AND B); -- AND/TEST

            when "0110" => tempRESULT := '0' & (A OR B); -- OR

            when "0111" => tempRESULT := '0' & (A XOR B); -- XOR
  
            when "1001" => tempRESULT := A(7 downto 0) & CIN; -- LSL

            when "1010" => tempRESULT := A(0) & CIN & A(7 downto 1); -- LSR
                         
            when "1011" => tempRESULT := A(7 downto 0) & A(7); -- ROL

            when "1100" => tempRESULT := A(0) & A(0) & A(7 downto 1); -- ROR
      
            when "1101" => tempRESULT := A(0) & A(7) & A(7 downto 1); -- ASR                  
                                                 
            when "1110" => tempRESULT := CIN & B; -- MOV                          
                            
            when others => tempRESULT := tempRESULT;        
       
        end case;   
 

        if (tempRESULT(7 downto 0) = "00000000") then -- set/clear carry flag
            Z <= '1';                              
        else 
            Z <= '0';
        end if;

              
    C <= std_logic(tempRESULT(8));
    RESULT <= std_logic_vector(tempRESULT(7 downto 0));
    end process;


end Behavioral;
