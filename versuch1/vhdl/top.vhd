LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY top IS
	PORT (
	    clock        : in std_ulogic; -- 12 MHz
	   
	    reset_n      : in std_ulogic; -- asynchronous reset
	    sws          : in std_ulogic_vector(3 DOWNTO 0); -- switches for preset
	   
	    led_g        : out std_ulogic; -- green LED for enable signal (1 Hz)
	    leds_r       : out std_ulogic_vector(3 DOWNTO 0); -- 4 red LEDs for binary count
	    hex_1, hex_0 : out std_ulogic_vector(6 DOWNTO 0); -- 7-segments
	    
	    --LEDs on Cmod-S7-Board
	    led0_r, led0_g, led0_b : out std_ulogic; -- RGB-LED
	    led                    : out std_ulogic_vector(3 downto 0)
	);
END ENTITY;

ARCHITECTURE structural OF top IS
    COMPONENT clockgen IS
	    PORT (
	       clock     : in std_ulogic;
	       reset     : in std_ulogic;
	       
	       clk_1hz   : out std_ulogic
	    );
    END COMPONENT;
    
    COMPONENT counter IS
        PORT (
	        clock    : IN STD_ULOGIC;
	        reset    : IN STD_ULOGIC;
	        preset : IN STD_ULOGIC_VECTOR(3 DOWNTO 0);
	   
	        count : OUT STD_ULOGIC_VECTOR(3 DOWNTO 0)
	    );
    END COMPONENT;
    
    COMPONENT segmentdecoder IS
        PORT (
	        value        : IN STD_ULOGIC_VECTOR(3 DOWNTO 0);
	   
	        seven_seg_10 : OUT STD_ULOGIC_VECTOR(6 DOWNTO 0); -- 10er-Ziffernanzeige
	        seven_seg_1  : OUT STD_ULOGIC_VECTOR(6 DOWNTO 0) -- 1er-Ziffernanzeige
	    );
    END COMPONENT;
    
    SIGNAL reset       : STD_ULOGIC; -- inverted reset signal
    SIGNAL preset_sig  : STD_ULOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL clk_1hz_sig : STD_ULOGIC;
    SIGNAL count_sig   : STD_ULOGIC_VECTOR(3 DOWNTO 0);
BEGIN

    clockgen_inst : clockgen
        PORT MAP (
            clock => clock,
            reset => reset,
            clk_1hz => clk_1hz_sig
        ); 
        
    counter_inst: counter
        PORT MAP (
            clock => clk_1hz_sig,
            reset => reset,
            preset => preset_sig,
            count => count_sig
        ); 
        
    segmentdecoder_inst: segmentdecoder
        PORT MAP (
	        value => count_sig,
	        seven_seg_10  => hex_1,
	        seven_seg_1  => hex_0
	    );
	
	reset      <= NOT reset_n;
	preset_sig <= "1111" XOR sws;
	led_g      <= NOT clk_1hz_sig; -- to invert LED (Pull-Up)
    leds_r     <= "1111" XOR count_sig;
    
    --OnBoard LEDs
    led0_r <= '1'; --active low
    led0_b <= '1';
    led0_g <= '1';
    
    led <= "0000";
END ARCHITECTURE;