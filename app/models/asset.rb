# A classe {Asset} representa os ativos que são negociados em bolsas de valores
# como a bolas de valores oficial do Brasil, a *B3*. Neste projeto, os ativos serão
# fornecidos através de um arquivo CSV externo. A classe {Asset}, recebe
# como entrada um array de dados brutos extraidos do CSV fornecido através da classe
# {CsvHandler}, realiza a "desserialização", através do método privado {Asset#deserialize},
# e armazena na variável de instância {Asset#elements}. Em seguida, através do
# método privado {Asset#process_assets}, é realizado o processamento dos elementos.
# O principal objetivo do processamento é facilitar a escolha dos ativos através
# dos diversos algoritmos de seleção de carteira. Isso ocorre fornecendo diversas
# informações como *Variância*, *Desvio Padrão* e *Retorno Efetivo*. Para mais informações,
# verifique a documentação dos métodos.
#
# @author Joao Victor Ramires Guimaraes Brito
#
#
# @!attribute elements
#   @return [Hash]
#   Dados brutos dos ativos. Possui os seguintes dados:
#   * :code [Symbol] o código do ativo
#   * :price [Float] o preço de mercado do ativo
#   * :value [Float] o preço de avaliação do ativo
#   * :dividend [Float] o valor do dividendo pago pelo ativo
#
#
# @!attribute asset_summary
#   @return [Hash]
#   Dados processados e agrupados por ativo. Possui os dados:
#   * :asset [Symbol] o código do ativo
#   * :total_dividends [Float] valor total de dividendos pagos pelo ativo
#   * :effective_return [Float] o valor do retorno efetivo do ativo
#   * :buy_price [Float] o valor do preço de mercado do ativo em p(1)
#   * :selling_price [Float] o valor do preço de mercado do ativo em p(t)
#   * :prices_mean [Float] média aritmética dos preços de mercado
#   * :total_price [Float] soma dos preços de mercado do intervalo fornecido
#   * :prices_variance [Float] a variância dos preços de mercado
#   * :prices_standard_deviation [Float] desvio padrão dos preços de mercado
#   * :buy_value [Float] o valor do preço de avaliação do ativo em p(1)
#   * :selling_value [Float] o valor do preço de avaliação do ativo em p(t)
#   * :values_mean [Float] média aritmética dos preços de avaliação
#   * :total_value [Float] soma dos preços de avaliação do intervalo fornecido
#   * :values_variance [Float] a variância dos preços de avaliação
#   * :values_standard_deviation [Float] desvio padrão dos preços de avaliação
#
class Asset
  # O módulo {PARAMETERS} define as probabilidades de ocorrências de três cenários:
  #
  #   * Otimista: 30% de chance de ocorrência
  #   * Regular: 40% de chance de ocorrência
  #   * Pessimista: 30% de chance de ocorrência
  #
  # e, baseando-se nestes cenários, são definidos os multiplicadores dos retornos:
  #
  #   * Otimista: 15% de ganho comparado ao cenário regular
  #   * Regular: Baliza os ganhos dos outros cenários. Seu valor é baseado no ganho efetivo.
  #   * Pessimista: 25% de perda comparado ao cenário regular
  #
  module PARAMETERS
    OPTIMISTIC_PROBABILITY  = 0.3
    REGULAR_PROBABILITY     = 0.4
    PESSIMISTIC_PROBABILITY = 0.3

    CENARIES_PROBABILITY = [OPTIMISTIC_PROBABILITY, REGULAR_PROBABILITY, PESSIMISTIC_PROBABILITY]

    REGULAR_MULTIPLIER     = 1.0
    OPTIMISTIC_MULTIPLIER  = REGULAR_MULTIPLIER + 0.15
    PESSIMISTIC_MULTIPLIER = - REGULAR_MULTIPLIER * 0.25

    CENARIES_MULTIPLIERS = [OPTIMISTIC_MULTIPLIER, REGULAR_MULTIPLIER, PESSIMISTIC_MULTIPLIER]
  end

  attr_accessor :elements, :asset_summary

  def initialize(raw_data)
    @elements = []

    deserialize(raw_data) unless raw_data.nil?
    process_assets
  end

  # Monta a carteira utilizando uma seleção aleatória.
  #  @return[Array]
  def random(portfolio_size)
    @asset_summary.to_a.sample(portfolio_size)
  end

  # Monta a carteira utilizando um algoritmo de força bruta.
  # O critério de seleção é o retorno esperado.
  #  @return[Array]
  def brute_force(portfolio_size)
    # curto circuito caso queira todos os ativos
    return @asset_summary if portfolio_size == @asset_summary.size

    winner_combination(valid_combinations(filter_data, portfolio_size), :expected_return)
  end

  # Monta a carteira utilizando um algoritmo guloso.
  # O critério guloso é o retorno efetivo.
  #  @return[Array]
  def greedy(portfolio_size)
    return @asset_summary if portfolio_size == @asset_summary.size

    combinations = valid_combinations(filter_data, portfolio_size)

    winner_combination(valid_combinations(filter_data, portfolio_size), :effective_return)
  end

  private

  def deserialize(raw_data)
    raw_data.each do |at|
      code  = at[:ativo].upcase.to_sym
      price = at[:preco].to_f
      value = at[:valor].to_f
      dividend = at[:dividendo].to_f

      @elements << { code: code, price: price, value: value, dividend: dividend }
    end
  end

  def calculate_variance(entries, key, mean)
    sum_of_square_of_deviations = entries.sum(0.0) { |entry| (entry[key] - mean) ** 2 }
    sum_of_square_of_deviations / (entries.size - 1)
  end

  def calculate_standard_deviation(variance)
    Math.sqrt(variance)
  end

  def calculate_effective_return(buy_price, selling_price, total_dividends)
    ((selling_price + total_dividends) - buy_price) / buy_price
  end

  def calculate_expected_return(effective_return)
    optimistic_return  = effective_return * PARAMETERS::OPTIMISTIC_MULTIPLIER * PARAMETERS::OPTIMISTIC_PROBABILITY
    regular_return     = effective_return * PARAMETERS::REGULAR_MULTIPLIER * PARAMETERS::REGULAR_PROBABILITY
    pessimistic_return = effective_return * PARAMETERS::PESSIMISTIC_MULTIPLIER * PARAMETERS::PESSIMISTIC_PROBABILITY

    optimistic_return + regular_return + pessimistic_return
  end

  def process_assets
    @asset_summary = @elements
                .group_by { |asset| asset[:code] }
                .map do |k, v|
                  first_price = v.first[:price]
                  last_price = v.last[:price]
                  first_value = v.first[:value]
                  last_value = v.last[:value]

                  total_price = total_value = total_dividends = 0
                  v.each do |entry|
                    total_price += entry[:price]
                    total_value += entry[:value]
                    total_dividends += entry[:dividend]
                  end
                  
                  price_mean = total_price.to_f / v.size
                  value_mean = total_value.to_f / v.size

                  effective_return = calculate_effective_return(first_price,
                                                                last_price,
                                                                total_dividends)

                  expected_return = calculate_expected_return(effective_return)
                  return_variance = calculate_variance([{ return: effective_return }],
                                                      :return,
                                                      expected_return)

                  prices_variance = calculate_variance(v, :price, price_mean)
                  prices_standard_deviation = calculate_standard_deviation(prices_variance)
                  values_variance = calculate_variance(v, :value, value_mean)
                  values_standard_deviation = calculate_standard_deviation(values_variance)

                  {
                    asset: k,
                    total_dividends: total_dividends,
                    effective_return: effective_return,
                    expected_return: expected_return,

                    buy_price: first_price,
                    selling_price: last_price,
                    price_mean: price_mean,
                    total_price: total_price,
                    prices_variance: prices_variance,
                    prices_standard_deviation: prices_standard_deviation,

                    buy_value: first_value,
                    selling_value: last_value,
                    value_mean: value_mean,
                    total_value: total_value,
                    values_variance: values_variance,
                    values_standard_deviation: values_standard_deviation,
                  }
                end
  end

  # Remove os dados desnecessários para os algoritmos de seleção de portfolio
  # return @return[Array]
  def filter_data
    # elimina dados desnecessários para o algoritmo
    @asset_summary.map do |asset|
      {
        asset: asset[:asset],
        expected_return: asset[:expected_return],
        effective_return: asset[:effective_return]
      }
    end
  end

  # Gera todas as combinações do tamanho solicitado
  #  @return[Array]
  def valid_combinations(assets, portfolio_size)
    assets.combination(portfolio_size).to_a
  end

  # Encontra a maior combinação de acordo com o criterio fornecido
  #  @return[Array]
  def winner_combination(combinations, criteria)
    combinations.max_by do |combination|
      combination.sum { |c| c[criteria] }
    end
  end
end
