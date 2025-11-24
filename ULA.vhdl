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
        i_ALUOP : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- 2 bits do campo ALUOp
        o_ZERO : IN STD_LOGIC;
        o_ULA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

END ULA;

ARCHITECTURE a1 OF ULA IS
BEGIN PROCESS (i_A, i_B, i_F3, i_INST30)
BEGIN
    IF (i_OPCODE = "0000011") THEN -- Load Word (LW)
        o_ULA <= i_A + i_B; -- endereco calculado somando base + offset
    ELSIF (i_OPCODE = "0100011") THEN -- Store Word (SW)
        o_ULA <= i_A + i_B; -- endereco calculado somando base + offset
    ELSIF (i_OPCODE = "0010011" OR i_OPCODE = "0110011") THEN -- I-type e R-type
        IF (i_F3 = "000") THEN
            IF (i_INST30 = '0') THEN
                o_ULA <= i_A + i_B;
            ELSE
                o_ULA <= i_A - i_B;
            END IF;
        ELSIF (i_F3 = "100") THEN
            o_ULA <= i_A XOR i_B;
        ELSIF (i_F3 = "111") THEN
            o_ULA <= i_A AND i_B;
        ELSIF (i_F3 = "110") THEN
            o_ULA <= i_A OR i_B;
        ELSIF (i_F3 = "010") THEN
            IF i_A < i_B THEN
                o_ULA <= "00000000000000000000000000000001"; -- set less than
            ELSE
                o_ULA <= "00000000000000000000000000000000";
            END IF;
        ELSE
            o_ULA <= (OTHERS => '0');
        END IF;
    END IF;
    -- https://lists.riscv.org/g/tech-unprivileged/attachment/535/0/unpriv-isa-asciidoc.pdf 
END PROCESS;
END a1;