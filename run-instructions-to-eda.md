# Configuração do EDA Playground para RISC-V

## Passo 1: Acesse o EDA Playground
1. Vá para: https://www.edaplayground.com/
2. Clique em "Sign Up" se não tiver conta, ou "Log In"

## Passo 2: Configure o Ambiente
1. **Testbench + Design**: Selecione esta opção
2. **Simulator**: Escolha **GHDL**
3. **Language**: **VHDL**
4. **Library**: **IEEE**

## Passo 3: Adicione os Arquivos

### Ordem de Upload (IMPORTANTE):
1. `ffd.vhdl` - Registrador PC
2. `somador.vhdl` - Somador de endereços
3. `memoria_instrucoes.vhdl` - Memória de instruções
4. `gerador_imediato.vhdl` - Gerador de imediatos
5. `banco_registradores.vhdl` - Banco de registradores
6. `ULA.vhdl` - Unidade Lógica Aritmética
7. `mux21.vhdl` - Multiplexador 2:1
8. `controle.vhdl` - Unidade de controle
9. `memoria_dados.vhdl` - Memória de dados
10. `design.vhdl` - Top-level RISCV32i
11. `testbench.vhdl` - Testbench

## Passo 4: Comando de Compilação

### Para evitar conflitos de operadores:
```bash
ghdl -i -fexplicit '-fsynopsys' ffd.vhdl somador.vhdl memoria_instrucoes.vhdl gerador_imediato.vhdl banco_registradores.vhdl ULA.vhdl mux21.vhdl controle.vhdl memoria_dados.vhdl design.vhdl testbench.vhdl
```

### Ou use o padrão moderno:
```bash
ghdl -i --std=08 -fsynopsys ffd.vhdl somador.vhdl memoria_instrucoes.vhdl gerador_imediato.vhdl banco_registradores.vhdl ULA.vhdl mux21.vhdl controle.vhdl memoria_dados.vhdl design.vhdl testbench.vhdl
```

## Passo 5: Comando de Elaboração
```bash
ghdl -m -fexplicit '-fsynopsys' testbench
```
ou
```bash
ghdl -m --std=08 -fsynopsys testbench
```

## Passo 6: Comando de Simulação
```bash
ghdl -r -fexplicit '-fsynopsys' testbench --vcd=dump.vcd
```
ou
```bash
ghdl -r --std=08 -fsynopsys testbench --vcd=dump.vcd
```

## Passo 7: Visualize os Resultados
1. Após a simulação, clique na aba **Waveforms**
2. Procure pelo arquivo `dump.vcd`
3. Visualize as formas de onda

## Dicas Importantes

### Problemas Comuns:
1. **Erro "operator overloaded"**: Use `-fexplicit`
2. **Erro "to_integer not found"**: Use `conv_integer` em vez de `to_integer(unsigned())`
3. **Arquitetura obsoleta**: Recompile todos os arquivos

### Ordem dos Arquivos:
- Sempre coloque as dependências primeiro
- Entidades base antes das que as usam

### Verificação:
- Procure por "Cycle X | RD_data=" nos reports
- Valores devem aparecer corretamente (1, 2, 3, 4, 13, -1, etc.)

## Exemplo de Output Esperado:
```
Cycle 0 | RD_addr=5 | RD_data=00000001 | REG_WRITE='1'
Cycle 1 | RD_addr=5 | RD_data=00000001 | REG_WRITE='1'
Cycle 2 | RD_addr=6 | RD_data=00000010 | REG_WRITE='1'
...
```

## Modificações para EDA Playground

### 1. Conversões Numéricas
**Problema**: `to_integer(unsigned())` não funciona no EDA Playground
**Solução**: Use `conv_integer()` do `std_logic_unsigned`

**Antes:**
```vhdl
addr_int := to_integer(unsigned(addr_slv));
```

**Depois:**
```vhdl
addr_int := conv_integer(addr_slv);
```

### 2. Operadores Sobrecarregados
**Problema**: Conflito entre `std_logic_unsigned` e `std_logic_1164`
**Solução**: Use `-fexplicit` para desambiguar

### 3. Ordem de Compilação
**IMPORTANTE**: Compile na ordem de dependências:
1. Componentes básicos primeiro
2. Componentes que usam outros depois
3. Testbench por último

## Comandos Completos para EDA Playground

### Compilação (uma linha):
```bash
ghdl -i -fexplicit '-fsynopsys' ffd.vhdl somador.vhdl memoria_instrucoes.vhdl gerador_imediato.vhdl banco_registradores.vhdl ULA.vhdl mux21.vhdl controle.vhdl memoria_dados.vhdl design.vhdl testbench.vhdl && ghdl -m -fexplicit '-fsynopsys' testbench && ghdl -r -fexplicit '-fsynopsys' testbench --vcd=dump.vcd
```

### Ou passo a passo:
```bash
# Análise
ghdl -i -fexplicit '-fsynopsys' ffd.vhdl somador.vhdl memoria_instrucoes.vhdl gerador_imediato.vhdl banco_registradores.vhdl ULA.vhdl mux21.vhdl controle.vhdl memoria_dados.vhdl design.vhdl testbench.vhdl

# Elaboração
ghdl -m -fexplicit '-fsynopsys' testbench

## Resultados Esperados

### Output do Console:
Após a simulação bem-sucedida, você deve ver:

```
testbench.vhdl:88:9:@5ns:(report note): Cycle 0 | RD_addr=5 | RD_data=00000001 | REG_WRITE='1'
testbench.vhdl:88:9:@15ns:(report note): Cycle 1 | RD_addr=5 | RD_data=00000001 | REG_WRITE='1'
testbench.vhdl:88:9:@25ns:(report note): Cycle 2 | RD_addr=6 | RD_data=00000010 | REG_WRITE='1'
testbench.vhdl:88:9:@35ns:(report note): Cycle 3 | RD_addr=7 | RD_data=00000011 | REG_WRITE='1'
testbench.vhdl:88:9:@45ns:(report note): Cycle 4 | RD_addr=28 | RD_data=00000100 | REG_WRITE='1'
testbench.vhdl:88:9:@55ns:(report note): Cycle 5 | RD_addr=29 | RD_data=00000101 | REG_WRITE='1'
testbench.vhdl:88:9:@65ns:(report note): Cycle 6 | RD_addr=30 | RD_data=00000110 | REG_WRITE='1'
testbench.vhdl:88:9:@75ns:(report note): Cycle 7 | RD_addr=31 | RD_data=00000111 | REG_WRITE='1'
testbench.vhdl:88:9:@85ns:(report note): Cycle 8 | RD_addr=8 | RD_data=00001101 | REG_WRITE='1'
testbench.vhdl:88:9:@95ns:(report note): Cycle 9 | RD_addr=9 | RD_data=ffffffff | REG_WRITE='1'
```

### Interpretação:
- **Cycle 0-3**: `addi` carregando registradores t0-t3 com valores 1-4
- **Cycle 8**: `add s0, t5, t6` = 6 + 7 = 13 (0x0D)
- **Cycle 9**: `sub s1, t0, t1` = 1 - 2 = -1 (0xFFFFFFFF)

### Waveforms:
No visualizador de ondas, você pode ver:
- Clock e sinais de controle
- Valores dos registradores mudando
- Saídas da ULA
- Sinais de endereço e dados

## Checklist Final:
- [ ] Todos os arquivos .vhdl foram uploaded
- [ ] Ordem de compilação correta
- [ ] Comando usa `-fexplicit`
- [ ] Simulação gera dump.vcd
- [ ] Output mostra valores corretos nos registradores
- [ ] Nenhuma mensagem de erro</content>
<parameter name="filePath">c:\Users\Erick\Arquitetura\run-instructions-to-eda.md
