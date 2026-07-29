
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplier4bit is
 port ( 
    A: in STD_LOGIC_VECTOR (3 downto 0);
	B: in STD_LOGIC_VECTOR (3 downto 0);
	S: out STD_LOGIC_VECTOR (7 downto 0)
);
end multiplier4bit;
 
architecture Behavioral of multiplier4bit is
 
-- Intermediate signal declarations (as in the original code)
signal AB0, AB1, AB2, AB3: STD_LOGIC_VECTOR (3 downto 0);
signal C1, C2, C3: STD_LOGIC_VECTOR (3 downto 0);
signal P1, P2, P3: STD_LOGIC_VECTOR (3 downto 0);

begin
    
-- --- Part 1: Partial Product Generation (AND gates) ---
-- This part remains identical to your original code.

AB0(0) <= A(0) and B(0);
AB0(1) <= A(1) and B(0);
AB0(2) <= A(2) and B(0);
AB0(3) <= A(3) and B(0);

AB1(0) <= A(0) and B(1);
AB1(1) <= A(1) and B(1);
AB1(2) <= A(2) and B(1);
AB1(3) <= A(3) and B(1);

AB2(0) <= A(0) and B(2);
AB2(1) <= A(1) and B(2);
AB2(2) <= A(2) and B(2);
AB2(3) <= A(3) and B(2);

AB3(0) <= A(0) and B(3);
AB3(1) <= A(1) and B(3);
AB3(2) <= A(2) and B(3);
AB3(3) <= A(3) and B(3);

-- --- Part 2: Adder Logic (Replacing Component Instantiations) ---
-- HA_S (Half Adder Sum) = A XOR B
-- HA_C (Half Adder Carry) = A AND B
-- FA_S (Full Adder Sum) = A XOR B XOR Cin
-- FA_C (Full Adder Carry) = (A AND B) OR (Cin AND A) OR (Cin AND B)

-- HA1: half_adder_vhdl_code port map( AB0(1), AB1(0), C1(0), P1(0));
P1(0) <= AB0(1) xor AB1(0);      -- S
C1(0) <= AB0(1) and AB1(0);      -- Cout

-- FA1: full_adder_vhdl_code port map( AB0(2), AB1(1), C1(0), C1(1), P1(1));
P1(1) <= AB0(2) xor AB1(1) xor C1(0);    -- S
C1(1) <= (AB0(2) and AB1(1)) or (C1(0) and AB0(2)) or (C1(0) and AB1(1)); -- Cout

-- FA2: full_adder_vhdl_code port map( AB0(3), AB1(2), C1(1), C1(2), P1(2));
P1(2) <= AB0(3) xor AB1(2) xor C1(1);    -- S
C1(2) <= (AB0(3) and AB1(2)) or (C1(1) and AB0(3)) or (C1(1) and AB1(2)); -- Cout

-- HA2: half_adder_vhdl_code port map( AB1(3), C1(2), C1(3), P1(3));
P1(3) <= AB1(3) xor C1(2);       -- S
C1(3) <= AB1(3) and C1(2);       -- Cout

-- HA3: half_adder_vhdl_code port map( P1(1), AB2(0), C2(0), P2(0));
P2(0) <= P1(1) xor AB2(0);       -- S
C2(0) <= P1(1) and AB2(0);       -- Cout

-- FA3: full_adder_vhdl_code port map( P1(2), AB2(1), C2(0), C2(1), P2(1));
P2(1) <= P1(2) xor AB2(1) xor C2(0);    -- S
C2(1) <= (P1(2) and AB2(1)) or (C2(0) and P1(2)) or (C2(0) and AB2(1)); -- Cout

-- FA4: full_adder_vhdl_code port map( P1(3), AB2(2), C2(1), C2(2), P2(2));
P2(2) <= P1(3) xor AB2(2) xor C2(1);    -- S
C2(2) <= (P1(3) and AB2(2)) or (C2(1) and P1(3)) or (C2(1) and AB2(2)); -- Cout

-- FA5: full_adder_vhdl_code port map( C1(3), AB2(3), C2(2), C2(3), P2(3));
P2(3) <= C1(3) xor AB2(3) xor C2(2);    -- S
C2(3) <= (C1(3) and AB2(3)) or (C2(2) and C1(3)) or (C2(2) and AB2(3)); -- Cout

-- HA4: half_adder_vhdl_code port map( P2(1), AB3(0), C3(0), P3(0));
P3(0) <= P2(1) xor AB3(0);       -- S
C3(0) <= P2(1) and AB3(0);       -- Cout

-- FA6: full_adder_vhdl_code port map( P2(2), AB3(1), C3(0), C3(1), P3(1));
P3(1) <= P2(2) xor AB3(1) xor C3(0);    -- S
C3(1) <= (P2(2) and AB3(1)) or (C3(0) and P2(2)) or (C3(0) and AB3(1)); -- Cout

-- FA7: full_adder_vhdl_code port map( P2(3), AB3(2), C3(1), C3(2), P3(2));
P3(2) <= P2(3) xor AB3(2) xor C3(1);    -- S
C3(2) <= (P2(3) and AB3(2)) or (C3(1) and P2(3)) or (C3(1) and AB3(2)); -- Cout

-- FA8: full_adder_vhdl_code port map( C2(3), AB3(3), C3(2), C3(3), P3(3));
P3(3) <= C2(3) xor AB3(3) xor C3(2);    -- S
C3(3) <= (C2(3) and AB3(3)) or (C3(2) and C2(3)) or (C3(2) and AB3(3)); -- Cout

-- --- Part 3: Final Output Mapping ---
-- This part remains identical to your original code.

S(0)<= AB0(0);
S(1)<= P1(0);
S(2)<= P2(0);
S(3)<= P3(0);
S(4)<= P3(1);
S(5)<= P3(2);
S(6)<= P3(3);
S(7)<= C3(3);

end Behavioral;