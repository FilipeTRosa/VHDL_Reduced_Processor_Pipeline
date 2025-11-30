library ieee;                 
use ieee.std_logic_1164.all;  
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity memoria is 
	port(
		memDataEnd	: in std_logic_vector (7 downto 0);
		memDataOut	: out std_logic_vector (15 downto 0);
		opcode		: in std_logic_vector (3 downto 0);
		memDataIn 	: in std_logic_vector (15 downto 0);
		clock		: in std_logic
	);
end entity;
architecture behavior of memoria is 

type mem is array (integer range 0 to 255) of std_logic_vector(15 downto 0);
signal mem_ram 	: mem;
signal endInt	: integer range 0 to 255;
signal enable 	: std_logic;

begin

-- convertendo o endereço de entrada em binário para endereçar a memória
endInt <= conv_integer(memDataEnd);
enable <= '1' when (opcode = "0111") 
		else 
		  '0';

memDataOut <= mem_ram(endInt) when (enable = '0')
	else
		(others => '0');
		
process(clock)
begin
-- ideia de acesso a memoria escrita
if clock = '1' and clock'event then
	if opcode = "0111" then
		 mem_ram(endInt) <= memDataIn;
	end if;
end if;

end process;
end behavior;