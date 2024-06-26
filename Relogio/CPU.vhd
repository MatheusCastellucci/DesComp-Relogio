	library ieee;
use ieee.std_logic_1164.all;

entity CPU is
  generic (
 	 larguraDados      : natural := 8;
	 larguraEnderecos  : natural := 9
  );
  -- Total de bits das entradas e saidas
  port   (
	 -- Entradas
	 Clock         : in  std_logic;
    Instruction_IN: in  std_logic_vector(14 downto 0);   
	 Data_IN       : in  std_logic_vector((larguraDados-1) downto 0);
	 
	 -- Saidas
	 Wr            : out std_logic;
	 Rd            : out std_logic;
	 ROM_Address   : out std_logic_vector((larguraEnderecos-1) downto 0);
    Data_OUT      : out std_logic_vector((larguraDados-1) downto 0);
    Data_Address  : out std_logic_vector((larguraEnderecos-1) downto 0)
  );
end entity;

-- Como na outra parte do projeto, temos um arquivo que representa o processador (este aqui)
-- Ele funciona basicamente de forma igual (tirando os novos bits) ao processador feito para as atividades de aula
architecture arquitetura of CPU is
  signal CLK : std_logic;
  
  signal Palavra_Controle : std_logic_vector (11 downto 0);
  signal Habilita_A : std_logic;
  signal habFlagIgual: std_logic;
  
  -- ULA
  signal SelMUX      : std_logic;
  signal flagSaidaUla: std_logic;
  signal DadoOut     : std_logic_vector((larguraDados-1) downto 0);
  signal MUX_REG1    : std_logic_vector((larguraDados-1) downto 0);
  signal Saida_ULA   : std_logic_vector((larguraDados-1) downto 0);
  signal Operacao_ULA: std_logic_vector(1 downto 0);
  
  -- PC/incrementaPC
  signal habEscRET: std_logic;
  signal Mux_PC   : std_logic_vector((larguraEnderecos-1) downto 0);
  signal Endereco : std_logic_vector((larguraEnderecos-1) downto 0);
  signal proxPC   : std_logic_vector((larguraEnderecos-1) downto 0);
  signal saidaRET : std_logic_vector((larguraEnderecos-1) downto 0);
   
  -- Desvio
  signal JMP      : std_logic;
  signal JEQ      : std_logic;
  signal JSR      : std_logic;
  signal RET      : std_logic;
  signal flagzero : std_logic;
  signal saidaDesv: std_logic_vector(1 downto 0);

  --AGORA AS INT+STRUÇÔES TEM 15 BITS, EBAA!!!
  alias opcode           is Instruction_IN(14 downto 11);
  alias ende_registrador is Instruction_IN(10 downto 9);
  alias imediato_address is Instruction_IN(8 downto 0);
  alias imediato_value   is Instruction_IN(7 downto 0);

begin

-- Instanciando o CLOCK:
CLK <= Clock;

-- =========Port Map dos componentes que interagem com a ULA=========		
MUX1 :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
        port map( entradaA_MUX => Data_IN,
                  entradaB_MUX => imediato_value,
                  seletor_MUX  => SelMUX,
                  saida_MUX    => MUX_REG1);

ULA1 : entity work.ULASomaSub  generic map(larguraDados => larguraDados)
          port map (entradaA =>DadoOut, entradaB => MUX_REG1, saida => Saida_ULA, flagZero => flagSaidaUla  ,seletor => Operacao_ULA);
			 
-- Agora como vamos fazer um arquitetura RegMem, precisamos de mais registradores conectados diretamente entre a ULA e a RAM, mais facil fazer um arquivo com todos
REGs: entity work.bancoRegistradoresArqRegMem   generic map (larguraDados => larguraDados, larguraEndBancoRegs => 2)
          port map ( clk => CLK,
							endereco => ende_registrador,
							dadoEscrita => Saida_ULA,
							habilitaEscrita => Habilita_A,
							saida  => DadoOut);

FLAG_ZERO : entity work.FlipFlop
		  port map (DIN => flagSaidaUla,
					   DOUT => flagzero,
					   ENABLE => habFlagIgual,
						CLK => CLK,
						RST => '0');

--             =========Fim do bloquinho da ULA=========	
	
				  
-- =========Bloquinho do Program Counter e jumps=========
PC : entity work.registradorGenerico   generic map (larguraDados => larguraEnderecos)
          port map (DIN => Mux_PC, DOUT => Endereco, ENABLE => '1', CLK => CLK, RST => '0');

incrementaPC :  entity work.somaConstante  generic map (larguraDados => larguraEnderecos, constante => 1)
        port map( entrada => Endereco, saida => proxPC);
		  
MUX2 : entity work.muxGenerico4x1  generic map (larguraDados => larguraEnderecos)
        port map(entrada0_MUX => proxPC,
                 entrada1_MUX => imediato_address,
					  entrada2_MUX => saidaRET,
					  entrada3_MUX => "000000000", 
                 seletor_MUX => saidaDesv,
                 saida_MUX => Mux_PC);
					  
DESVIO : entity work.logicaDesvia 
			port map( JEQ => JEQ,
						 Flag_Igual  => flagzero,
						 JMP => JMP,
						 RET => RET,
						 JSR => JSR,
						 saida => saidaDesv);
						 
ENDRET : entity work.registradorGenerico   generic map (larguraDados => larguraEnderecos)
          port map (DIN => proxPC, DOUT => saidaRET, ENABLE => habEscRET, CLK => CLK, RST => '0');
			 
-- =========Fim do bloquinho de pulo=========

	
-- Port Map do decoder responsável por definir is sinais de controle
DECO : entity work.decoderInstru 
          port map (opcode => opcode, saida => Palavra_Controle);

-- Fazendo as ligações de sinais
ROM_Address  <= Endereco;
Data_OUT     <= DadoOut;
Data_Address <= imediato_address;

habEscRET    <= Palavra_Controle(11);
JMP          <= Palavra_Controle(10);
RET          <= Palavra_Controle(9);
JSR          <= Palavra_Controle(8);
JEQ          <= Palavra_Controle(7);
selMUX       <= Palavra_Controle(6);
Habilita_A   <= Palavra_Controle(5);
Operacao_ULA <= Palavra_Controle(4 downto 3);
habFlagIgual <= Palavra_Controle(2);
Rd           <= Palavra_Controle(1);
Wr           <= Palavra_Controle(0);
end architecture;