library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity controle is
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
end entity;
architecture behavior of controle is
begin




process(clock, ctl_opcode)
begin
if clock = '1' and clock'event then
	case ctl_opcode is
    
        -- ==========================================
        -- TIPO R (Aritméticas)
        -- ==========================================
        when "0000" => -- ADD
            ctl_brEnable    <= '1';
            ctl_ulaOp       <= "00";
            muxUlaIn1		<= '0';
            muxBrData   	<= "10";
            ctl_jump        <= '0';
            ctl_memIn       <= '0'; -- (Provavel MemWrite)
            ctl_branch      <= '0';
            ctl_branchNe	<= '0';
            ctl_memToReg 	<= '0';

        when "0001" => -- SUB
            ctl_brEnable    <= '1';
            ctl_ulaOp       <= "01";
            muxUlaIn1		<= '0';
            muxBrData   	<= "10";
            ctl_jump        <= '0';
            ctl_memIn       <= '0';
            ctl_branch      <= '0';
            ctl_branchNe	<= '0';
            ctl_memToReg 	<= '0';

        when "0010" => -- MULT
            ctl_brEnable    <= '1';
            ctl_ulaOp       <= "10";
            muxUlaIn1		<= '0';
            muxBrData   	<= "10";
            ctl_jump        <= '0';
            ctl_memIn       <= '0';
            ctl_branch      <= '0';
            ctl_branchNe	<= '0';
            ctl_memToReg 	<= '0';

        -- ==========================================
        -- DESVIOS (Jumps e Branches)
        -- ==========================================
        when "0011" => -- JMP
            ctl_brEnable    <= '0';
            ctl_ulaOp       <= "11";
            muxUlaIn1		<= '0';
            muxBrData  		<= "10";
            ctl_jump        <= '1';
            ctl_memIn       <= '0';
            ctl_branch      <= '0';
            ctl_branchNe	<= '0';
            ctl_memToReg 	<= '0';

        when "0100" => -- BEQ
            ctl_brEnable    <= '0';
            ctl_ulaOp       <= "11";
            muxUlaIn1		<= '0';
            muxBrData   	<= "10";
            ctl_jump        <= '0';
            ctl_memIn       <= '0';
            ctl_branch      <= '1';
            ctl_branchNe	<= '0';
            ctl_memToReg 	<= '0';

        when "0101" => -- BNE
            ctl_brEnable    <= '0';
            ctl_ulaOp       <= "11";
            muxUlaIn1		<= '0';
            muxBrData   	<= "10";
            ctl_jump        <= '0';
            ctl_memIn       <= '0';
            ctl_branch      <= '0';
            ctl_branchNe	<= '1';
            ctl_memToReg 	<= '0';

        -- ==========================================
        -- ACESSO A MEMÓRIA
        -- ==========================================
        when "0110" => -- LW
            ctl_brEnable    <= '1';
            ctl_ulaOp       <= "11";
            muxUlaIn1		<= '0';
            muxBrData   	<= "01";
            ctl_jump        <= '0';
            ctl_memIn       <= '0';
            ctl_branch      <= '0';
            ctl_branchNe	<= '0';
            ctl_memToReg 	<= '1';

        when "0111" => -- SW
            ctl_brEnable    <= '1';
            ctl_ulaOp       <= "11";
            muxUlaIn1		<= '0';
            muxBrData   	<= "10";
            ctl_jump        <= '0';
            ctl_memIn       <= '1';
            ctl_branch      <= '0';
            ctl_branchNe	<= '0';
            ctl_memToReg 	<= '0';

        -- ==========================================
        -- IMEDIATAS (ADDI, SUBI, ETC)
        -- ==========================================
        when "1000" => -- ADDI
            ctl_brEnable    <= '1';
            ctl_ulaOp       <= "00";
            muxUlaIn1		<= '1';
            muxBrData   	<= "10";
            ctl_jump        <= '0';
            ctl_memIn       <= '0';
            ctl_branch      <= '0';
            ctl_branchNe	<= '0';
            ctl_memToReg 	<= '0';

        when "1001" => -- SUBI
            ctl_brEnable    <= '1';
            ctl_ulaOp       <= "01";
            muxUlaIn1		<= '1';
            muxBrData   	<= "10";
            ctl_jump        <= '0';
            ctl_memIn       <= '0';
            ctl_branch      <= '0';
            ctl_branchNe	<= '0';
            ctl_memToReg 	<= '0';

        when "1010" => -- MULTI
            ctl_brEnable    <= '1';
            ctl_ulaOp       <= "10";
            muxUlaIn1		<= '1';
            muxBrData   	<= "10";
            ctl_jump        <= '0';
            ctl_memIn       <= '0';
            ctl_branch      <= '0';
            ctl_branchNe	<= '0';
            ctl_memToReg 	<= '0';

        when "1011" => -- LDI
            ctl_brEnable    <= '1';
            ctl_ulaOp       <= "11";
            muxUlaIn1		<= '0';
            muxBrData   	<= "00";
            ctl_jump        <= '0';
            ctl_memIn       <= '0';
            ctl_branch      <= '0';
            ctl_branchNe	<= '0';
            ctl_memToReg 	<= '0';

        -- ==========================================
        -- SEGURANÇA (Outros casos)
        -- ==========================================
        when others =>
            ctl_brEnable    <= '0';
            ctl_ulaOp       <= "11";
            muxUlaIn1		<= '0';
            muxBrData   	<= "10";
            ctl_jump        <= '0';
            ctl_memIn       <= '0';
            ctl_branch      <= '0';
            ctl_branchNe	<= '0';
            ctl_memToReg 	<= '0';
            
    end case;
end if;
end process;
end behavior;