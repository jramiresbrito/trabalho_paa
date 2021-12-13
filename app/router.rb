require_relative 'utils/colorize'
require_relative 'views/router_view'
require_relative 'utils/csv_handler'
require_relative 'controllers/assets_controller'

class Router
  def initialize(file_path)
    elements = CsvHandler.new(file_path).elements
    @assets_controller = AssetsController.new(elements)
    @view = RouterView.new
  end

  def run
    menu_loop
  end

  private

  def menu_loop
    loop do
      @view.print_menu
      choice = gets.chomp.to_i
      system 'clear'
      menu_options(choice)
    end
  end

  def menu_options(choice)
    case choice
    when 1 then @assets_controller.summary
    when 2 then @assets_controller.random
    when 3 then @assets_controller.brute_force
    when 4 then @assets_controller.greedy
    when 9 then system 'clear'
    when 0 then exit
    else
      puts 'Opção inválida'.red
    end
  end
end
