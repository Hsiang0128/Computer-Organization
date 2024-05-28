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
		dnum				: in std_logic;
		snum				: in std_logic;
		din				: in std_logic_vector ( 7 downto 0 );
		par				: in std_logic_vector (1 downto 0);
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
		PARE,
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
						if(counter = (DBIT - 1) or(counter = (DBIT - 2) and dnum = '0'))then
							if(par = "00")then
								if(snum = '0')then
									tx_done_tick <= '1';
									counter <= 0;
								else
									counter <= 1;
								end if;
								state_reg 	<= STOP;
							else 
								state_reg 	<= PARE;
							end if;
						end if;
					end if;
				when PARE =>
					tx <= din(0)xor
							din(1)xor
							din(2)xor
							din(3)xor
							din(4)xor
							din(5)xor
							din(6)xor
							(din(7)and dnum)xor
							par(1);
					if(tick_negedge = '1')then
						if(snum = '0')then
							tx_done_tick <= '1';
							counter <= 0;
						else
							counter <= 1;
						end if;
						state_reg 	<= STOP;
					end if;
				when STOP =>
					tx <= '1';
					if(counter = 0)then
						tx_done_tick <= '0';
					end if;
					if(tick_negedge = '1')then
						if(counter = 0)then
							if(tx_start = '1')then
								state_reg <= START;
								data_buf		<= din;
							else
								state_reg <= IDLE;
							end if;
						else
							counter <= 0;
							tx_done_tick <= '1';
						end if;
					end if;
			end case;
		end if;
	end process;
end behavior;