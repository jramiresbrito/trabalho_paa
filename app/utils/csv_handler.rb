require 'csv'

# A classe {CsvHandler} é utilizada para manipular o arquivo *CSV* fornecido,
# contendo os dados dos ativos a serem analisados e escolhidos para composição
# de carteira.
#
# @author Joao Victor Ramires Guimaraes Brito
#
#
# @!attribute elements
#   @return [Hash]
#   Dados brutos dos ativos que serão fornecidos para a classe {Asset}.
#
class CsvHandler
  attr_accessor :elements

  # Recebe o caminho, desserializa o arquivo CSV, através do método privado
  # {CsvHandler#load_csv}, e armazena os resultados na variável de instância
  # {CsvHandler#elements}.
  def initialize(csv_file)
    @csv_file = csv_file
    @elements = []

    load_csv if File.exist?(@csv_file)
  end

  private

  # Método para desserializar o arquivo csv.
  #   @return [Hash]
  def load_csv
    csv_options = { headers: :first_row, header_converters: :symbol }
  
    CSV.foreach(@csv_file, csv_options) do |row|
      @elements << row
    end
  end
end
