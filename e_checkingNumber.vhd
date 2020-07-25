library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity e_checkingNumber is
    port(
        sl_clock, sl_resetn: in std_logic;
        sl_check_next_number: in std_logic;
        slv_input_number: in std_logic_vector(7 downto 0);
        slv_address_to_memory : out std_logic_vector(4 downto 0);
        slv_data_from_memory : in std_logic_vector(7 downto 0);
        sl_value_is_equal: out std_logic;
        sl_found_out: out std_logic;
        slv_manualinput_value : in std_logic_vector(4 downto 0); -- manualinput
    );
end entity e_checkingNumber;

architecture a_checkingNumber of e_checkingNumber is

    signal slv_value_reg_int : std_logic_vector(4 downto 0); -- now defined as 8 bit value but gonna be changed 
    signal sl_found_reg_int  : std_logic;
    signal slv_index_location_int : std_logic_vector(2 downto 0);

begin
    p_checkNumber: process(sl_clock, sl_resetn)
    begin
        if(sl_resetn ='0') then
            --reset all vauels to initials
            slv_value_reg_int <= (others => '0');
            sl_found_reg_int <= (others => '0');
            slv_index_location_int <= (others => '0');
        elsif (rising_edge(sl_clock)) then
            if(sl_load_values = '1') then
                -- load values from memory and input
                slv_value_reg_int <= slv_manualinput_value;
                sl_found_reg_int <=  '0';
            else
                -- compare the numbers from memory and also input 
                if(sl_move_next = '1') then
                    slv_index_location_int <= std_logig_vector(unsigned(slv_index_location_int) + 1);
                    --loading numbers for next step
                end if;
                if(sl_won = '1') then
                    --user won
                    sl_found_reg_int <= '1';
                end if;
            end if;
        end if;
    end process p_checkNumber;

-- concurrent Signal Assignments:
    slv_address_to_memory <= '00' & slv_index_location_int ; -- for now i dont know how to address memory
    sl_value_is_equal <= '1' when (slv_data_from_memory = slv_value_reg_int) else '0';
    sl_found_out <= sl_found_reg_int;

end architecture a_checkingNumber;