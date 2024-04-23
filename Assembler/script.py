import re

def extrair_comentarios(arquivo_entrada, arquivo_saida):
    with open(arquivo_entrada, 'r') as f_in:
        with open(arquivo_saida, 'w') as f_out:
            linhas = f_in.readlines()
            for linha in linhas:
                comentario = re.search(r'--\s*(.*)', linha)
                if comentario:
                    f_out.write(comentario.group(1).strip() + '\n')

# Substitua 'entrada.txt' e 'saida.txt' pelos nomes dos arquivos de entrada e saída desejados
extrair_comentarios('Assembler/ASM_modificado.txt', 'Assembler/saida.txt')
