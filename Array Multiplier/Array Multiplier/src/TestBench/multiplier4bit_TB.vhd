library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity multiplier4bit_tb is
end multiplier4bit_tb;

architecture TB_ARCHITECTURE of multiplier4bit_tb is
	-- Component declaration of the tested unit
	component multiplier4bit
	port(
		A : in STD_LOGIC_VECTOR(3 downto 0);
		B : in STD_LOGIC_VECTOR(3 downto 0);
		S : out STD_LOGIC_VECTOR(7 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal A : STD_LOGIC_VECTOR(3 downto 0);
	signal B : STD_LOGIC_VECTOR(3 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal S : STD_LOGIC_VECTOR(7 downto 0);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : multiplier4bit
		port map (
			A => A,
			B => B,
			S => S
		);

	-- Add your stimulus here ...
	process 
	begin
		wait for 100ns;
		A<="1000";	
		B<="1000";
		wait for 100ns;
		A<="0010";
		B<="0100";
		wait for 100ns;
		A<="1001";
		B<="0011";
		wait;
	end process;	

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_multiplier4bit of multiplier4bit_tb is
	for TB_ARCHITECTURE
		for UUT : multiplier4bit
			use entity work.multiplier4bit(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_multiplier4bit;

