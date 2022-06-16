---------------
-- VHDL 2008 --
---------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY segmentdecoder IS
	PORT (
	   value : IN STD_ULOGIC_VECTOR(3 DOWNTO 0);
	   
	   seven_seg_10  : OUT STD_ULOGIC_VECTOR(6 DOWNTO 0); -- 10er-Ziffernanzeige
	   seven_seg_1   : OUT STD_ULOGIC_VECTOR(6 DOWNTO 0) -- 1er-Ziffernanzeige
	);
END ENTITY;

ARCHITECTURE rtl OF segmentdecoder IS

    SIGNAL sign1  : UNSIGNED RANGE "0000" TO "1001";
    SIGNAL sign10 : UNSIGNED RANGE "0000" TO "1001";
    
    -- Decode decimal digit to 7-Segment-Signal
    FUNCTION decToSevenSeg(digit : UNSIGNED RANGE "0000" TO "1001" := "0000") 
        RETURN STD_ULOGIC_VECTOR IS
        VARIABLE ret : STD_ULOGIC_VECTOR(6 DOWNTO 0);
    BEGIN
        CASE digit IS
            WHEN "0000" => ret := "0111111";
            WHEN "0001" => ret := "0000110";
            WHEN "0010" => ret := "1011011";
            WHEN "0011" => ret := "1001111";
            WHEN "0100" => ret := "1100110";
            WHEN "0101" => ret := "1101101";
            WHEN "0110" => ret := "1111101";
            WHEN "0111" => ret := "0000111";
            WHEN "1000" => ret := "1111111";
            WHEN "1001" => ret := "1101111";
        END CASE;
        RETURN ret;
    END FUNCTION;
    
BEGIN

    sign1  <= UNSIGNED(value) MOD 10;
    sign10 <= UNSIGNED(value) / 10;  

    seven_seg_1 <= decToSevenSeg(sign1);
    seven_seg_10 <= decToSevenSeg(sign10);

END ARCHITECTURE;