LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY BaudRate_generator_tb IS
END BaudRate_generator_tb;

ARCHITECTURE behavior OF BaudRate_generator_tb IS

	COMPONENT BaudRate_generator
	port(
		clk	: in std_logic;
		bd_rate	: in std_logic_vector(1 downto 0);
		tick	: out std_logic
	);
	END COMPONENT;

	SIGNAL clk	: std_logic;
	SIGNAL tick	: std_logic;
BEGIN
	uut: entity work.BaudRate_generator(behavior)
		PORT MAP(
			clk => clk,
			bd_rate =>"11",
			tick => tick
		);
  tb : PROCESS
  BEGIN
	  clk <= '0';
	  wait for 12.5ps;
	  clk <= '1';
	  wait for 12.5ps;
  END PROCESS tb;
--  End Test Bench 

END behavior;
