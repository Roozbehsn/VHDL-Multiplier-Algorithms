library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier_3x3_tb is
end multiplier_3x3_tb;

architecture TB_ARCHITECTURE of multiplier_3x3_tb is

    -- Component declaration
    component multiplier_3x3
        port(
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            start : in STD_LOGIC;
            multiplier : in STD_LOGIC_VECTOR(2 downto 0);
            multiplicand : in STD_LOGIC_VECTOR(2 downto 0);
            product : out STD_LOGIC_VECTOR(5 downto 0);
            done : out STD_LOGIC
        );
    end component;

    -- Signals
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal start : STD_LOGIC := '0';
    signal multiplier : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal multiplicand : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal product : STD_LOGIC_VECTOR(5 downto 0);
    signal done : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate Unit Under Test
    UUT: multiplier_3x3
        port map(
            clk => clk,
            reset => reset,
            start => start,
            multiplier => multiplier,
            multiplicand => multiplicand,
            product => product,
            done => done
        );

    -- Clock generation
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
        variable expected : STD_LOGIC_VECTOR(5 downto 0);
    begin
        -- Reset system
        reset <= '1';
        wait for CLK_PERIOD*2;
        reset <= '0';
        wait for CLK_PERIOD;

        -- Test Case 1: 3 * 3 = 9
        multiplier <= "011";  -- 3
        multiplicand <= "011"; -- 3
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        wait until done = '1';
        wait for CLK_PERIOD;

        expected := "001001";  -- 9 in 6 bits
        assert product = expected
            report "Test Case 1 Failed: 3*3 != 9"
            severity error;

        wait;
    end process;

end TB_ARCHITECTURE;
