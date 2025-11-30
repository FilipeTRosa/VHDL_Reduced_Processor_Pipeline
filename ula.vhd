library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity ula is
	port(
		--clock			: in std_logic;
		ulaOp 			: in std_logic_vector(1 downto 0);
		ulaIn_0	        : in std_logic_vector(15 downto 0);
		ulaIn_1         : in std_logic_vector(15 downto 0);
		ulaOut     		: out std_logic_vector(15 downto 0);
		ulaComp    		: out std_logic
	
	);	
end entity;

architecture behavior of ula is

--simais ULA
signal comp 	: std_logic_vector(15 downto 0);
signal multi 	: std_logic_vector(31 downto 0);
begin

	comp <= ulaIn_0 - ulaIn_1;
	
	ulaComp <= '0' when comp = "0000000000000000" else
			  	'1';
	multi <= (ulaIn_0 * ulaIn_1);
	ulaOut <= (ulaIn_0 + ulaIn_1) when ulaOp = "00" else
			   comp when ulaOp = "01" else
			  	multi(15 downto 0) when ulaOp = "10" else
				(others => '0');
	

end behavior;