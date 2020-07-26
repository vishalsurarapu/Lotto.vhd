library ieee; 
use ieee.std_logic_1164.all; 
entity e_my_lottery is 
port( SW : in std_logic_vector (9 downto 0);
	CLOCK_50    : in  STD_LOGIC ;
	KEY: in std_logic_vector(3 downto 0); 
	LEDR: out std_logic_vector(9 downto 0); 
	HEX0:		out				std_logic_vector(0 to 6);
	HEX1:		out				std_logic_vector(0 to 6);
	HEX2:		out				std_logic_vector(0 to 6);
	HEX3:		out				std_logic_vector(0 to 6);
	HEX4:		out				std_logic_vector(0 to 6);
	HEX5:		out				std_logic_vector(0 to 6)
);
end entity e_my_lottery; 

architecture a_my_lottery of e_my_lottery is 
-- all signal assignments and component assignments 
-- declare the process signals and vriables slv_input_number

component e_flipflop
	   port ( sl_D, sl_Resetn, sl_Clock   : in   std_logic;
			  sl_Q                 		  : out  std_logic);
end component;

component e_FSM is 
   port (
		sl_reset: in    std_logic;
		sl_start: in std_logic;
		sl_clock: in    std_logic;
		slv_index_location: in std_logic_vector(2 downto 0);
		sl_value_is_equal: in std_logic;
		sl_load_values: out std_logic;
		sl_won: out std_logic;
		sl_move_next: out std_logic
	); -- needs to be instatiated to key 0 in the mother entity for reset
end component e_FSM;

component e_memory_block is
	port ( address    : in  std_logic_vector (4 downto 0);
			clock      : in  std_logic ;
			data       : in  std_logic_vector (3 downto 0);
			wren       : in  std_logic ;
			q          : out std_logic_vector (3 downto 0) );
end component;

component e_checkingNumber is 
	port(
		sl_clock: in std_logic;
		sl_resetn: in std_logic;
        sl_move_next: in std_logic;
        slv_address_to_memory : out std_logic_vector(4 downto 0);
        slv_data_from_memory : in std_logic_vector(3 downto 0);
		sl_value_is_equal: out std_logic;
		sl_finished: in std_logic;
		sl_load_values: in std_logic;
        slv_manualinput_value : in std_logic_vector(4 downto 0); -- manualinput
        slv_index_location: in std_logic_vector(2 downto 0)
	);
end component;

component e_manualinput is
	port(	slv_SW   : in  std_logic_vector(4 downto 0);
			slv_lotteryinput : out std_logic_vector(3 downto 0);
			slv_index : out std_logic_vector(2 downto 0);
			slv_whole_lotteryinput: out std_logic_vector(0 to 19);
			sl_start : in std_logic;
			sl_resetn : in std_logic;
			sl_clock : in std_logic);
end component;

component e_7seg_display is
    port(	sl_resetn, sl_start  : in std_logic;
            sl_won, sl_clock     : in std_logic;
            slv_index            : in std_logic_vector(2 downto 0);
            slv_whole_lotteryinput: in std_logic_vector(0 to 19);
            slv_7seg             : out std_logic_vector(0 to 41) 	);
end component e_7seg_display;

component e_modulo_counter_er is
	generic( n: natural := 4; k: integer := 15);
	port (	        sl_clock, sl_reset_n:	in std_logic;
			sl_enable:  in	std_logic;
			slv_Q:	    out     std_logic_vector(n-1 downto 0);
			sl_rollover: out std_logic 
			);
end component e_modulo_counter_er;

signal slv_manualinput_value_int, slv_data_from_memory_int: std_logic_vector(3 downto 0);
signal slv_address_int: std_logic_vector(4 downto 0);
signal slv_index_location_int: std_logic_vector(2 downto 0);
signal sl_resetn_int, sl_sync_int, sl_start_int : std_logic;
signal sl_is_won_int, sl_load_values_int: std_logic;
signal sl_value_is_equal_int : std_logic;
signal sl_move_next_int : std_logic;
signal slv_whole_lotteryinput_int: std_logic_vector(0 to 19);
signal sl_enable_int : std_logic := '1';
signal slv_SW_int : std_logic_vector(4 downto 0);
signal slv_7seg_int: std_logic_vector(0 to 41);

--signal sl_win_trigger_int : std_logic; -- indicates that the player has won (can be generated inside the FSM)
signal sl_one_sec_en_int  :  std_logic;
signal slv_led_on_off_int :  std_logic_vector (9 downto 0) ; 

begin 
	sl_resetn_int <= KEY(0); --reset button !! change it to desire


	HEX5 <= slv_7seg_int(0 to 6);
	HEX4 <= slv_7seg_int(7 to 13);
	HEX3 <= slv_7seg_int(14 to 20);
	HEX2 <= slv_7seg_int(21 to 27);
	HEX1 <= slv_7seg_int(28 to 34);
    HEX0 <= slv_7seg_int(35 to 41);
    
	-- we need to add flipflops to avoid time gaps in sync data as explained in courses
	I_SYNCFF1: e_flipflop port map (SW(9), sl_resetn_int, CLOCK_50, sl_sync_int); -- Sw(9) goes into sl_sync_int when sl_resetn_int is not 0
	I_SYNCFF2: e_flipflop port map (sl_sync_int, sl_resetn_int, CLOCK_50, sl_start_int); -- sl_sync_int goes into start when sl_resetn_int is not 0
	-- So basically SW(9) goes into sl_start_int so its our start 
	-- ofc we can change it or even change the logic just wanted to have a first logic

	I_MANUAL_INPUT: e_manualinput port map(
		slv_SW => SW(4 downto 0),
		slv_lotteryinput => slv_manualinput_value_int,
		slv_index => slv_index_location_int,
		slv_whole_lotteryinput => slv_whole_lotteryinput_int,
		sl_start => sl_start_int,
		sl_resetn => sl_resetn_int,
		sl_clock => CLOCK_50
	);

	
	I_MEM: e_memory_block port map(
		address => slv_address_int,
		data => "0000",
		clock => CLOCK_50,
		wren => '0',
		q => slv_data_from_memory_int);

	I_FSM: e_FSM port map(
		sl_clock => CLOCK_50,
		sl_reset => sl_resetn_int,
		sl_start => sl_start_int,
		sl_won => sl_is_won_int,
		sl_value_is_equal => sl_value_is_equal_int,
		sl_load_values => sl_load_values_int,
		slv_index_location => slv_index_location_int,
		sl_move_next => sl_move_next_int
	);

	I_CHECKINGNUMBER: e_checkingNumber port map(
		sl_clock => CLOCK_50,
		sl_resetn => sl_resetn_int,
		sl_move_next => sl_move_next_int,
		sl_finished => sl_is_won_int,
		slv_address_to_memory => slv_address_int,
		slv_data_from_memory => slv_data_from_memory_int,
		slv_index_location => slv_index_location_int,
		sl_load_values => sl_load_values_int,
		sl_value_is_equal => sl_value_is_equal_int,
		slv_manualinput_value => slv_manualinput_value_int
	);

	I_7seg_display: e_7seg_display port map(
		sl_resetn => sl_resetn_int, 
		sl_start => sl_start_int,
		sl_won => sl_is_won_int,
		sl_clock => CLOCK_50,
		slv_index => slv_index_location_int,
		slv_whole_lotteryinput => slv_whole_lotteryinput_int,
		slv_7seg => slv_7seg_int
    );
    
-- this part is a process that calls a modulo counter and display a flash of light using LEDR with an interval of 1 sec once the winning trigger signal is activated (=1)  
	
	

slv_led_on_off_int <= "0000000000"; -- initial value

I_slow_clock: e_modulo_counter_er 
    generic map	(	n => 26, k => 50000000)
    port map	(	sl_clock	=>		CLOCK_50,
                    sl_reset_n	=>		KEY(0),
                    sl_enable	=>		sl_enable_int,
                    slv_Q		=>		open,
                    sl_rollover	=>		sl_one_sec_en_int
                );
p_mod_cnt: process(sl_clock_int, sl_resetn_int, sl_win_trigger_int)

begin 
if sl_resetn_int ='0' then -- low active reset using key
     slv_led_on_off_int <= "0000000000"; 
elsif (sl_win_trigger_int = '1') and ( sl_resetn_int = '1')  then 
    if(rising_edge(sl_clock_int)) then
        if(sl_enable_int ='1') then
        
            if slv_led_on_off_int = "0000000000" then 
                slv_led_on_off_int <= "1111111111"; 
            else 
                slv_led_on_off_int <= "0000000000"; 
            end if ; 
        end if ;
    end if ;
end if ; 


end process p_mod_cnt ;

end architecture a_my_lottery;
