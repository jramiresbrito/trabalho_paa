require_relative '../utils/colorize'

class AssetView
  def ask_for(stuff)
    puts stuff
    print '> '
    gets.chomp
  end

  def ask_for_number(stuff)
    puts stuff
    print '> '
    gets.chomp.to_i
  end

  def display(assets_list)
    assets_list.each do |asset|
      msg = "#{'Ativo:'.red} #{asset[:asset]} "
      msg += "#{'Retorno Esperado:'.blue} #{adjust_leading_zeros(asset[:expected_return] * 100)}%\n"

      print msg
    end
  end

  private

  def adjust_leading_zeros(number)
    return "0#{'%0.2f' % number.to_s}" if number < 10 && number.positive?
    
    '%0.2f' % number
  end
end