require 'tk'

# Criação da janela principal
root = TkRoot.new { title "Calculadora" }

# Variáveis para armazenar os números e o resultado
num1 = TkVariable.new
num2 = TkVariable.new
resultado = TkVariable.new

# Função para calcular o resultado
def calcular(num1, num2, operacao, resultado)
  case operacao
  when "Somar"
    resultado.value = num1.value.to_f + num2.value.to_f
  when "Subtrair"
    resultado.value = num1.value.to_f - num2.value.to_f
  when "Multiplicar"
    resultado= num1.value.to_f * num2.value.to_f
  when "Dividir"
    resultado.value = num2.value.to_f != 0 ? num1.value.to_f / num2.value.to_f : "Erro: Divisão por zero"
  end
end

# Interface gráfica
TkLabel.new(root) { text 'Número 1:' }.pack
TkEntry.new(root, textvariable: num1).pack

TkLabel.new(root) { text 'Número 2:' }.pack
TkEntry.new(root, textvariable: num2).pack

operacao = TkVariable.new("Somar")
TkOptionMenu.new(root, operacao, "Somar", "Subtrair", "Multiplicar", "Dividir").pack

TkButton.new(root) do
  text 'Calcular'
  command { calcular(num1, num2, operacao.value, resultado) }
  pack
end

TkLabel.new(root) { textvariable: resultado }.pack

Tk.mainloop
