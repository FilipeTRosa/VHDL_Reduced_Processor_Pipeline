library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity processador_pipe is
	port(
		clock		: in std_logic;
		reset		: in std_logic
		
	);
end entity;
architecture behavior of processador_pipe is

-- SINAIS DA INTRUCAO --                   
signal inst			: std_logic_vector(19 downto 0); --saida memoria de instruções
signal opcode		: std_logic_vector(3 downto 0);
signal reg0			: std_logic_vector(3 downto 0);
signal reg1			: std_logic_vector(3 downto 0);
signal regDest		: std_logic_vector(3 downto 0);
signal imm			: std_logic_vector(7 downto 0);

-- REGISTRADORES DE PIPELINE

signal IF_ID				: std_logic_vector(19 downto 0);
--signal ID_EX    			: std_logic_vector(19 downto 0);
--signal EX_MEM   			: std_logic_vector(19 downto 0);
--IDsignal MEM_WB   			: std_logic_vector(19 downto 0);
signal controle_ID_EX    	: std_logic_vector(10 downto 0);
signal controle_EX_MEM   	: std_logic_vector(10 downto 0);
signal controle_MEM_WB   	: std_logic_vector(10 downto 0);
signal brOut0ID_EX   	 	: std_logic_vector (15 downto 0);
signal brOut1ID_EX   		: std_logic_vector (15 downto 0); 
signal regDestID_EX			: std_logic_vector(3 downto 0);
signal regDestEX_MEM		: std_logic_vector(3 downto 0);
signal regDestMEM_WR		: std_logic_vector(3 downto 0);
signal immID_EX				: std_logic_vector(7 downto 0);
signal immEX_MEM			: std_logic_vector(7 downto 0);
signal brOut0EX_MEM  	 	: std_logic_vector (15 downto 0);
signal ulaOutEX_MEM   		: std_logic_vector(15 downto 0);
signal ulaOutMEM_WB    		: std_logic_vector(15 downto 0);
signal memDataOutMEM_WB 	: std_logic_vector (15 downto 0);
signal immMEM_WB			: std_logic_vector(7 downto 0);
signal pcIF_ID 				: std_logic_vector(7 downto 0);
signal pcID_EX 				: std_logic_vector(7 downto 0);
signal pcEX_MEM 			: std_logic_vector(7 downto 0);
signal pcMEM_WB 			: std_logic_vector(7 downto 0);




-- MEMORIA DE INSTRUCOES --
type mem is array (integer range 0 to 255) of std_logic_vector(19 downto 0);
signal memInst		: mem;

-- SINAIS DE CONTROLE --
signal pc 					: std_logic_vector(7 downto 0);
signal ctl_opcode			: std_logic_vector(3 downto 0);
signal ctl_brEnable			: std_logic; 
signal ctl_ulaOp			: std_logic_vector (1 downto 0);
signal muxUlaIn1			: std_logic;
signal muxBrData			: std_logic_vector (1 downto 0);
signal ctl_jump				: std_logic;
signal ctl_memIn			: std_logic;
signal ctl_branch			: std_logic;
signal ctl_memToReg			: std_logic;
signal ctl_branchNe			: std_logic;

component controle is
	port(
		clock				: in std_logic;
		ctl_opcode			: in std_logic_vector(3 downto 0);
		ctl_brEnable		: out std_logic; 
		ctl_ulaOp			: out std_logic_vector (1 downto 0);
		muxUlaIn1			: out std_logic;
		muxBrData			: out std_logic_vector (1 downto 0);
		ctl_jump			: out std_logic;
		ctl_memIn			: out std_logic;
		ctl_branch			: out std_logic;
		ctl_memToReg		: out std_logic;
		ctl_branchNe		: out std_logic
	);
end component;



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
signal memEnable	: std_logic;
signal memToReg		: std_logic;

component memoria is 
	port(
		memDataEnd	: in std_logic_vector(7 downto 0);
		memDataOut	: out std_logic_vector(15 downto 0);
		opcode		: in std_logic_vector(3 downto 0);
		memDataIn 	: in std_logic_vector(15 downto 0);
		memEnable	: in std_logic;
		memToReg	: in std_logic;
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

	-- ### PORTMAP CONTROLE ### --
	controleProcess : controle
	port map(
        -- Porta do controle => processador
     	ctl_opcode		=> ctl_opcode,
		ctl_brEnable	=> ctl_brEnable,
		ctl_ulaOp		=> ctl_ulaOp,
		muxUlaIn1		=> muxUlaIn1,
		muxBrData		=> muxBrData,
		ctl_jump		=> ctl_jump,
		ctl_memIn		=> ctl_memIn,	
		ctl_branch		=> ctl_branch,
		ctl_memToReg	=> ctl_memToReg,
		ctl_branchNe	=> ctl_branchNe,
		clock    	=> clock
    );


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
        memEnable	=> memEnable,
        memToReg	=> memToReg,
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
	inst <= memInst(conv_integer(PC));
	opcode <= IF_ID(19 downto 16);
	--tentando com when
														-- ADD : SUB : MULT				   //   		-- BEQ e BNE			// 			 ADDI : SUBI : MULTI							//     	 SW
	reg0 <= IF_ID(15 downto 12) when (opcode = "0000" or opcode = "0001" or opcode = "0010" or opcode = "0100" or opcode = "0101"  or opcode = "1001" or opcode = "1010" or opcode = "1000"  or opcode = "0111" )
		else
			(others => '0');
	-- 												-- ADD : SUB : MULT					  //    		-- BEQ : BNE
	reg1 <= IF_ID(11 downto 8) when (opcode = "0000" or opcode = "0001" or opcode = "0010" or opcode = "0100" or opcode = "0101") 
		else
			(others => '0');
	--	
	regDest <= IF_ID(3 downto 0) when (opcode = "0000" or opcode = "0001" or opcode = "0010")  -- ADD : SUB : MULT  
		else
			IF_ID(11 downto 8) when (opcode = "1000" or opcode = "1001" or opcode = "1010"  or opcode = "1011") --  ADDI : SUBI : MULTI -- LDI 
		else
			IF_ID(15 downto 12) when (opcode = "0110")-- LW
		else
			(others => '0');
	-- 									JMP			//  		-- BEQ : BNE			//				 -- LDI : ADDI : SUBI : MULTI								// 			--LW e SW
	imm <= IF_ID(7 downto 0) when (opcode = "0011" or opcode = "0100" or opcode = "0101" or opcode = "1011" or opcode = "1000" or opcode = "1001" or opcode = "1010" or opcode = "0110" or opcode = "0111")
		else
			(others => '0');
				

	--Ligando cabos do BR
	brReg0  	<= reg0;		
	brReg1 	  	<= reg1;
	brRegDest 	<= regDestMEM_WR; -- mudar para pegar do MEM/WB
	brData 		<= "00000000" & immMEM_WB when(controle_MEM_WB(4 downto 3) = "00") else --LDI
					memDataOutMEM_WB when (controle_MEM_WB(4 downto 3) = "01") else --LW
					ulaOutMEM_WB;
	-- 00 LDI ...... 01 LW...... 10 & 11 ulaOut ---->> ATUALIZAR COM O CONTROLE JA TEM O SINAL
	--ENABLE ESCRITA NO BR  		-- ADD : SUB : MULT							//		SW			//					ADDI : SUBI : MULTI					// LDI				//     LW
	brEnable <= controle_MEM_WB(8); -- LOGICA NOVA COM CONTROLE
	--'1' when (opcode = "0000" or opcode = "0001" or opcode = "0010" or opcode = "0111" or opcode = "1000" or opcode = "1001" or opcode = "1010" or opcode = "1011" or opcode = "0110")
	--	else	
	--		'0';
	-- quem manda no br enable é o ctl_brEnable	que está no controle_MEM_WB(8)
	
					
	--Ligando cabos da Memoria
    memDataEnd  <= immEX_MEM;
    memDataIn   <= brOut0EX_MEM;
    memEnable	<= controle_EX_MEM(1);
    memToReg	<= controle_EX_MEM(10);
	
	--Ligando cabos da Ula
	ulaOp  <= controle_ID_EX(7 downto 6);
	ulaIn0 <= brOut0ID_EX; 
    ulaIn1 <= "00000000" & immID_EX when (controle_ID_EX(5) = '1') else -- ADDI : SUBI : MULTI	
    		brOut1ID_EX;
    		-- ULA IN 1 ..... 0 > brout1 ..... ou ..... 1 > ADDI : SUBI : MULTI	ATUALIZAR COM O CONTROLE JA TEM O SINAL

    --Ligando o controle
    ctl_opcode <= inst(19 downto 16); --opcode no IFID
    				
    		
process(clock, reset)
	begin
		if reset = '1' then
			PC <= (others => '0');
		elsif clock = '1' and clock'event then --reset 0
			
			--ESTAGIO IF ID
				--Alimentando redistradores de Pipeline--
				IF_ID  		<= inst; -- Busca
				pcIF_ID		<= pc;
			
			--ESTAGIO ID EX
				--Ligando o controle
				controle_ID_EX(0) <= ctl_branch;
				controle_ID_EX(1) <= ctl_memIn;
				controle_ID_EX(2) <= ctl_jump;
				controle_ID_EX(4 downto 3) <= muxBrData;
				controle_ID_EX(5) <= muxUlaIn1;
				controle_ID_EX(7 downto 6) <= ctl_ulaOp;
				controle_ID_EX(8) <= ctl_brEnable;
				controle_ID_EX(9) <= ctl_branchNe;
				controle_ID_EX(10)<= ctl_memToReg;
				--controle_ID_EX(19 downto 11) <= "000000000";
				-- pegando saida do BR
				brOut0ID_EX   		<= brOut0;
	       		brOut1ID_EX   		<= brOut1;  
				immID_EX		 	<= imm;
				regDestID_EX		<= regDest;
				pcID_EX				<= pcIF_ID;
			
			--ESTAGIO EX MEM
				--Passando o controle
				controle_EX_MEM(1) <= controle_ID_EX(1);
				controle_EX_MEM(8) <= controle_ID_EX(8);
				controle_EX_MEM(4 downto 3) <= controle_ID_EX(4 downto 3);
				controle_EX_MEM(2) <= '0';
				controle_EX_MEM(0) <= '0';
				controle_EX_MEM(5) <= '0';
				controle_EX_MEM(7 downto 6) <= "00";
				controle_EX_MEM(9) <= '0';
				controle_EX_MEM(10)<= controle_ID_EX(10);
				--controle_EX_MEM(19 downto 11) <= "000000000";
				--outros regs
				immEX_MEM	 		<= immID_EX;
				brOut0EX_MEM		<= brOut0ID_EX;
				ulaOutEX_MEM		<= ulaOut;
				regDestEX_MEM		<= regDestID_EX;
				pcEX_MEM			<= pcID_EX;
				
				
			--ESTAGIO MEM WR
				controle_MEM_WB(1) <= '0';
				controle_MEM_WB(8) <= controle_EX_MEM(8);
				controle_MEM_WB(4 downto 3) <= controle_EX_MEM(4 downto 3);
				controle_MEM_WB(2) <= '0';
				controle_MEM_WB(0) <= '0';
				controle_MEM_WB(5) <= '0';
				controle_MEM_WB(7 downto 6) <= "00";
				controle_MEM_WB(9) <= '0';
				controle_MEM_WB(10)<= controle_ID_EX(10);
				--controle_MEM_WB(19 downto 11) <= "000000000";
				--Outros Regs
				ulaOutMEM_WB		<= ulaOutEX_MEM;
				memDataOutMEM_WB	<= memDataOut;
				immMEM_WB			<= immEX_MEM;
				regDestMEM_WR		<= regDestEX_MEM;
				pcEX_MEM			<= pcID_EX;
			--............................
			

			--incremento do PC....
			if (ctl_jump = '1') then --JMP
				pc <= imm;
			elsif ((controle_ID_EX(0) = '1') and (ulaComp = '0')) or ((controle_ID_EX(9) = '1') and (ulaComp = '1')) then -- (0100 and 0) = BEQ ...ou... (0101 and 1) = BNE
				pc <= pcID_EX + immID_EX;
			else
				pc <= pc + 1;
			end if;
			-- 
					
		end if;

end process;

-- memoria instruções
memInst(0) <= 20x"B0401";
memInst(1) <= 20x"B0202";
memInst(2) <= 20x"B0302";
memInst(3) <= 20x"00000";
memInst(4) <= 20x"00000";
memInst(5) <= 20x"00000";
memInst(6) <= 20x"40310";
memInst(7) <= 20x"00000";
memInst(8) <= 20x"00000";
memInst(9) <= 20x"00000";
memInst(10) <= 20x"22406";
memInst(11) <= 20x"00000";
memInst(12) <= 20x"00000";
memInst(13) <= 20x"00000";
memInst(14) <= 20x"06004";
memInst(15) <= 20x"93701";
memInst(16) <= 20x"00000";
memInst(17) <= 20x"00000";
memInst(18) <= 20x"00000";
memInst(19) <= 20x"07003";
memInst(20) <= 20x"30006";
memInst(21) <= 20x"00000";
memInst(22) <= 20x"74003";
memInst(23) <= 20x"00000";
memInst(24) <= 20x"00000";
memInst(25) <= 20x"00000";
memInst(26) <= 20x"6A003";
memInst(27) <= 20x"50208";
memInst(29) <= (others => '0');
memInst(30) <= (others => '0');
memInst(31) <= (others => '0');
memInst(32) <= (others => '0');

end behavior;