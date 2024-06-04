LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
ENTITY main IS
	generic(
		CLK_INPUT 	: integer := 40000000;
		BAUD_RATE	: integer := 19200
	);
	port(
		clk		: IN  std_logic;
		reset		: IN  std_logic;
		rx			: IN  std_logic;
		tx			: out std_logic;
		clock		: OUT  std_logic_vector(7 downto 0)
	);
END main;
 
ARCHITECTURE behavior OF main IS 
   signal rd : std_logic := '0';
   signal wr : std_logic := '0';
   signal w_data : std_logic_vector(7 downto 0) := (others => '0');

   signal rx_empty : std_logic;
   signal rx_full : std_logic;
   signal r_data : std_logic_vector(7 downto 0);
	
	signal counter 	: integer range 0 to 39999 := 0;
	signal clock_buf	: std_logic_vector(7 downto 0):=(others =>'0');
	
	signal flag	: std_logic_vector(1 downto 0):= "00";
	
	
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.UART(behavior)
		GENERIC MAP(
			CLK_INPUT 	=> CLK_INPUT,
			BAUD_RATE	=> BAUD_RATE,
			DATA_BITS	=> 8,	-- number of bits
			ADDR_BIT		=> 4	-- number of address bits
		)
		PORT MAP (
			clk => clk,
			reset => reset,
			rx => rx,
			rd => rd,
			wr => wr,
			w_data => w_data,
			tx => tx,
			rx_empty => rx_empty,
			r_data => r_data
		);
	clock <= clock_buf;
	process(clk,reset)begin
		if(reset = '1')then
			clock_buf <= (others => '0');
		elsif(clk'event and clk = '1')then
			
			if(rx_empty = '0' and rd = '0')then
				rd <= '1';
				case r_data is
					when "01100111" => -- 'g'
						flag(0)<='1';
					when "01110011" => -- 's'
						flag(0)<='0';
					when "01110101" => -- 'u'
						flag(1)<=not(flag(1));
					when "01110010" => -- 'r'
						w_data <= clock_buf;
						wr <= '1';
					when "01000111" => -- 'G'
						flag(0)<='1';
					when "01010011" => -- 'S'
						flag(0)<='0';
					when "01010101" => -- 'U'
						flag(1)<=not(flag(1));
					when "01010010" => -- 'R'
						w_data <= clock_buf;
						wr <= '1';
					when others =>
						
				end case;
			else 
				rd <= '0';
				wr <= '0';
				if(counter = 39999)then
					counter <= 0;
					if(flag(0) = '1')then
						if(flag(1) = '0')then
							clock_buf <= std_logic_vector(unsigned(clock_buf)+1);
						else
							clock_buf <= std_logic_vector(unsigned(clock_buf)-1);
						end if;
					end if;
				else
					counter <= counter+1;
				end if;
			end if;
		end if;
   end process;
END;
