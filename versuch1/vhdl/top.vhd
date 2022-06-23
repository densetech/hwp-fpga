------------------------------------------
-- TODO: implement synchronous deassertion
--       of reset
------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY top IS
	GENERIC (
	    CLOCK_FREQ : NATURAL := 12000000 -- in MHz
	);
	PORT (
		clock : IN STD_ULOGIC; -- 12 MHz

		reset_n : IN STD_ULOGIC; -- asynchronous reset
		sws : IN STD_ULOGIC_VECTOR(3 DOWNTO 0); -- switches for preset input

		led_g : OUT STD_ULOGIC; -- green LED for 1 Hz blink
		leds_r : OUT STD_ULOGIC_VECTOR(3 DOWNTO 0); -- 4 red LEDs for binary count
		hex_1, hex_0 : OUT STD_ULOGIC_VECTOR(6 DOWNTO 0); -- 7-segments

		--LEDs on Cmod-S7-Board
		led0_r, led0_g, led0_b : OUT STD_ULOGIC; -- RGB-LED
		led : OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE structural OF top IS
	COMPONENT clockgen IS
    	GENERIC (
	        CLOCK_FREQ : NATURAL := 12000000 -- in MHz
	    );
		PORT (
			clock : IN STD_ULOGIC;
			reset : IN STD_ULOGIC;

			clk_1hz : OUT STD_ULOGIC
		);
	END COMPONENT;

	COMPONENT counter IS
		PORT (
			clock : IN STD_ULOGIC;
			reset : IN STD_ULOGIC;
			preset : IN STD_ULOGIC_VECTOR(3 DOWNTO 0);

			count : OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT segmentdecoder IS
		PORT (
			value : IN STD_ULOGIC_VECTOR(3 DOWNTO 0);

			seven_seg_10 : OUT STD_ULOGIC_VECTOR(6 DOWNTO 0); -- 10er-Ziffernanzeige
			seven_seg_1 : OUT STD_ULOGIC_VECTOR(6 DOWNTO 0) -- 1er-Ziffernanzeige
		);
	END COMPONENT;

	SIGNAL reset : STD_ULOGIC; -- inverted reset signal
	SIGNAL preset_sig : STD_ULOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL clk_1hz_sig : STD_ULOGIC;
	SIGNAL count_sig : STD_ULOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	clockgen_inst : clockgen
	GENERIC MAP (
	    CLOCK_FREQ => CLOCK_FREQ
	)
	PORT MAP(
		clock => clock,
		reset => reset,
		clk_1hz => clk_1hz_sig
	);

	counter_inst : counter
	PORT MAP(
		clock => clk_1hz_sig,
		reset => reset,
		preset => preset_sig,
		count => count_sig
	);

	segmentdecoder_inst : segmentdecoder
	PORT MAP(
		value => count_sig,
		seven_seg_10 => hex_1,
		seven_seg_1 => hex_0
	);

	-- invert signals because of external pull ups
	reset <= NOT reset_n;
	preset_sig <= NOT sws;
	led_g <= NOT clk_1hz_sig;
	leds_r <= NOT count_sig;

	--OnBoard LEDs
	led0_r <= '1'; --RGB-LED, active low
	led0_b <= '1';
	led0_g <= '1';
	led    <= "0000"; --4 yellow LEDs, active high
END ARCHITECTURE;
