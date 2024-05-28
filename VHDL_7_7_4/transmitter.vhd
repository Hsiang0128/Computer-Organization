library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transmitter is
	generic(
		DBIT		: integer := 8	-- data bits
	);
	port(
		clk				: in std_logic;
		reset				: in std_logic;
		tx_start			: in std_logic;
		s_tick			: in std_logic;
		din				: in std_logic_vector ( 7 downto 0 );
		tx_done_tick	: out std_logic;
		tx					: out std_logic
	);
end transmitter ;

architecture behavior of transmitter is
	type state_type is (
		IDLE,
		WAIT_START,
		START,
		DATA,
		STOP
	);
	signal state_reg		: state_type;
	signal counter			: integer range 0 to (DBIT-1);
	signal data_buf		: std_logic_vector(7 downto 0 );
	signal tick_negedge	: std_logic;
	signal tick_tmp		: std_logic;
	
begin
	tick_negedge <= ((not s_tick) and tick_tmp);
	process(clk,reset)begin
		if(reset = '1')then
			state_reg 	<= IDLE;
			tx <= '1';
			tx_done_tick <= '0';
		elsif(clk'event and clk = '1')then
			tick_tmp <= s_tick;
			case state_reg is
				when IDLE =>
					tx 		<= '1';
					tx_done_tick <= '0';
					counter 	<= 0;
					if(tx_start = '1')then
						state_reg 	<= WAIT_START;
						data_buf		<= din; 
					end if;
				when WAIT_START =>
					if(tick_negedge = '1')then
						state_reg 	<= START;
					end if;
				when START =>
					tx <= '0';
					if(tick_negedge = '1')then
						state_reg 	<= DATA;
					end if;
				when DATA =>
					tx <= data_buf(0);
					if(tick_negedge = '1')then
						data_buf <= '0'&data_buf(7 downto 1);
						counter	<= counter +1;
						if(counter = (DBIT - 1))then
							tx_done_tick <= '1';
							counter <= 0;
							state_reg 	<= STOP;
						end if;
					end if;
				when STOP =>
					tx <= '1';
					tx_done_tick <= '0';
					if(tick_negedge = '1')then
						if(tx_start = '1')then
							state_reg <= START;
							data_buf		<= din;
						else
							state_reg <= IDLE;
						end if;
					end if;
			end case;
		end if;
	end process;
end behavior;