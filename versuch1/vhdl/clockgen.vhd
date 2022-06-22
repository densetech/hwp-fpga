LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY clockgen IS
	PORT (
	   clock     : in STD_ULOGIC; -- 12 MHz
	   reset     : in STD_ULOGIC;
	   
	   clk_1hz   : out STD_ULOGIC
	);
END ENTITY;

ARCHITECTURE rtl OF clockgen IS
    SIGNAL clk_1hz_sig : STD_LOGIC := '1';
    
    BEGIN
    
    clk_1hz <= STD_ULOGIC(clk_1hz_sig);

    clockgen_proc : PROCESS (clock, reset) 
    VARIABLE counter : NATURAL := 0;
    BEGIN
        IF reset = '1' THEN
            counter := 0;
            clk_1hz_sig <= '1';
        ELSIF RISING_EDGE(clock) THEN
            IF counter = 12000000 THEN --the value is related to the clock's actual frequency
                clk_1hz_sig <= NOT clk_1hz_sig;
                counter := 0;
            END IF;
            counter := counter + 1;
        END IF;
    END PROCESS;
    
END ARCHITECTURE;
