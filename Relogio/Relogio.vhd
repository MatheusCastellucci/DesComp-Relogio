library ieee;
use ieee.std_logic_1164.all;

entity Relogio is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 8;
        larguraEnderecos : natural := 9;
		  larguraDisplay   : natural := 7;
        simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
	 CLOCK_50        : in std_logic;
    KEY             : in std_logic_vector(3 downto 0);
    SW              : in std_logic_vector(9 downto 0);
	 FPGA_RESET_N    : in std_logic;
    LEDR            : out std_logic_vector(9 downto 0);
	 HEX0, HEX1, HEX2, 
	 HEX3, HEX4, HEX5: out std_logic_vector(6 downto 0)
  );
end entity;


architecture arquitetura of Relogio is
	signal CLK: std_logic;
	signal REG8_out: std_logic_vector(7 downto 0);
	
	--ROM/CPU/RAM
	signal pc_rom      : std_logic_vector(8 downto 0);
	signal saida_rom   : std_logic_vector(14 downto 0);
	signal wr          : std_logic;
	signal rd          : std_logic;
	signal ULA_out     : std_logic_vector(7 downto 0);
	signal Data_Address: std_logic_vector(8 downto 0);
	signal dataIn      : std_logic_vector(7 downto 0);
 
 
	--Parte dos Displays
	signal hex_0     : std_logic_vector((larguraDisplay - 1) downto 0);
	signal hex_1     : std_logic_vector((larguraDisplay - 1) downto 0);
	signal hex_2     : std_logic_vector((larguraDisplay - 1) downto 0);
	signal hex_3     : std_logic_vector((larguraDisplay - 1) downto 0);
	signal hex_4     : std_logic_vector((larguraDisplay - 1) downto 0);
	signal hex_5     : std_logic_vector((larguraDisplay - 1) downto 0);
	
	signal REG4_Out0: std_logic_vector(3 downto 0);
	signal REG4_Out1: std_logic_vector(3 downto 0);
	signal REG4_Out2: std_logic_vector(3 downto 0);
	signal REG4_Out3: std_logic_vector(3 downto 0);
	signal REG4_Out4: std_logic_vector(3 downto 0);
	signal REG4_Out5: std_logic_vector(3 downto 0);
	
	signal habReg4_0: std_logic;
	signal habReg4_1: std_logic;
	signal habReg4_2: std_logic;
	signal habReg4_3: std_logic;
	signal habReg4_4: std_logic;
	signal habReg4_5: std_logic;
	
	-- Decoders 3x8
	signal saida_decoder1: std_logic_vector(7 downto 0);
	signal saida_decoder2: std_logic_vector(7 downto 0);
	
	-- Flip Flops p/ saida da ULA
	signal saida_FF1: std_logic;
	signal saida_FF2: std_logic;
	signal habFF1: std_logic;
	signal habFF2: std_logic;

	-- Flip Flops p/ limpar
	signal saida_FFKEY0: std_logic;
	signal saida_FFKEY1: std_logic;
	signal saida_FFRe: std_logic;
	
	-- EdgeDetectors p/ limpar
	signal saidaEdge0: std_logic;
	signal saidaEdge1: std_logic;
	signal saidaEdge2: std_logic;
	
	-- Sianis para tentar deixar o codigo um pouco mais fácil de entender
	signal habTempo  : std_logic;
	signal limpaTempo: std_logic;
	signal limpaKEY0 : std_logic;
	signal limpaKEY1 : std_logic;
	signal limpaRe   : std_logic;

begin

-- Instanciando os componentes:

-- Para simular, fica mais simples tirar o edgeDetector
gravar:  if simulacao generate
CLK <= CLOCK_50;
else generate
detectorSub0: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => (not KEY(0)), saida => CLK);
end generate;


-- =====Bloquinho de Procesamento=====
ROM : entity work.memoriaROM   generic map (dataWidth => 15, addrWidth => 9)
          port map (Endereco => pc_rom, 
						  Dado => saida_rom);

RAM : entity work.memoriaRAM   generic map (dataWidth => 8, addrWidth => 6)
          port map (addr => Data_Address(5 downto 0),  
						  we => wr, 
						  re => rd,
						  habilita => saida_decoder1(0),
						  clk => CLK,
						  dado_in => ULA_out,
						  dado_out => dataIn);
						  
CPU : entity work.CPU port map (Wr => wr,
										  Rd => rd,
										  ROM_Address => pc_rom,
										  Instruction_IN => saida_rom,
										  Data_IN => dataIn,
										  Data_OUT => ULA_out,
										  Data_Address => Data_Address,
										  Clock => CLK);
										  
-- =========Fim do Procesamento=========							  

--=========Decoders para descobrir onde salvar, onde acender e onde mostrar os =========
Decoder1 : entity work.decoder3x8 port map( entrada => Data_Address (8 downto 6),
													  saida => saida_decoder1);
													  
Decoder2 : entity work.decoder3x8 port map( entrada => Data_Address (2 downto 0),
													  saida => saida_decoder2);
--                  =========Fim dos Decoders=========	
												  
FF1_ULA: entity work.FlipFlop port map (DIN => ULA_out(0),
												DOUT => saida_FF1,
												ENABLE => habFF1,
											   CLK => CLK,
												RST => '0');
												
FF2_ULA: entity work.FlipFlop port map (DIN => ULA_out(0),
												DOUT => saida_FF2,
												ENABLE => habFF2,
											   CLK => CLK,
												RST => '0');
												
-- ========Registrador grande (8Bits) responsável pelos 8 LEDs agupados========		
REG8 : entity work.registradorGenerico   generic map (larguraDados => 8)
          port map (DIN => ULA_out(7 downto 0), 
						  DOUT => REG8_out, 
						  ENABLE => (saida_decoder1(4) and wr and saida_decoder2(0) and (not Data_Address(5))), 
						  CLK => CLK, RST => '0');
						 
TST8: entity work.buffer_3_state_8portas
        port map(entrada => "0000" & SW(3 downto 0), 
					  habilita =>  (rd and (not Data_Address(5)) and saida_decoder2(0) and saida_decoder1(5)), 
					  saida => dataIn);						 
--      ========FIm da parte do registrador de 8bits========					

	  
-- ========Registradores que guardam informação que será repassada para os displays========					 
REG4_0 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => ULA_out(3 downto 0), DOUT => REG4_Out0, ENABLE => habReg4_0, CLK => CLK, RST => '0');
	
REG4_1 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => ULA_out(3 downto 0), DOUT => REG4_Out1, ENABLE => habReg4_1, CLK => CLK, RST => '0');

REG4_2 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => ULA_out(3 downto 0), DOUT => REG4_Out2, ENABLE => habReg4_2, CLK => CLK, RST => '0');
			 
REG4_3 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => ULA_out(3 downto 0), DOUT => REG4_Out3, ENABLE => habReg4_3, CLK => CLK, RST => '0');

REG4_4 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => ULA_out(3 downto 0), DOUT => REG4_Out4, ENABLE => habReg4_4, CLK => CLK, RST => '0');
			 
REG4_5 : entity work.registradorGenerico   generic map (larguraDados => 4)
          port map (DIN => ULA_out(3 downto 0), DOUT => REG4_Out5, ENABLE => habReg4_5, CLK => CLK, RST => '0');
-- ========FIm dos Registradores dos displays========	
			 
-- ========Os 6 Displays de 7segmentos========
display0 :  entity work.conversorHex7Seg
        port map(dadoHex => REG4_Out0,
                 apaga =>  '0', negativo => '0', overFlow =>  '0',
                 saida7seg => hex_0);
					  
display1 :  entity work.conversorHex7Seg
        port map(dadoHex => REG4_Out1,
                 apaga =>  '0', negativo => '0', overFlow =>  '0',
                 saida7seg => hex_1);
				
display2 :  entity work.conversorHex7Seg
        port map(dadoHex => REG4_Out2,
                 apaga =>  '0', negativo => '0', overFlow =>  '0',
                 saida7seg => hex_2);
				
display3 :  entity work.conversorHex7Seg
        port map(dadoHex => REG4_Out3,
                 apaga =>  '0', negativo => '0', overFlow =>  '0',
                 saida7seg => hex_3);
				
display4 :  entity work.conversorHex7Seg
        port map(dadoHex => REG4_Out4,
                 apaga =>  '0', negativo => '0', overFlow =>  '0',
                 saida7seg => hex_4);
				
display5 :  entity work.conversorHex7Seg
        port map(dadoHex => REG4_Out5,
                 apaga =>  '0', negativo => '0', overFlow =>  '0',
                 saida7seg => hex_5);
-- ========FIm dos Displays de 7segmentos========					  

-- ========Buffers TriState responsaveis por guardar a informação relevante para cada Display/LED========
TST10: entity work.buffer_3_state_8portas
        port map(entrada => "0000000" & SW(8), 
					  habilita =>  (rd and (not Data_Address(5)) and saida_decoder2(1) and saida_decoder1(5)), 
					  saida => dataIn);
		
TST11: entity work.buffer_3_state_8portas
        port map(entrada => "0000000" & SW(9), 
					  habilita =>  (rd and (not Data_Address(5)) and saida_decoder2(2) and saida_decoder1(5)), 
					  saida => dataIn);
		 
TST12: entity work.buffer_3_state_8portas
        port map(entrada => "0000000" & saida_FFKEY0, 
					  habilita =>  (rd and Data_Address(5) and saida_decoder2(0) and saida_decoder1(5)), 
					  saida => dataIn);
		 
TST13: entity work.buffer_3_state_8portas
        port map(entrada => "0000000" & saida_FFKEY1, 
					  habilita =>  (rd and Data_Address(5) and saida_decoder2(1) and saida_decoder1(5)), 
					  saida => dataIn);
		 
TST14: entity work.buffer_3_state_8portas
        port map(entrada => "0000000" & KEY(2), 
					  habilita =>  (rd and Data_Address(5) and saida_decoder2(2) and saida_decoder1(5)), 
					  saida => dataIn);
		  
TST15: entity work.buffer_3_state_8portas
        port map(entrada => "0000000" & KEY(3), 
					  habilita =>  (rd and Data_Address(5) and saida_decoder2(3) and saida_decoder1(5)), 
					  saida => dataIn);
		  
TST16: entity work.buffer_3_state_8portas
        port map(entrada => "0000000" & saida_FFRe, 
					  habilita =>  (rd and Data_Address(5) and saida_decoder2(4) and saida_decoder1(5)), 
					  saida => dataIn);

--         ========FIm dos Buffers TriState========	

--========FlipFLops responsaveis por fazer a limpeza dos KEYs========
FFKEY0: entity work.FlipFlop port map (DIN => '1',
												DOUT => saida_FFKEY0,
												ENABLE => '1',
											   CLK => saidaEdge0,
												RST => limpaKEY0);
												
FFKEY1: entity work.FlipFlop port map (DIN => '1',
												DOUT => saida_FFKEY1,
												ENABLE => '1',
											   CLK => saidaEdge1,
												RST => limpaKEY1);
												
FFRe: entity work.FlipFlop port map (DIN => '1',
												DOUT => saida_FFRe,
												ENABLE => '1',
											   CLK => saidaEdge2,
												RST => limpaRe);			
--    ==============FIm dos FlipFLops de limpeza==============


--========EdgeDetectors responsáveis pelos sinais de limopeza usados pelos flipflops acima========
detectorKEY0: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => (not KEY(0)), saida => saidaEdge0);

detectorKEY1: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => (not KEY(1)), saida => saidaEdge1);
		  
detectorRe: work.edgeDetector(bordaSubida)
        port map (clk => CLOCK_50, entrada => (not FPGA_RESET_N), saida => saidaEdge2);
-- ==============FIm dos EdgeDetectors de limpeza==============	


-- ===============Base De Tempo (arquivo próprio, esta explicado no arquivo===============
interfaceBase : entity work.divisorGenerico_e_Interface
              port map (clk => CLOCK_50,
              habilitaLeitura => habTempo,
              limpaLeitura => limpaTempo,
              leituraUmSegundo => dataIn,
				  seletor  => SW(9)
				  );

habTempo <= rd and Data_Address(8) and (not Data_Address(7)) and Data_Address(6) and Data_Address(5) and (not Data_Address(4)) and (not Data_Address(3)) and Data_Address(2)
            and (not Data_Address(1)) and Data_Address(0);-- Só pra ficar mais legivel.
	
limpaTempo <= wr and Data_Address(8) and Data_Address(7) and Data_Address(6) and Data_Address(5) and Data_Address(4) and Data_Address(3) and Data_Address(2)
            and (not Data_Address(1)) and (not Data_Address(0));
-- ===============Fim da Base de Tempo===============
				  
	
-- Fazendo as ligações de sinais usados no codigo

limpaKEY0 <= wr and Data_Address(8) and Data_Address(7) and Data_Address(6) and Data_Address(5) and Data_Address(4) and Data_Address(3) and Data_Address(2)
                  and Data_Address(1) and Data_Address(0);
						
limpaKEY1 <= wr and Data_Address(8) and Data_Address(7) and Data_Address(6) and Data_Address(5) and Data_Address(4) and Data_Address(3) and Data_Address(2)
                  and Data_Address(1) and (not Data_Address(0));
						
limpaRe <= wr and Data_Address(8) and Data_Address(7) and Data_Address(6) and Data_Address(5) and Data_Address(4) and Data_Address(3) and Data_Address(2)
                  and (not Data_Address(1)) and Data_Address(0);
habReg4_5 <= saida_decoder2(5) and Data_Address(5) and saida_decoder1(4) and wr;
habReg4_4 <= saida_decoder2(4) and Data_Address(5) and saida_decoder1(4) and wr;
habReg4_3 <= saida_decoder2(3) and Data_Address(5) and saida_decoder1(4) and wr;
habReg4_2 <= saida_decoder2(2) and Data_Address(5) and saida_decoder1(4) and wr;
habReg4_1 <= saida_decoder2(1) and Data_Address(5) and saida_decoder1(4) and wr;
habReg4_0 <= saida_decoder2(0) and Data_Address(5) and saida_decoder1(4) and wr;
 			 		 
habFF2  <= saida_decoder1(4) and wr and saida_decoder2(1) and (not Data_Address(5));			 
habFF1  <= saida_decoder1(4) and wr and saida_decoder2(2) and (not Data_Address(5));

-- Fazendo as ligações de sinais com suas ssaidas na placa
HEX0 <= hex_0;
HEX1 <= hex_1;
HEX2 <= hex_2;
HEX3 <= hex_3;
HEX4 <= hex_4;
HEX5 <= hex_5;
LEDR (9) <= saida_FF1;
LEDR (8) <= saida_FF2;
LEDR (7 downto 0) <= REG8_out;

end architecture;