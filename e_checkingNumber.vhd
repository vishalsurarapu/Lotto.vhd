library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity e_checkingNumber is
    port(
        sl_clock, sl_resetn: in std_logic;
        sl_move_next: in std_logic;
        slv_address_to_memory : out std_logic_vector(4 downto 0);
        slv_data_from_memory : in std_logic_vector(3 downto 0);
        sl_value_is_equal: out std_logic;
        sl_load_values: in std_logic;
        sl_finished: in std_logic;
        slv_manualinput_value : in std_logic_vector(3 downto 0); -- manualinput
        slv_index_location: in std_logic_vector(2 downto 0)
    );
end entity e_checkingNumber;

architecture a_checkingNumber of e_checkingNumber is

    signal slv_value_reg_int : std_logic_vector(3 downto 0); -- now defined as 8 bit value but gonna be changed 

begin
    p_checkNumber: process(sl_clock, sl_resetn)
    begin
        if(sl_resetn ='0') then
            --reset all vauels to initials
            slv_value_reg_int <= (others => '0');
        elsif (rising_edge(sl_clock)) then
            if(sl_load_values = '1') then
                -- load values from memory and input and therefore change sl_value_is_equal
                slv_value_reg_int <= slv_manualinput_value;
            end if;
        end if;
    end process p_checkNumber;

-- concurrent Signal Assignments:

    slv_address_to_memory <= "00" & slv_index_location ; 
    sl_value_is_equal <= '1' when (slv_data_from_memory = slv_value_reg_int) else '0';

end architecture a_checkingNumber;