library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity digital_lock is
    Port ( 
        clk        : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        key_input  : in  STD_LOGIC_VECTOR (3 downto 0);
        enter      : in  STD_LOGIC;
        unlocked   : out STD_LOGIC;
        alarm      : out STD_LOGIC
    );
end digital_lock;

architecture Behavioral of digital_lock is
    type state_type is (IDLE, ENTERING_PASS, SUCCESS, ALARM_STATE);
    signal current_state, next_state : state_type;
    
    -- Let's set the correct combination passcode as "1100" (or 12 in decimal)
    constant SECRET_PASSWORD : STD_LOGIC_VECTOR(3 downto 0) := "1100";
begin

    -- State Transition Clock Process
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= IDLE;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Next State and Output Logic Process
    process(current_state, key_input, enter)
    begin
        -- Default Outputs
        unlocked <= '0';
        alarm <= '0';
        next_state <= current_state;

        case current_state is
            when IDLE =>
                if enter = '1' then
                    next_state <= ENTERING_PASS;
                end if;

            when ENTERING_PASS =>
                if enter = '1' then
                    if key_input = SECRET_PASSWORD then
                        next_state <= SUCCESS;
                    else
                        next_state <= ALARM_STATE;
                    end if;
                end if;

            when SUCCESS =>
                unlocked <= '1';
                if reset = '1' then
                    next_state <= IDLE;
                end if;

            when ALARM_STATE =>
                alarm <= '1';
                if reset = '1' then
                    next_state <= IDLE;
                end if;
                
            when others =>
                next_state <= IDLE;
        end case;
    end process;

end Behavioral;