library ieee;                 
use ieee.std_logic_1164.all;  
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity tb is
end entity;

architecture behavior of tb is

-- componente topo (que os discentes devem fazer para a avaliação)
component processador_mono is
	port(
			clock		: in std_logic;	
			reset    	: in std_logic
			--Z         : out std_logic_vector(3 downto 0)
			);
end component;

-- sinais para serem ligados no port map com o topo
signal clock_sg		: std_logic:= '0';
signal reset_sg		: std_logic:= '1';
--signal Z_sg			: std_logic_vector(3 downto 0);

begin

-- instanciação do componente
inst_processador_mono : processador_mono
	port map(
					clock	=> clock_sg,
					reset	=> reset_sg
					--Z			=> Z_sg
					);
					
-- geração do clock
clock_sg <= not clock_sg after 5 ps;

-- desligamento do reset
process
	begin
		wait for 2 ps;
			reset_sg <= '0';
		wait;
end process;

end behavior;
					

