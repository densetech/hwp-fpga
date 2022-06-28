LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY segmentdecoder IS
	PORT (
		red_in, yellow_in, green_in : IN STD_ULOGIC;
		seven_seg : OUT STD_ULOGIC_VECTOR(6 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE rtl OF segmentdecoder IS

    SIGNAL value : STD_ULOGIC_VECTOR(1 DOWNTO 0) := "00";

BEGIN
    -- 00: green, 01: yellow, 10: red, 11: red-yellow
    value <= "00" WHEN green_in = '1' AND yellow_in = '0' AND red_in = '0' ELSE
             "01" WHEN green_in = '0' AND yellow_in = '1' AND red_in = '0' ELSE
             "10" WHEN green_in = '0' AND yellow_in = '0' AND red_in = '1' ELSE
             "11" WHEN green_in = '0' AND yellow_in = '1' AND red_in = '1' ELSE
             "00";
             
    WITH value SELECT seven_seg <=
	    "0001000" WHEN "00",
	    "1000000" WHEN "01",
	    "0000001" WHEN "10",
	    "1000001" WHEN "11";
	
END ARCHITECTURE;
