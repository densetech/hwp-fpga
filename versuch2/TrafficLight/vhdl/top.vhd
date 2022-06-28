LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY top IS
	PORT (
		clock : IN STD_ULOGIC; -- 12 MHz

		KEY0 : IN STD_ULOGIC; -- asynchronous reset
		KEY1 : IN STD_ULOGIC; -- push button 0 on Cmod-Board, active high

		hex_1, hex_0 : OUT STD_ULOGIC_VECTOR(6 DOWNTO 0); -- 7-segments

		--LEDs on Cmod-S7-Board
		rgb_led_r, rgb_led_b, rgb_led_g : OUT STD_ULOGIC; -- RGB-LED
		led : OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE structural OF top IS
	COMPONENT clockgen IS
		PORT (
			clock : IN STD_ULOGIC;
			reset : IN STD_ULOGIC;

			clk_1hz : OUT STD_ULOGIC
		);
	END COMPONENT;
	
    COMPONENT trafficlight IS
    	PORT (
		    clk_in : IN STD_ULOGIC; -- 12 MHz

		    reset : IN STD_ULOGIC; -- asynchronous reset
		    key_in : IN STD_ULOGIC; -- push button 0 on Cmod-Board, active high
		    sec_in : IN STD_ULOGIC; -- one pulse every second

		    HS_red, HS_yellow, HS_green, NS_red, NS_yellow, NS_green : OUT STD_ULOGIC -- Ampeln
        );
    END COMPONENT;


	COMPONENT segmentdecoder IS
	    PORT (
		    red_in, yellow_in, green_in : IN STD_ULOGIC;
		    seven_seg : OUT STD_ULOGIC_VECTOR(6 DOWNTO 0)
	    );
	END COMPONENT;

	SIGNAL reset             : STD_ULOGIC; -- inverted reset signal
	SIGNAL clk_1hz_sig       : STD_ULOGIC;
	
	-- Ampel Signale
	SIGNAL HS_red_sig        : STD_ULOGIC;
	SIGNAL HS_yellow_sig     : STD_ULOGIC;
	SIGNAL HS_green_sig      : STD_ULOGIC;
	SIGNAL NS_red_sig        : STD_ULOGIC;
	SIGNAL NS_yellow_sig     : STD_ULOGIC;
	SIGNAL NS_green_sig      : STD_ULOGIC;

BEGIN
	clockgen_inst : clockgen
	PORT MAP(
		clock => clock,
		reset => reset,
		clk_1hz => clk_1hz_sig
	);
	
	trafficlight_inst : trafficlight
	PORT MAP(
		clk_in => clock,
		reset => reset,
		key_in => KEY1,
		sec_in => clk_1hz_sig,
		HS_red => HS_red_sig,
		HS_yellow => HS_yellow_sig,
		HS_green => HS_green_sig,
		NS_red => NS_red_sig,
		NS_yellow => NS_yellow_sig,
		NS_green => NS_green_sig 
	);	

	segmentdecoder_hs_inst : segmentdecoder
	PORT MAP(
		green_in => HS_green_sig,
		yellow_in => HS_yellow_sig,
		red_in => HS_red_sig,
		seven_seg => hex_1
	);
	
	segmentdecoder_ns_inst : segmentdecoder
	PORT MAP(
		green_in => NS_green_sig,
		yellow_in => NS_yellow_sig,
		red_in => NS_red_sig,
		seven_seg => hex_0
	);
	
	-- asynchronous reset (active low)
	reset <= KEY0;
	
	-- Onboard LEDs
	led <= "0000";
	rgb_led_r <= '0';
	rgb_led_b <= '0';
	rgb_led_g <= '0';

END ARCHITECTURE;
