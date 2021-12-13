require 'pp'
require_relative '../models/asset'
require_relative '../views/asset_view'

# A classe {AssetsController} é responsável por fazer a interface com a classe de
# domínio {Asset}. Através do controller a classe {Router} é capaz de fornecer
# aos usuários acesso aos algoritmos de escolha de portfolio.
#
# @author Joao Victor Ramires Guimaraes Brito
#
class AssetsController
  def initialize(raw_data)
    @assets = Asset.new(raw_data)
    @view = AssetView.new
  end

  # Imprime com a classe PrettyPrint o resumo dos ativos contendo todos os cálculos
  #   @return[Array]
  def summary
    PP.pp(@assets.asset_summary)
  end

  # Imprime o resultado da seleção utilizando o algoritmo {Asset#random}
  #   @return[Array]
  def random
    assets = @assets.random(portfolio_size)

    @view.display(assets)
  end

  # Imprime o resultado da seleção utilizando o algoritmo {Asset#brute_force}
  #   @return[Array]
  def brute_force
    assets = @assets.brute_force(portfolio_size)

    @view.display(assets)
  end

  # Imprime o resultado da seleção utilizando o algoritmo {Asset#greedy}
  #   @return[Array]
  def greedy
    assets = @assets.greedy(portfolio_size)

    @view.display(assets)
  end

  private

  def assets_size
    @assets.asset_summary.size
  end

  def portfolio_size
    begin
      portfolio_size = @view.ask_for_number("Qual o tamanho da carteira?\nEscolha entre #{"1".yellow} e #{assets_size.to_s.yellow}")
    end until (1..assets_size).to_a.include?(portfolio_size)

    portfolio_size
  end
end