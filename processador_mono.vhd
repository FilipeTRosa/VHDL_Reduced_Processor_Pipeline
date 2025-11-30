library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity processador_mono is
	port(
		clock		: in std_logic;
		reset		: in std_logic
		
	);
end entity;
architecture behavior of processador_mono is

-- SINAIS DA INTRUCAO --                   
signal inst			: std_logic_vector(19 downto 0); --saida memoria de instruções
signal opcode		: std_logic_vector(3 downto 0);
signal reg0			: std_logic_vector(3 downto 0);
signal reg1			: std_logic_vector(3 downto 0);
signal regDest		: std_logic_vector(3 downto 0);
signal imm			: std_logic_vector(7 downto 0);

-- MEMORIA DE INSTRUCOES --
type mem is array (integer range 0 to 255) of std_logic_vector(19 downto 0);
signal memInst		: mem;

-- SINAIS DE CONTROLE --
signal pc 			: std_logic_vector(7 downto 0);

-- SINAIS DA ULA --
signal ulaOut 		: std_logic_vector(15 downto 0);
signal ulaIn0 		: std_logic_vector(15 downto 0);
signal ulaIn1 		: std_logic_vector(15 downto 0);
signal ulaOp  		: std_logic_vector(1 downto 0);
signal ulaComp  	: std_logic;

component ula is
    port(
        ulaOp   	: in std_logic_vector(1 downto 0);
        ulaIn_0 	: in std_logic_vector(15 downto 0);
        ulaIn_1 	: in std_logic_vector(15 downto 0);
        ulaOut  	: out std_logic_vector(15 downto 0);
        ulaComp 	: out std_logic
    );  
end component;

--	MEMORIA DE DADOS --
signal memDataEnd	: std_logic_vector(7 downto 0); -- para guardar o end do SW e LW
signal memDatain 	: std_logic_vector(15 downto 0);
signal memDataOut	: std_logic_vector(15 downto 0);

component memoria is 
	port(
		memDataEnd	: in std_logic_vector(7 downto 0);
		memDataOut	: out std_logic_vector(15 downto 0);
		opcode		: in std_logic_vector(3 downto 0);
		memDataIn 	: in std_logic_vector(15 downto 0);
		clock		: in std_logic
	);
end component;

-- BANCO DE REGISTRADORES --

signal brReg0 		: std_logic_vector (3 downto 0);
signal brReg1 		: std_logic_vector (3 downto 0);
signal brRegDest	: std_logic_vector (3 downto 0);
signal brData		: std_logic_vector (15 downto 0);
signal brEnable		: std_logic;
signal brOut0		: std_logic_vector (15 downto 0);
signal brOut1		: std_logic_vector (15 downto 0);

component bregistradores is 
	port(
		brReg0 		:	in std_logic_vector (3 downto 0);
		brReg1 		:	in std_logic_vector (3 downto 0);
		brRegDest	:	in std_logic_vector (3 downto 0);
		brData		:	in std_logic_vector (15 downto 0);
		brEnable	:	in std_logic;
		clock		:	in std_logic;
		brOut0		:	out std_logic_vector (15 downto 0);
		brOut1		:	out std_logic_vector (15 downto 0)
		
);
end component;



begin

	-- ### PORTMAP ULA ### --
	ulaProcess : ula
	port map(
        -- Porta da ULA => processador
        ulaOp   => ulaOp,  
        ulaIn_0 => ulaIn0,   
        ulaIn_1 => ulaIn1,   
        ulaOut  => ulaOut, 
        ulaComp => ulaComp         
    );
    
    -- ### PORTMAP MEMORIA DE DADOS ### --
    memoriaProcess : memoria
    PORT MAP(
        -- Porta da Memoria => Sinal do Processador
        memDataEnd  => memDataEnd,
        memDataOut  => memDataOut,
        opcode   	=> opcode,
        memDataIn   => memDataIn,
        clock    	=> clock
    );

    -- ### PORTMAP BANCO DE REGISTRADORES ### --
	bregistradoresProcess : bregistradores
	port map(
        -- Porta do BR => processador
        brReg0    => brReg0,
        brReg1    => brReg1,
        brRegDest => brRegDest,
        brData    => brData,
        brEnable  => brEnable,
        clock     => clock, 
        brOut0    => brOut0,
        brOut1    => brOut1         
    );

	--separando a operação COM 20 bits	
	opcode <= inst(19 downto 16);
	--tentando com when
														-- ADD : SUB : MULT				   //   		-- BEQ e BNE			// 			 ADDI : SUBI : MULTI							//     	 SW
	reg0 <= inst(15 downto 12) when (opcode = "0000" or opcode = "0001" or opcode = "0010" or opcode = "0100" or opcode = "0101"  or opcode = "1001" or opcode = "1010" or opcode = "1000"  or opcode = "0111" )
		else
			(others => '0');
	-- 												-- ADD : SUB : MULT					  //    		-- BEQ : BNE
	reg1 <= inst(11 downto 8) when (opcode = "0000" or opcode = "0001" or opcode = "0010" or opcode = "0100" or opcode = "0101") 
		else
			(others => '0');
	--	
	regDest <= inst(3 downto 0) when (opcode = "0000" or opcode = "0001" or opcode = "0010")  -- ADD : SUB : MULT  
		else
			inst(11 downto 8) when (opcode = "1000" or opcode = "1001" or opcode = "1010"  or opcode = "1011") --  ADDI : SUBI : MULTI -- LDI 
		else
			inst(15 downto 12) when (opcode = "0110")-- LW
		else
			(others => '0');
	-- 									JMP			//  		-- BEQ : BNE			//				 -- LDI : ADDI : SUBI : MULTI								// 			--LW e SW
	imm <= inst(7 downto 0) when (opcode = "0011" or opcode = "0100" or opcode = "0101" or opcode = "1011" or opcode = "1000" or opcode = "1001" or opcode = "1010" or opcode = "0110" or opcode = "0111")
		else
			(others => '0');
				
	--ENABLE ESCRITA NO BR  		-- ADD : SUB : MULT							//		SW			//					ADDI : SUBI : MULTI					// LDI				//     LW
	brEnable <= '1' when (opcode = "0000" or opcode = "0001" or opcode = "0010" or opcode = "0111" or opcode = "1000" or opcode = "1001" or opcode = "1010" or opcode = "1011" or opcode = "0110")
		else	
			'0';

	--Ligando cabos do BR
	brReg0  	<= reg0;		
	brReg1 	  	<= reg1;
	brRegDest 	<= regDest;
	brData 		<= "00000000" & imm when(opcode = "1011") else --LDI
					memDataOut when (opcode = "0110") else --LW
					ulaOut;
	
	--Ligando cabos da Memoria
    memDataEnd  <= imm;
    memDataIn   <= brOut0;
	
	--Ligando cabos da Ula
	ulaOp <= "00" when opcode = "0000" or opcode = "1000" else
			"01" when opcode = "0001" or opcode = "1001" else
			"10" when opcode = "0010" or opcode = "1010" else
			"11";
	ulaIn0 <= brOut0; 
    ulaIn1 <= "00000000" & imm when (opcode = "1000" or opcode = "1001" or opcode = "1010") else -- ADDI : SUBI : MULTI	
    		brOut1;
     		
	-- BUSCA INSNTRUCAO
	inst  	<= memInst(conv_integer(PC));

process(clock, reset)
	begin
		if reset = '1' then
			PC <= (others => '0');
		elsif clock = '1' and clock'event then --reset 0
			--incremento do PC....
			if (opcode = "0011") then --JMP
				pc <= imm;
			elsif ((opcode = "0100") and (ulaComp = '0')) or ((opcode = "0101") and (ulaComp = '1')) then -- (0100 and 0) = BEQ ...ou... (0101 and 1) = BNE
				pc <= pc + imm;
			else
				pc <= pc + 1;
			end if;
			-- 
					
		end if;

end process;

-- memoria instruções
memInst(0) <= 20x"B0401";
memInst(1) <= 20x"B0203";
memInst(2) <= 20x"B0302";
memInst(3) <= 20x"40306";
memInst(4) <= 20x"22406";
memInst(5) <= 20x"06004";
memInst(6) <= 20x"93701";
memInst(7) <= 20x"07003";
memInst(8) <= 20x"30003";
memInst(9) <= 20x"74003";
memInst(15) <= (others => '0');
memInst(14) <= (others => '0');
memInst(10) <= 20x"6A003";
memInst(11) <= (others => '0');
memInst(12) <= (others => '0');
memInst(13) <= (others => '0');


end behavior;