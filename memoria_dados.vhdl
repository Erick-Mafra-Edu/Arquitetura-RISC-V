library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity memoria_dados is

  Port (	i_CLK  	: in std_logic;
        i_MEM_WRITE : in std_logic;
        i_MEM_READ  : in std_logic;
        i_ADDR  	: in std_logic_vector(31 downto 0);
        i_DATA 	: in std_logic_vector(31 downto 0);
        o_DATA 	: out std_logic_vector(31 downto 0)
      );
end memoria_dados;

architecture arch_memoria_dados of memoria_dados is
  
  type t_MEMORIA is array(0 to 255) of std_logic_vector(7 downto 0); -- memoria de dados com 256 palavras de 8 bits
  signal memoria : t_MEMORIA := (others => (others => '0'));
  
begin
  -- Processo de escrita (sincrono) e Processo de leitura (combinacional)
  process(i_CLK, i_MEM_WRITE, i_ADDR, i_MEM_READ, memoria)
    variable addr_int : integer;
  begin
    if rising_edge(i_CLK) then
      if i_MEM_WRITE = '1' then
        addr_int := to_integer(unsigned(i_ADDR));
        if addr_int >= 0 and addr_int < 252 then -- 256 - 4 bytes
          memoria(addr_int)     <= i_DATA(7 downto 0);  
          memoria(addr_int + 1) <= i_DATA(15 downto 8);
          memoria(addr_int + 2) <= i_DATA(23 downto 16);
          memoria(addr_int + 3) <= i_DATA(31 downto 24);
        end if;
      end if;
    end if;
    if i_MEM_READ = '1' then
      addr_int := to_integer(unsigned(i_ADDR));
      if addr_int >= 0 and addr_int < 252 then
        o_DATA <= memoria(addr_int + 3) & memoria(addr_int + 2) & 
                  memoria(addr_int + 1) & memoria(addr_int);
      else
        o_DATA <= (others => '0');
      end if;
    else
      o_DATA <= (others => '0');
    end if;
  end process;


end architecture arch_memoria_dados;