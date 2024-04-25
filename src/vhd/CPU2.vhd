-- Elementos de Sistemas
-- developed by Luciano Soares
-- file: CPU.vhd
-- date: 4/4/2017

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity CPU2 is
  port(
    clock:       in  STD_LOGIC;                        -- sinal de clock para CPU
    reset:       in  STD_LOGIC;                        -- reinicia toda a CPU (inclusive o Program Counter)
    inM:         in  STD_LOGIC_VECTOR(15 downto 0);    -- dados lidos da memória RAM
    instruction: in  STD_LOGIC_VECTOR(19 downto 0);    -- instrução (dados) vindos da memória ROM
    outM:        out STD_LOGIC_VECTOR(15 downto 0);    -- dados para gravar na memória RAM
    writeM:      out STD_LOGIC;                        -- faz a memória RAM gravar dados da entrada
    addressM:    out STD_LOGIC_VECTOR(14 downto 0);    -- envia endereço para a memória RAM
    pcout:       out STD_LOGIC_VECTOR(14 downto 0)     -- endereço para ser enviado a memória ROM
    );
end entity;

architecture arch of CPU2 is

  component Mux16 is
    port (
      a:   in  STD_LOGIC_VECTOR(15 downto 0);
      b:   in  STD_LOGIC_VECTOR(15 downto 0);
      sel: in  STD_LOGIC;
      q:   out STD_LOGIC_VECTOR(15 downto 0)
      );
  end component;

  component Mux8Way16 is
	port ( 
			a:   in  STD_LOGIC_VECTOR(15 downto 0);
			b:   in  STD_LOGIC_VECTOR(15 downto 0);
			c:   in  STD_LOGIC_VECTOR(15 downto 0);
			d:   in  STD_LOGIC_VECTOR(15 downto 0);
			e:   in  STD_LOGIC_VECTOR(15 downto 0);
			f:   in  STD_LOGIC_VECTOR(15 downto 0);
			g:   in  STD_LOGIC_VECTOR(15 downto 0);
			h:   in  STD_LOGIC_VECTOR(15 downto 0);
			sel: in  STD_LOGIC_VECTOR(2 downto 0);
			q:   out STD_LOGIC_VECTOR(15 downto 0));
  end component;

  component ALU is
    port (
      x,y:   in STD_LOGIC_VECTOR(15 downto 0);
      zx:    in STD_LOGIC;
      nx:    in STD_LOGIC;
      zy:    in STD_LOGIC;
      ny:    in STD_LOGIC;
      f:     in STD_LOGIC;
      no:    in STD_LOGIC;
      zr:    out STD_LOGIC;
      ng:    out STD_LOGIC;
      saida: out STD_LOGIC_VECTOR(15 downto 0)
      );
  end component;

  component Register16 is
    port(
      clock:   in std_logic;
      input:   in STD_LOGIC_VECTOR(15 downto 0);
      load:    in std_logic;
      output: out STD_LOGIC_VECTOR(15 downto 0)
      );
  end component;

  component pc is
    port(
      clock     : in  STD_LOGIC;
      increment : in  STD_LOGIC;
      load      : in  STD_LOGIC;
      reset     : in  STD_LOGIC;
      input     : in  STD_LOGIC_VECTOR(15 downto 0);
      output    : out STD_LOGIC_VECTOR(15 downto 0)
      );
  end component;

  component ControlUnit is
    port(
      instruction                 : in STD_LOGIC_VECTOR(19 downto 0);
      zr,ng                       : in STD_LOGIC;
      muxALUI                     : out STD_LOGIC;                
		  muxX                        : out STD_LOGIC_VECTOR(2 downto 0);
      muxY                        : out STD_LOGIC_VECTOR(2 downto 0);
      zx, nx, zy, ny, f, no       : out STD_LOGIC;
      loadA, loadB, loadC, loadD, loadE, loadF, loadG, loadM, loadPC : out STD_LOGIC
      );
  end component;

  signal c_muxALUI: STD_LOGIC;
  signal c_muxX: STD_LOGIC_VECTOR(2 downto 0);
  signal c_muxY: STD_LOGIC_VECTOR(2 downto 0);
  signal c_zx: STD_LOGIC;
  signal c_nx: STD_LOGIC;
  signal c_zy: STD_LOGIC;
  signal c_ny: STD_LOGIC;
  signal c_f: STD_LOGIC;
  signal c_no: STD_LOGIC;
  signal c_loadA: STD_LOGIC;
  signal c_loadB: STD_LOGIC;
  signal c_loadC: STD_LOGIC;
  signal c_loadD: STD_LOGIC;
  signal c_loadE: STD_LOGIC;
  signal c_loadF: STD_LOGIC;
  signal c_loadG: STD_LOGIC;
  signal c_loadPC: STD_LOGIC;
  signal c_zr: std_logic := '0';
  signal c_ng: std_logic := '0';

  signal s_muxALUI_out: STD_LOGIC_VECTOR(15 downto 0);
  signal s_muxX_out: STD_LOGIC_VECTOR(15 downto 0);
  signal s_muxY_out: STD_LOGIC_VECTOR(15 downto 0);
  signal s_regAout: STD_LOGIC_VECTOR(15 downto 0);
  signal s_regBout: STD_LOGIC_VECTOR(15 downto 0);
  signal s_regCout: STD_LOGIC_VECTOR(15 downto 0);
  signal s_regDout: STD_LOGIC_VECTOR(15 downto 0);
  signal s_regEout: STD_LOGIC_VECTOR(15 downto 0);
  signal s_regFout: STD_LOGIC_VECTOR(15 downto 0);
  signal s_regGout: STD_LOGIC_VECTOR(15 downto 0);
  signal s_ALUout: STD_LOGIC_VECTOR(15 downto 0);

  signal s_pcout: STD_LOGIC_VECTOR(15 downto 0);

begin


  r1: register16 port map(
    clock => clock, 
    input => s_muxALUI_Aout,
    load => c_loadA,
    output => s_regAout
  );

  r2: register16 port map(
    clock => clock, 
    input => s_muxALUI_Aout,
    load => c_loadB,
    output => s_regBout
  );

  r3: register16 port map(
    clock => clock, 
    input => s_muxALUI_Aout,
    load => c_loadC,
    output => s_regCout
  );

  r4: register16 port map(
    clock => clock, 
    input => s_muxALUI_Aout,
    load => c_loadD,
    output => s_regDout
  );

  r5: register16 port map(
    clock => clock, 
    input => s_muxALUI_Aout,
    load => c_loadE,
    output => s_regEout
  );

  r6: register16 port map(
    clock => clock, 
    input => s_muxALUI_Aout,
    load => c_loadF,
    output => s_regFout
  );

  r7: register16 port map(
    clock => clock, 
    input => s_muxALUI_Aout,
    load => c_loadG,
    output => s_regGout
  );
  
  mux: Mux8Way16 port map(
    a => s_regAout,
    b => s_regBout,
    c => s_regCout,
    d => s_regDout,
    e => s_regEout,
    f => s_regFout,
    g => s_regGout,
    h => inM,
    sel => c_muxX,
    q => s_muxX_out
  );

  mux2: Mux8Way16 port map(
    a => s_regAout,
    b => s_regBout,
    c => s_regCout,
    d => s_regDout,
    e => s_regEout,
    f => s_regFout,
    g => s_regGout,
    h => inM,
    sel => c_muxY,
    q => s_muxY_out
  );

  mux3: Mux8Way16 port map(
    a => s_regAout,
    b => s_regBout,
    c => s_regCout,
    d => s_regDout,
    e => s_regEout,
    f => s_regFout,
    g => s_regGout,
    h => inM,
    sel => c_muxY,
    q => s_muxPC_out
  );

  pc: pc port map(
    clock => clock,
    increment => increment,
    load => c_loadPC,
    reset => reset,
    input => s_muxPC_out,
    output => s_pcout
    );
  






end architecture;
