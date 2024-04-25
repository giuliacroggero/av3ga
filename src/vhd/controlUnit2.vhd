-- Elementos de Sistemas
-- developed by Luciano Soares
-- date: 4/4/2017
-- Modificação:
--   - Renan : prova Av3
--
-- Unidade que controla os componentes da CPU

library ieee;
use ieee.std_logic_1164.all;

entity controlUnit2 is
    port(
		instruction                 : in STD_LOGIC_VECTOR(19 downto 0);
		zr,ng                       : in STD_LOGIC;
		muxALUI                     : out STD_LOGIC;                
		muxX                        : out STD_LOGIC_VECTOR(2 downto 0);
    muxY                        : out STD_LOGIC_VECTOR(2 downto 0);
		zx, nx, zy, ny, f, no       : out STD_LOGIC;
    loadA, loadB, loadC, loadD, loadE, loadF, loadG, loadM, loadPC : out STD_LOGIC
    );
end entity;

architecture arch of controlUnit2 is

begin

  --===============================================================--
  -- proponha de um novo formato de instrução que implemente a modificação solicitada
  -- não precisa implementar os demais

  --O novo formato de instrução para um salto com registrador de destino poderia ser estruturado da seguinte forma:

  --Bits 19-17: Tipo de Instrução 
  --Bits 16-14: Identificador do Registrador de Destino 
  --Bits 13-0: Campo de uso específico da instrução 
  --===============================================================--





end architecture;
