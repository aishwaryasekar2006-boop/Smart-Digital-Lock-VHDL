library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.env.finish; -- Needed for VHDL-2008 to stop simulation automatically

entity tb_digital_lock is
-- Testbenches have no ports
end tb_digital_lock;

architecture behavior of tb_digital_lock is

    -- Component Declaration for the Unit Under Test (UUT)
    component digital_lock
    Port ( 
        clk        : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        key_input  : in  STD_LOGIC_VECTOR (3 downto 0);
        enter      : in  STD_LOGIC;
        unlocked   : out STD_LOGIC;
        alarm      : out STD_LOGIC
    );
    end component;
    
    -- Signals to connect to the lock
    signal clk        : STD_LOGIC := '0';
    signal reset      : STD_LOGIC := '0';
    signal key_input  : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal enter      : STD_LOGIC := '0';
    signal unlocked   : STD_LOGIC;
    signal alarm      : STD_LOGIC;

    -- Clock period constant
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: digital_lock PORT MAP (
          clk => clk,
          reset => reset,
          key_input => key_input,
          enter => enter,
          unlocked => unlocked,
          alarm => alarm
        );

    -- Clock generation process
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
 

    -- Stimulus process to test the hardware
    stim_proc: process
    begin		
        -- Step 1: Initialize System with Reset
        reset <= '1';
        wait for 20 ns;	
        reset <= '0';
        wait for clk_period;

        -- Step 2: Test Correct Password Sequence ("1100")
        enter <= '1'; -- Move to entering pass state
        wait for clk_period;
        enter <= '0';
        wait for clk_period;
        
        key_input <= "1100"; -- Provide correct code
        enter <= '1';
        wait for clk_period;
        enter <= '0';
        wait for 40 ns; -- Observe "unlocked" output turning high

        -- Step 3: Reset back to Idle
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;

        -- Step 4: Test Incorrect Password Sequence ("0111")
        enter <= '1';
        wait for clk_period;
        enter <= '0';
        wait for clk_period;
        
        key_input <= "0111"; -- Provide wrong code
        enter <= '1';
        wait for clk_period;
        enter <= '0';
        wait for 40 ns; -- Observe "alarm" output turning high

        -- End simulation safely
        finish;
    end process;

end behavior;