library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity controle is
	port(
		opcode			: in std_logic;
		brEnable		: out std_logic; 
		ulaOp			: out std_logic_vector (1 downto 0);
		ulaIn1			: out std_logic;
		muxUlaIn1		: out std_logic;
		muxBrData		: out std_logic;
		jump			: out std_logic;
		memIn			: out std_logic;
		branch			: out std_logic;
	);
end entity;
architecture behavior of controle is
begin




process(opcode)
begin

case opcode is
    
        -- ==========================================
        -- TIPO R (Aritméticas)
        -- ==========================================
        when "0000" => -- ADD
            brEnable    <= '1';
            ulaOp       <= "00";
            ulaIn1		<= '0';
            muxBrData   <= (others => '0');
            jump        <= '0';
            memIn       <= '0'; -- (Provavel MemWrite)
            branch      <= '0';

        when "0001" => -- SUB
            brEnable    <= '1';
            ulaOp       <= "01";
            ulaIn1		<= '0';
            muxBrData   <= (others => '0');
            jump        <= '0';
            memIn       <= '0';
            branch      <= '0';

        when "0010" => -- MULT
            brEnable    <= '1';
            ulaOp       <= "10";
            ulaIn1		<= '0';
            muxBrData   <= (others => '0');
            jump        <= '0';
            memIn       <= '0';
            branch      <= '0';

        -- ==========================================
        -- DESVIOS (Jumps e Branches)
        -- ==========================================
        when "0011" => -- JMP
            brEnable    <= '0';
            ulaOp       <= "11";
            ulaIn1		<= '0';
            muxBrData   <= (others => '0');
            jump        <= '0';
            memIn       <= '0';
            branch      <= '0';

        when "0100" => -- BEQ
            brEnable    <= '0';
            ulaOp       <= "11";
            ulaIn1		<= '0';
            muxBrData   <= (others => '0');
            jump        <= '0';
            memIn       <= '0';
            branch      <= '0';

        when "0101" => -- BNE
            brEnable    <= '0';
            ulaOp       <= "11";
            ulaIn1		<= '0';
            muxBrData   <= (others => '0');
            jump        <= '0';
            memIn       <= '0';
            branch      <= '0';

        -- ==========================================
        -- ACESSO A MEMÓRIA
        -- ==========================================
        when "0110" => -- LW
            brEnable    <= '1';
            ulaOp       <= "11";
            ulaIn1		<= '0';
            muxBrData   <= (others => '0');
            jump        <= '0';
            memIn       <= '0';
            branch      <= '0';

        when "0111" => -- SW
            brEnable    <= '1';
            ulaOp       <= "11";
            ulaIn1		<= '0';
            muxBrData   <= (others => '0');
            jump        <= '0';
            memIn       <= '0';
            branch      <= '0';

        -- ==========================================
        -- IMEDIATAS (ADDI, SUBI, ETC)
        -- ==========================================
        when "1000" => -- ADDI
            brEnable    <= '1';
            ulaOp       <= "00";
            ulaIn1		<= '1';
            muxBrData   <= (others => '0');
            jump        <= '0';
            memIn       <= '0';
            branch      <= '0';

        when "1001" => -- SUBI
            brEnable    <= '1';
            ulaOp       <= "01";
            ulaIn1		<= '1';
            muxBrData   <= (others => '0');
            jump        <= '0';
            memIn       <= '0';
            branch      <= '0';

        when "1010" => -- MULTI
            brEnable    <= '1';
            ulaOp       <= "10";
            ulaIn1		<= '1';
            muxBrData   <= (others => '0');
            jump        <= '0';
            memIn       <= '0';
            branch      <= '0';

        when "1011" => -- LDI
            brEnable    <= '1';
            ulaOp       <= "11";
            ulaIn1		<= '0';
            muxBrData   <= (others => '0');
            jump        <= '0';
            memIn       <= '0';
            branch      <= '0';

        -- ==========================================
        -- SEGURANÇA (Outros casos)
        -- ==========================================
        when others =>
            brEnable    <= '0';
            ulaOp       <= "11";
            ulaIn1		<= '0';
            muxBrData   <= (others => '0');
            jump        <= '0';
            memIn       <= '0';
            branch      <= '0';
            
    end case;

end process;
end behavior;