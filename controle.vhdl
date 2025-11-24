library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity controle is

    Port (	
            i_OPCODE  	: in std_logic_vector(6 downto 0); --- Entrada, 7 bits separados da memoria de instrucoes
            i_FUNCT3    : in std_logic_vector(2 downto 0); -- funct3 for R-type
            i_FUNCT7    : in std_logic_vector(6 downto 0); -- funct7 for R-type
            o_ALU_SRC   : out std_logic; -- sinal de controle para o mux da ULA
            o_MEM2REG    : out std_logic; -- sinal de controle para o mux de escrita no banco
            o_REG_WRITE : out std_logic; -- sinal de controle para escrita no banco de registradores
            o_MEM_READ  : out std_logic; -- sinal de controle para leitura na memoria de dados
            o_MEM_WRITE : out std_logic; -- sinal de controle para escrita na memoria de dados
            o_ALUOP    : out std_logic_vector(2 downto 0) -- sinal de controle para a ULA
            --o_MEM_WRITE : out std_logic -- sinal de controle para escrita na memoria            o_ALUOP    : out std_logic_vector(1 downto 0) -- sinal de controle para a ULA
         );
end controle;

architecture arch_controle of controle is
begin

    process (i_OPCODE, i_FUNCT3, i_FUNCT7)
    begin
        case i_OPCODE is
            when "0010011" => -- I-type (addi, etc.)
                o_ALU_SRC   <= '1'; -- use immediate
                o_MEM2REG   <= '0'; -- use ALU result
                o_REG_WRITE <= '1'; -- write to register
                o_MEM_READ  <= '0';
                o_MEM_WRITE <= '0';
                o_ALUOP     <= "000"; -- ADD operation
            when "0110011" => -- R-type (add, sub, etc.)
                o_ALU_SRC   <= '0'; -- use register
                o_MEM2REG   <= '0'; -- use ALU result
                o_REG_WRITE <= '1'; -- write to register
                o_MEM_READ  <= '0';
                o_MEM_WRITE <= '0';
                -- Decode ALUOP based on funct3 and funct7
                if i_FUNCT3 = "000" and i_FUNCT7 = "0000000" then
                    o_ALUOP <= "000"; -- ADD
                elsif i_FUNCT3 = "000" and i_FUNCT7 = "0100000" then
                    o_ALUOP <= "001"; -- SUB
                elsif i_FUNCT3 = "111" then
                    o_ALUOP <= "010"; -- AND
                elsif i_FUNCT3 = "110" then
                    o_ALUOP <= "011"; -- OR
                elsif i_FUNCT3 = "100" then
                    o_ALUOP <= "100"; -- XOR
                else
                    o_ALUOP <= "000"; -- default
                end if;
            when "0000011" => -- Load (lw)
                o_ALU_SRC   <= '1'; -- use immediate
                o_MEM2REG   <= '1'; -- use memory data
                o_REG_WRITE <= '1'; -- write to register
                o_MEM_READ  <= '1'; -- read from memory
                o_MEM_WRITE <= '0';
                o_ALUOP     <= "000"; -- ADD operation for address calculation
            when "0100011" => -- Store (sw)
                o_ALU_SRC   <= '1'; -- use immediate
                o_MEM2REG   <= '0'; -- not used
                o_REG_WRITE <= '0'; -- no write to register
                o_MEM_READ  <= '0';
                o_MEM_WRITE <= '1'; -- write to memory
                o_ALUOP     <= "000"; -- ADD operation for address calculation
            when others =>
                o_ALU_SRC   <= '0';
                o_MEM2REG   <= '0';
                o_REG_WRITE <= '0';
                o_MEM_READ  <= '0';
                o_MEM_WRITE <= '0';
                o_ALUOP     <= "000";
        end case;
    end process;

end arch_controle;