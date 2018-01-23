----------------------------------------------------------------------------------
-- Company: Hall/ock Electronic Alligator-Based Game Systems, Incorperated
-- Engineer: Lexa Hall & Michael Hallock
-- 
-- Create Date: 11/19/2016 05:02:18 PM
-- Design Name: 4 Digit Display
-- Module Name: Four_Digit_Display - Behavioral
-- Project Name: Wacky Gator
-- Description: A 4 digit 7 segment display driver
--              Outputs the input binary score as a 2 digit decimal number
--              Top two digits are left dark since score cannot possibly exceed 100
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sseg_dec is
    Port ( CurrentInput : in STD_LOGIC_VECTOR (7 downto 0);
           Clk : in STD_LOGIC;
           Segments : out STD_LOGIC_VECTOR (7 downto 0);
           Digits : out STD_LOGIC_VECTOR (3 downto 0));
end sseg_dec;

architecture Behavioral of sseg_dec is

    component ClkDiv
    	port( ClkIn : in STD_LOGIC;
              ClkOut : out STD_LOGIC;
              Diviser : in STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    signal ClkRefresh : std_logic;
    
begin

    RefreshClock : ClkDiv 
        port map (ClkIn => Clk,
                  ClkOut => ClkRefresh,
                  Diviser => x"00032DCD"); -- 240 Hz Refresh Rate
    
    Display: process (ClkRefresh) is
        variable digit : unsigned (1 downto 0) := "00";
        variable digit1, digit2, digit3, digit4 : integer;
        variable number : unsigned (3 downto 0) := "0000";
        variable input : integer;
    begin
        input := to_integer(signed(CurrentInput));
        digit1 := input mod 10;
        digit2 := input / 10;
        digit3 := input / 100;
        digit3 := input / 1000;
        
        --digit1 := to_integer(unsigned(CurrentInput(3 downto 0)));
        --digit2 := to_integer(unsigned(CurrentInput(7 downto 4)));
        --digit3 := to_integer(unsigned(CurrentInput(11 downto 8)));
        --digit4 := to_integer(unsigned(CurrentInput(15 downto 12)));
        
        if (rising_edge(ClkRefresh) ) then
            case (digit) is
                when "00" => 
                    Digits <= "1110";  
                    
                    case (digit1) is
                        when 0 => Segments <= "00000011"; --0
                        when 1 => Segments <= "10011111"; --1
                        when 2 => Segments <= "00100101"; --2
                        when 3 => Segments <= "00001101"; --3
                        when 4 => Segments <= "10011001"; --4
                        when 5 => Segments <= "01001001"; --5
                        when 6 => Segments <= "01000001"; --6
                        when 7 => Segments <= "00011111"; --7
                        when 8 => Segments <= "00000001"; --8
                        when 9 => Segments <= "00011001"; --9
                        when others => Segments <= "11111111";
                    end case;
                when "01" => 
                    Digits <= "1101"; 

                    case (digit2) is
                        when 0 => Segments <= "00000011"; --0
                        when 1 => Segments <= "10011111"; --1
                        when 2 => Segments <= "00100101"; --2
                        when 3 => Segments <= "00001101"; --3
                        when 4 => Segments <= "10011001"; --4
                        when 5 => Segments <= "01001001"; --5
                        when 6 => Segments <= "01000001"; --6
                        when 7 => Segments <= "00011111"; --7
                        when 8 => Segments <= "00000001"; --8
                        when 9 => Segments <= "00011001"; --9
                        when others => Segments <= "11111111";
                    end case;                    
                when "10" => 
                    Digits <= "1011"; 
                    case (digit3) is
                        when 0 => Segments <= "00000011"; --0
                        when 1 => Segments <= "10011111"; --1
                        when 2 => Segments <= "00100101"; --2
                        when 3 => Segments <= "00001101"; --3
                        when 4 => Segments <= "10011001"; --4
                        when 5 => Segments <= "01001001"; --5
                        when 6 => Segments <= "01000001"; --6
                        when 7 => Segments <= "00011111"; --7
                        when 8 => Segments <= "00000001"; --8
                        when 9 => Segments <= "00011001"; --9
                        when others => Segments <= "11111111";
                    end case;                                    
                when others => 
                    Digits <= "0111"; 
                    case (digit4) is
                        when 0 => Segments <= "00000011"; --0
                        when 1 => Segments <= "10011111"; --1
                        when 2 => Segments <= "00100101"; --2
                        when 3 => Segments <= "00001101"; --3
                        when 4 => Segments <= "10011001"; --4
                        when 5 => Segments <= "01001001"; --5
                        when 6 => Segments <= "01000001"; --6
                        when 7 => Segments <= "00011111"; --7
                        when 8 => Segments <= "00000001"; --8
                        when 9 => Segments <= "00011001"; --9
                        when others => Segments <= "11111111"; 
                        end case;             
                end case;
            digit := digit + 1;             
        end if;
    end process Display;

end Behavioral;
