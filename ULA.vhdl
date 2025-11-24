--ULA incompleta, faltando instucao
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
ENTITY ULA IS

    PORT (
        i_A : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --std_logic_vector esimilar a bit_vector
        i_B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        i_OPCODE : IN STD_LOGIC_VECTOR(6 DOWNTO 0); -- 7 bits do campo opcode
        i_F3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3 bits do campo funct3
        i_INST30 : IN STD_LOGIC;
        i_ALUOP : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3 bits do campo ALUOp
        o_ZERO : IN STD_LOGIC;
        o_ULA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

END ULA;

ARCHITECTURE a1 OF ULA IS
BEGIN PROCESS (i_A, i_B, i_ALUOP)
BEGIN
    case i_ALUOP is
        when "000" => o_ULA <= i_A + i_B; -- ADD
        when "001" => o_ULA <= i_A - i_B; -- SUB
        when "010" => o_ULA <= i_A and i_B; -- AND
        when "011" => o_ULA <= i_A or i_B; -- OR
        when "100" => o_ULA <= i_A xor i_B; -- XOR
        when others => o_ULA <= i_A + i_B; -- default ADD
    end case;
END PROCESS;
END a1;