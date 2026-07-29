library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier_3x3 is
    Port (
        clk          : in  STD_LOGIC;
        reset        : in  STD_LOGIC;
        start        : in  STD_LOGIC;
        multiplier   : in  STD_LOGIC_VECTOR(2 downto 0);
        multiplicand : in  STD_LOGIC_VECTOR(2 downto 0);
        product      : out STD_LOGIC_VECTOR(5 downto 0);
        done         : out STD_LOGIC
    );
end multiplier_3x3;

architecture Behavioral of multiplier_3x3 is

    signal load_sig, shift_sig, add_sig : STD_LOGIC;
    signal cnt_done_sig : STD_LOGIC;

    signal A_reg, A_in   : STD_LOGIC_VECTOR(2 downto 0);
    signal B_reg         : STD_LOGIC_VECTOR(2 downto 0);
    signal Q_reg, Q_in   : STD_LOGIC_VECTOR(2 downto 0);

    signal C_reg, C_in   : STD_LOGIC;

    signal adder_out     : STD_LOGIC_VECTOR(2 downto 0);
    signal cout_sig      : STD_LOGIC;

    signal shifted_A     : STD_LOGIC_VECTOR(2 downto 0);
    signal shifted_Q     : STD_LOGIC_VECTOR(2 downto 0);

    signal count         : unsigned(1 downto 0);

    -- FIX: rename DONE ? S_DONE
    type state_type is (S_IDLE, S_LOAD, S_CHECK, S_ADD, S_SHIFT, S_DONE);
    signal state, next_state : state_type;

begin

    ------------------------------------------------------------------------
    -- 3-bit Adder
    ------------------------------------------------------------------------
    adder_out <= std_logic_vector(unsigned(A_reg) + unsigned(B_reg));
    cout_sig  <= '1' when (unsigned(A_reg) + unsigned(B_reg)) > 7 else '0';

    ------------------------------------------------------------------------
    -- Right Shifter (C,A,Q)
    ------------------------------------------------------------------------
    shifted_Q(2) <= A_reg(0);
    shifted_Q(1) <= Q_reg(2);
    shifted_Q(0) <= Q_reg(1);

    shifted_A(2) <= C_reg;
    shifted_A(1) <= A_reg(2);
    shifted_A(0) <= A_reg(1);

    ------------------------------------------------------------------------
    -- FSM (Control Unit)
    ------------------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            state <= S_IDLE;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    process(state, start, Q_reg, cnt_done_sig)
    begin
        -- Default
        load_sig  <= '0';
        add_sig   <= '0';
        shift_sig <= '0';
        done      <= '0';
        next_state <= state;

        case state is
            when S_IDLE =>
                if start = '1' then
                    next_state <= S_LOAD;
                end if;

            when S_LOAD =>
                load_sig <= '1';
                next_state <= S_CHECK;

            when S_CHECK =>
                if Q_reg(0) = '1' then
                    next_state <= S_ADD;
                else
                    next_state <= S_SHIFT;
                end if;

            when S_ADD =>
                add_sig <= '1';
                next_state <= S_SHIFT;

            when S_SHIFT =>
                shift_sig <= '1';
                if cnt_done_sig = '1' then
                    next_state <= S_DONE;
                else
                    next_state <= S_CHECK;
                end if;

            when S_DONE =>
                done <= '1';
                next_state <= S_IDLE;

            when others =>
                next_state <= S_IDLE;
        end case;
    end process;


    ------------------------------------------------------------------------
    -- 2-bit Counter
    ------------------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' or load_sig = '1' then
            count <= (others => '0');
        elsif rising_edge(clk) and shift_sig = '1' then
            count <= count + 1;
        end if;
    end process;

    cnt_done_sig <= '1' when count = 2 else '0';

    ------------------------------------------------------------------------
    -- Registers A, B, Q
    ------------------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            A_reg <= (others => '0');
        elsif rising_edge(clk) then
            A_reg <= A_in;
        end if;
    end process;

    process(clk, reset)
    begin
        if reset = '1' then
            B_reg <= (others => '0');
        elsif rising_edge(clk) and load_sig = '1' then
            B_reg <= multiplicand;
        end if;
    end process;

    process(clk, reset)
    begin
        if reset = '1' then
            Q_reg <= (others => '0');
        elsif rising_edge(clk) then
            Q_reg <= Q_in;
        end if;
    end process;

    ------------------------------------------------------------------------
    -- Carry Register
    ------------------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            C_reg <= '0';
        elsif rising_edge(clk) then
            C_reg <= C_in;
        end if;
    end process;

    ------------------------------------------------------------------------
    -- Combinational Logic for A_in, Q_in, C_in
    ------------------------------------------------------------------------
    process(load_sig, add_sig, shift_sig, A_reg, Q_reg, C_reg,
            adder_out, cout_sig, shifted_A, shifted_Q, multiplier)
    begin
        A_in <= A_reg;
        Q_in <= Q_reg;
        C_in <= C_reg;

        if load_sig = '1' then
            A_in <= "000";
            Q_in <= multiplier;
            C_in <= '0';

        elsif add_sig = '1' then
            A_in <= adder_out;
            C_in <= cout_sig;

        elsif shift_sig = '1' then
            A_in <= shifted_A;
            Q_in <= shifted_Q;
            C_in <= '0';
        end if;
    end process;

    ------------------------------------------------------------------------
    -- Output Product
    ------------------------------------------------------------------------
    product <= A_reg & Q_reg;

end Behavioral;
