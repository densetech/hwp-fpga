LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY trafficlight IS
	PORT (
		clk_in : IN STD_ULOGIC; -- 12 MHz

		reset : IN STD_ULOGIC; -- asynchronous reset
		key_in : IN STD_ULOGIC; -- push button 0 on Cmod-Board, active high
		sec_in : IN STD_ULOGIC; -- one pulse every second

		HS_red, HS_yellow, HS_green, NS_red, NS_yellow, NS_green : OUT STD_ULOGIC -- Ampeln

	);
END ENTITY;
    
ARCHITECTURE rtl OF trafficlight IS
    TYPE state_t IS (s0, s1, s1a, s2, s3, s4, s5, s5a, s5b, s6, s7, s8);
    SIGNAL state, state_next : state_t;
    
BEGIN

    fsm_seq : PROCESS(clk_in, reset)
    BEGIN
        IF reset = '1' THEN
            state <= s0;
        ELSIF RISING_EDGE(clk_in) THEN
            IF key_in = '1' AND state = s0 THEN
                state <= s1;
            END IF;
            IF sec_in = '1' THEN
                state <= state_next;
            END IF;
        END IF;
    END PROCESS;

    fsm_comb : PROCESS(state, key_in)
    BEGIN
    
        state_next <= state;
        
        HS_red <= '0';
        HS_yellow <= '0';
        HS_green <= '0';
        NS_red <= '0';
        NS_yellow <= '0';
        NS_green <= '0';
        
        CASE state IS
            WHEN s0 =>
                HS_green <= '1';
                NS_red <= '1';
                IF key_in = '1' THEN
                    state_next <= s1;
                END IF;
            WHEN s1 =>
                HS_green <= '1';
                NS_red <= '1';
                state_next <= s1a;
            WHEN s1a =>
                HS_green <= '1';
                NS_red <= '1';
                state_next <= s2;
            WHEN s2 =>
                HS_yellow <= '1';
                NS_red <= '1';
                state_next <= s3;
            WHEN s3 =>
                HS_red <= '1';
                NS_red <= '1';
                state_next <= s4;
            WHEN s4 =>
                HS_red <= '1';
                NS_red <= '1';
                NS_yellow <= '1';
                state_next <= s5;
            WHEN s5 =>
                HS_red <= '1';
                NS_green <= '1';
                state_next <= s5a;
            WHEN s5a =>
                HS_red <= '1';
                NS_green <= '1';
                state_next <= s5b;
            WHEN s5b =>
                HS_red <= '1';
                NS_green <= '1';
                state_next <= s6;
            WHEN s6 =>
                HS_red <= '1';
                NS_yellow <= '1';
                state_next <= s7;
            WHEN s7 =>
                HS_red <= '1';
                NS_red <= '1';
                state_next <= s8;
            WHEN s8 =>
                HS_red <= '1';
                HS_yellow <= '1';
                NS_red <= '1';
                state_next <= s0;
        END CASE;
    END PROCESS;

END ARCHITECTURE;