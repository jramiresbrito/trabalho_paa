require_relative 'app/router'

# Usa o arquivo data.csv caso um não tenha sido fornecido na linha de comando
file_path = ARGV[0] || 'data/data.csv'
ARGV.clear

router = Router.new(file_path)
router.run
