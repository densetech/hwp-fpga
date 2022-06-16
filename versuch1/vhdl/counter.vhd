LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY counter IS
    PORT (
	   clock    : IN STD_ULOGIC; -- 1Hz
	   reset    : IN STD_ULOGIC; -- reset count value
	   preset   : IN STD_ULOGIC_VECTOR(3 DOWNTO 0);
	   
	   count    : OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE rtl OF counter IS
    SIGNAL count_sig : STD_ULOGIC_VECTOR(3 DOWNTO 0) := preset;

BEGIN

    count <= count_sig;

    count_proc : PROCESS (clock, reset)
        BEGIN    
        IF reset = '1' THEN
            count_sig <= preset;
        ELSIF RISING_EDGE(clock) THEN
            count_sig <= STD_ULOGIC_VECTOR(UNSIGNED(count_sig) + 1);
        END IF;
    END PROCESS;
    
END ARCHITECTURE;