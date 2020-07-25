library ieee; 
use ieee.std_logic_1164.all; 
entity e_my_lotto is 
port( SW : in std_logic_vector (9 downto 0);
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

component e_FSM is 
   port (
		sl_resetn: in    std_logic; 
		sl_start: in    std_logic; 
		sl_clock: in    std_logic;
		slv_index_location: in std_logic_vector(2 downto 0);
		sl_value_is_equal: in std_logic;
		sl_load_values: out std_logic;
		sl_move_next: out std_logic
		sl_won: out std_logic;
		sl_move_next: out std_logic
	); -- needs to be instatiated to key 0 in the mother entity for reset
end component FSM;

component e_memory_block is
	port ( address    : in  std_logic_vector (4 downto 0);
			clock      : in  std_logic ;
			data       : in  std_logic_vector (7 downto 0);
			wren       : in  std_logic ;
			q          : out std_logic_vector (7 downto 0) );
end component;

component e_checkingNumber is 
	port(
		sl_clock: in std_logic;
		sl_resetn: in std_logic;
        sl_move_next: in std_logic;
        slv_address_to_memory : out std_logic_vector(4 downto 0);
        slv_data_from_memory : in std_logic_vector(4 downto 0);
		sl_value_is_equal: out std_logic;
		sl_finished: in std_logic;
        sl_won: out std_logic;
        slv_manualinput_value : in std_logic_vector(4 downto 0); -- manualinput
        slv_index_location: out std_logic_vector(2 downto 0)
	);
end component;

signal slv_manualinput_value_int, slv_data_from_memory_int: std_logic_vector(4 downto 0);
signal slv_address_int: std_logic_vector(4 downto 0);
signal slv_index_location_int: std_logic_vector(2 downto 0);
signal sl_resetn_int, sl_sync_int, sl_start_int : std_logic;
signal sl_is_won_int, sl_load_values_int: std_logic;
signal sl_value_is_equal_int : std_logic;
signal sl_move_next_int : std_logic;



begin 
	sl_resetn_int <= KEY(0); --reset button !! change it to desire


	-- we need to add flipflops to avoid time gaps in sync data as explained in courses
	I_SYNCFF1: e_flipflop port map (SW(9), sl_resetn_int, CLOCK_50, sl_sync_int); -- Sw(9) goes into sl_sync_int when sl_resetn_int is not 0
	I_SYNCFF2: e_flipflop port map (sl_sync_int, sl_resetn_int, CLOCK_50, sl_start_int); -- sl_sync_int goes into start when sl_resetn_int is not 0
	-- So basically SW(9) goes into sl_start_int so its our start 
	-- ofc we can change it or even change the logic just wanted to have a first logic

	I_MEM: e_memory_block port map(
		address => slv_address_int,
		data => "00000000",
		clock => CLOCK_50,
		wren => '0',
		q => slv_data_from_memory_int);

	I_FSM: e_FSM port map(
		sl_clock => CLOCK_50,
		sl_resetn => sl_resetn_int,
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
		sl_won => LEDR(9), -- user won now we just show a LED !! This is going to be changed afterward
		slv_address_to_memory => slv_address_int,
		slv_data_from_memory => slv_data_from_memory_int,
		slv_index_location => slv_index_location_int,
		sl_value_is_equal => sl_value_is_equal_int,
		slv_manualinput_value => slv_manualinput_value_int
	);
end architecture a_my_lotto;