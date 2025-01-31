require 'tk'

# Criação da janela principal
root = TkRoot.new { 
  title "Calculadora"
  resizable false, false
}

# Variáveis para armazenar o display e histórico
display = TkVariable.new
historico = []
numero_atual = ""
operacao_pendente = nil
primeiro_numero = nil

# Frame para o display
frame_display = TkFrame.new(root).pack(fill: 'x', padx: 5, pady: 5)
TkEntry.new(frame_display) {
  textvariable display
  justify 'right'
  state 'readonly'
  width 20
}.pack(fill: 'x', padx: 5)

# Frame para os botões
frame_botoes = TkFrame.new(root).pack(padx: 5, pady: 5)

# Função para adicionar dígito
def adicionar_digito(display, digito, numero_atual)
  numero_atual << digito
  display.value = numero_atual
end

# Função para operação
def realizar_operacao(display, operador, numero_atual, primeiro_numero, operacao_pendente)
  if primeiro_numero.nil?
    primeiro_numero = numero_atual.to_f
    numero_atual = ""
    operacao_pendente = operador
  else
    segundo_numero = numero_atual.to_f
    case operacao_pendente
    when '+'
      resultado = primeiro_numero + segundo_numero
    when '-'
      resultado = primeiro_numero - segundo_numero
    when '*'
      resultado = primeiro_numero * segundo_numero
    when '/'
      resultado = segundo_numero != 0 ? primeiro_numero / segundo_numero : "Erro"
    end
    display.value = resultado
    primeiro_numero = resultado
    numero_atual = ""
    operacao_pendente = operador
  end
  return numero_atual, primeiro_numero, operacao_pendente
end

# Criação dos botões numéricos
botoes = [
  ['7', '8', '9', '/'],
  ['4', '5', '6', '*'],
  ['1', '2', '3', '-'],
  ['0', '.', '=', '+']
]

botoes.each_with_index do |row, i|
  row.each_with_index do |valor, j|
    TkButton.new(frame_botoes) {
      text valor
      width 5
      height 2
      command proc {
        case valor
        when /[0-9.]/
          numero_atual = adicionar_digito(display, valor, numero_atual)
        when /[\+\-\*\/]/
          numero_atual, primeiro_numero, operacao_pendente = realizar_operacao(
            display, valor, numero_atual, primeiro_numero, operacao_pendente
          )
        when '='
          unless primeiro_numero.nil? || operacao_pendente.nil?
            numero_atual, primeiro_numero, operacao_pendente = realizar_operacao(
              display, nil, numero_atual, primeiro_numero, operacao_pendente
            )
            primeiro_numero = nil
            operacao_pendente = nil
          end
        end
      }
    }.grid(row: i, column: j, padx: 2, pady: 2)
  end
end

# Botão Limpar
TkButton.new(frame_botoes) {
  text 'C'
  width 23
  height 2
  command proc {
    display.value = ""
    numero_atual = ""
    primeiro_numero = nil
    operacao_pendente = nil
  }
}.grid(row: 4, column: 0, columnspan: 4, pady: 2)

Tk.mainloop