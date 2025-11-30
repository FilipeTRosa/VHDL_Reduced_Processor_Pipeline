library ieee;                 
use ieee.std_logic_1164.all;  
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity bregistradores is 
	port(
		brReg0 			:	in std_logic_vector (3 downto 0);
		brReg1 			:	in std_logic_vector (3 downto 0);
		brRegDest		:	in std_logic_vector (3 downto 0);
		brData			:	in std_logic_vector (15 downto 0);
		brEnable		:	in std_logic;
		clock			:	in std_logic;
		brOut0			:	out std_logic_vector (15 downto 0);
		brOut1			:	out std_logic_vector (15 downto 0)
	
);
end entity;

architecture behavior of bregistradores is

type br is array (integer range 0 to 15) of std_logic_vector(15 downto 0);
signal br_o 		: br;
signal endBr0 		: integer range 0 to 15;
signal endBr1 		: integer range 0 to 15;
signal endRegDest 	: integer range 0 to 15;

begin

	endBr0	   <= conv_integer(brReg0);
	endBr1	   <= conv_integer(brReg1);
	endRegDest <= conv_integer(brRegDest);
	brOut0 <= br_o(endBr0);
	brOut1 <= br_o(endBr1);
	
process(clock)
begin
if clock = '1' and clock'event then
		br_o(0) <= "0000000000000000";
	if brEnable = '1' then
		br_o(endRegDest) <= brData;
	end if;
end if;
end process;
end behavior;