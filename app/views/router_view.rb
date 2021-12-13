class RouterView
  def print_menu
    puts ''
    puts 'Escolha a opção desejada'.green

    options
  end

  private

  def options
    puts '╔══════════════════════════════════════════╗'
    puts "║      #{'1  - Sumário dos Ativos'.yellow}             ║"
    puts "║      #{'2  - Escolha aleatória'.yellow}              ║"
    puts "║      #{'3  - Força Bruta'.yellow}                    ║"
    puts "║      #{'4  - Escolha Gulosa'.yellow}                 ║"
    puts "║      #{'9  - Limpar a tela'.cyan}                  ║"
    puts "║      #{'0  - Finalizar'.pink}                      ║"
    puts '╚══════════════════════════════════════════╝'
  end
end
