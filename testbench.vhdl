library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity testbench is
-- empty
end testbench; 

architecture test_1 of testbench is
    -- sinais do testbench
    signal STOP  : BOOLEAN;
    constant PERIOD: TIME := 10 NS;
    signal cycle : integer := 0;
    
    -- sinais do DUV
    signal w_CLK, w_RSTn    : std_logic := '0';
    signal w_INST            : std_logic_vector(31 downto 0);
    signal w_OPCODE            : std_logic_vector(6 downto 0);
    signal w_RD_ADDR        : std_logic_vector(4 downto 0);
    signal w_RS1_ADDR         : std_logic_vector(4 downto 0);
    signal w_RS2_ADDR         : std_logic_vector(4 downto 0);
    signal w_RS1_DATA         : std_logic_vector(31 downto 0);
    signal w_RS2_DATA         : std_logic_vector(31 downto 0);
    signal w_IMM             : std_logic_vector(31 downto 0);
    signal w_ULA             : std_logic_vector(31 downto 0);
    signal w_MEM             : std_logic_vector(31 downto 0);
    signal w_RD_DATA         : std_logic_vector(31 downto 0);

    -- helper: convert std_logic_vector to string (binary)
    function slv_to_string(slv: std_logic_vector) return string is
        variable res : string(1 to slv'length);
        variable idx : integer := 1;
    begin
        for i in slv'range loop
            if slv(i) = '1' then
                res(idx) := '1';
            else
                res(idx) := '0';
            end if;
            idx := idx + 1;
        end loop;
        return res;
    end function;

begin

    -- Connect DUV
    u_DUV: entity work.RISCV32i(arch_2) 
             port map(
                 i_CLK      => w_CLK,
                 i_RSTn     => w_RSTn,
                 o_INST     => w_INST,
                 o_OPCODE   => w_OPCODE,
                 o_RD_ADDR  => w_RD_ADDR,
                 o_RS1_ADDR => w_RS1_ADDR,
                 o_RS2_ADDR => w_RS2_ADDR,
                 o_RS1_DATA => w_RS1_DATA,
                 o_RS2_DATA => w_RS2_DATA,
                 o_IMM      => w_IMM,
                 o_ULA      => w_ULA,
                 o_MEM      => w_MEM,
                 o_RD_DATA  => w_RD_DATA
    );

    -- Gerador de CLOCK
    u_CLK_GEN: process
    begin
      while not STOP loop
            w_CLK <= '0';
            wait for PERIOD/2;
            w_CLK <= '1';
            wait for PERIOD/2;
      end loop;
      wait;
    end process u_CLK_GEN;

    -- monitor: imprime o RD e seu conte�do a cada ciclo
    monitor_proc: process
    begin
        wait until rising_edge(w_CLK);
        cycle <= cycle + 1;
        report "Cycle " & integer'image(cycle) & " | RD_addr=" & integer'image(to_integer(unsigned(w_RD_ADDR))) & " | RD_data=" & slv_to_string(w_RD_DATA);
    end process;

  process
    begin
      -- IN�CIO DA SIMULA��O (todas as entradas em zero)
      STOP <= FALSE;
      w_RSTn  <= '0';
      wait  for PERIOD;
      
      w_RSTn  <= '1'; --para de resetar
      wait  for PERIOD; -- cada um desses � o tempo de uma instru��o
      wait  for PERIOD;
      wait  for PERIOD;
      wait  for PERIOD;
      wait  for PERIOD;
      
      wait  for PERIOD;
      wait  for PERIOD;
      wait  for PERIOD;
      wait  for PERIOD;
      wait  for PERIOD;

      -- FIM DA SIMULA��O
      STOP <= TRUE;
      wait;
  end process;
    

end test_1;
