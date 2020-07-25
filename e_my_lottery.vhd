library ieee; 
use ieee.std_logic_1164.all; 
entity e_my_lotto is 
port(   CLOCK_50 :in std_logic; 
	SW : in std_logic_vector (9 downto 0);
	KEY: in std_logic_vector(3 downto 0); 
	LEDR: out std_logic_vector(9 downto 0); 
	HEX0:		out				std_logic_vector(0 to 6);
	HEX1:		out				std_logic_vector(0 to 6);
	HEX2:		out				std_logic_vector(0 to 6);
	HEX3:		out				std_logic_vector(0 to 6);
	HEX4:		out				std_logic_vector(0 to 6);
	HEX5:		out				std_logic_vector(0 to 6)
);
end entity e_my_lotto; 

architecture a_my_lotto of e_my_lotto is 
-- all signal assignments and component assignments 
-- declare the process signals and vriables slv_input_number

component e_winning_FSM is 
   port (   slv_input_number   : in    std_logic_vector(4 downto 0);
            KEY_signal         : in    std_logic_vector(3 downto 0);
            LEDR_Sginal        : out   std_logic_vector(9 downto 0));  
end component e_winning_FSM;

component e_modulo_counter_er is
	generic( n: natural := 4; k: integer := 15);
	port (	        sl_clock, sl_reset_n:	in std_logic;
			sl_enable:  in	std_logic;
			slv_Q:	    out     std_logic_vector(n-1 downto 0);
			sl_rollover: out std_logic );
end component e_modulo_counter_er;







	
	
	
	
	
	
	
	
	
	
-- this part is a process that calls a modulo counter and display a flash of light using LEDR with an interval of 1 sec once the winning trigger signal is activated (=1)  
	
	
signal sl_win_trigger_int : std_logic; -- indicates that the player has won (can be generated inside the FSM)
signal sl_one_sec_en_int  :  std_logic;
signal slv_led_on_off_int :  std_logic_vector (9 downto 0) ; 
slv_led_on_off_int <= "0000000000"; -- initial value

I_slow_clock: e_modulo_counter_er 
		generic map	(	n => 26, k => 50000000)
		port map	(	sl_clock	=>		CLOCK_50,
						sl_reset_n	=>		KEY(0),
						sl_enable	=>		'1',
						slv_Q		=>		open,
						sl_rollover	=>		sl_one_sec_en_int
						
);
   p_mod_cnt: process(sl_clock, sl_reset_n, sl_win_trigger_int)
  
    begin 
	if sl_reset_n ='0' then -- low active reset using key
	then slv_led_on_off_int = "0000000000"; 
	elsif (sl_win_trigger_int = '1') and ( sl_reset_n= '1')  then 
	if(rising_edge(sl_clock)) then
	if slv_led_on_off_int = "0000000000" then 
     slv_led_on_off_int = "1111111111"; 
    else 
    slv_led_on_off_int = "0000000000"; 
    end if ; 
end if ; 
end if ; 

end process p_mod_cnt ;
