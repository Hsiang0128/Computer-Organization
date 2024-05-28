library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity receiver is
	generic(
		DBIT 		: integer := 8  	-- # data bits
	) ;
	port(
		clk 				: in std_logic;
		reset				: in std_logic;
		rx 				: in std_logic;
		s_tick 			: in std_logic;
		dnum				: in std_logic;
		snum				: in std_logic;
		par				: in std_logic_vector(1 downto 0);
		rx_done_tick	: out std_logic;
		dout 				: out std_logic_vector(7 downto 0);
		err				: out std_logic_vector(1 downto 0)
	);
end receiver;
architecture behavior of receiver is
	type state_type is (
		IDLE,
		START,
		DATA,
		PARE,
		STOP
	);
	signal state_reg	: state_type;
	signal counter 	: integer range 0 to (DBIT-1);
	signal data_buf	: std_logic_vector(7 downto 0);
	signal tick_posedge	: std_logic;
	signal tick_tmp		: std_logic;
begin

	tick_posedge <= (s_tick and (not tick_tmp));
	dout <= data_buf;
	process(clk,reset)begin
		if(reset = '1')then
			state_reg 	<= IDLE;
			rx_done_tick <= '0';
			err <= "00";
			data_buf <= (others => '0');
		elsif(clk'event and clk = '1')then
			tick_tmp <= s_tick;
			case state_reg is
				when IDLE =>
					rx_done_tick <= '0';
					counter 	<= 0;
					if(tick_posedge = '1' and rx = '0')then
						state_reg 	<= START;
					end if;
				when START =>
					if(tick_posedge = '1')then
						data_buf <= rx & data_buf(7 downto 1);
						state_reg 	<= DATA;
					end if;
				when DATA =>
					if(tick_posedge = '1')then
						counter	<= counter +1;
						if(counter = (DBIT - 1)or(counter = (DBIT - 2) and dnum = '0'))then
							if(dnum = '0')then
								data_buf <= '0' & data_buf(7 downto 1);
							end if;
							if(par = "00")then
								state_reg 	<= STOP;
								if(rx = '0')then
									err(1) <= '1';
								else
									err(1) <= '0';
								end if;
								if(snum = '0')then
									rx_done_tick <= '1';
									counter <= 0;
								else
									counter <= 1;
								end if;
							else
								state_reg <= PARE;
								if(par = "01")then
									err(0)<= data_buf(0)xor
												data_buf(1)xor
												data_buf(2)xor
												data_buf(3)xor
												data_buf(4)xor
												data_buf(5)xor
												data_buf(6)xor
												data_buf(7)xor
												rx;
								else
									err(0)<= not(data_buf(0)xor
												data_buf(1)xor
												data_buf(2)xor
												data_buf(3)xor
												data_buf(4)xor
												data_buf(5)xor
												data_buf(6)xor
												data_buf(7)xor
												rx);
								end if;
							end if;
						else 
							data_buf <= rx & data_buf(7 downto 1);
						end if;
					end if;
				when PARE =>
					if(tick_posedge = '1')then
						state_reg 	<= STOP;
						if(snum = '0')then
							rx_done_tick <= '1';
							counter <= 0;
						else
							counter <= 1;
						end if;
					end if;
				when STOP =>
					if(counter = 0)then
						data_buf <= (others => '0');
						rx_done_tick <= '0';
						err <= "00";
					end if;
					if(tick_posedge = '1')then
						if(counter = 0)then
							if(rx = '0')then
								state_reg <= START;
							else
								state_reg <= IDLE;
							end if;
						else
							rx_done_tick <= '1';
							if(rx = '0')then
								err(1) <= '1';
							else
								err(1) <= '0';
							end if;
							counter <= 0;
						end if;
					end if;
			end case;
		end if;
	end process;
end behavior;
