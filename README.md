## Trabalho prático de Fundamentos de Projeto e Análise de Algoritmos

O objetivo deste trabalho é montar uma carteira de investimentos utilizando diferentes algoritmos. Três algoritmos de seleção de ativo foram desenvolvidos e podem ser verificados na classe {Asset}.

## Dependências
* Ruby 2.7.4

## Documentação
A documentação do projeto pode ser acessada de duas formas:

* Servindo a documentação presente em <code>/doc</code>
  * Servido com Ruby: 
  ```
    ruby -run -e httpd . -p 8000
  ```
  * Pode-se utilizar extensões do VsCode conhecidas como [Live Server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer)
  * Existem diversas outras formas de servir os arquivos

* Gerando e Servindo a documentação com a gema [Yard](https://yardoc.org/)
  * Com a gema devidamente instalada, execute:
    ```
      yard server -r -p 8808
    ```

## Estrutura do projeto
O projeto foi desenvolvido com base no [Padrão MVC](https://pt.wikipedia.org/wiki/MVC), com a inclusão de uma classe {Router} para melhor organização.

## Utilizando o projeto
Para utilizar o projeto basta executar <code>entrypoint.rb</code>, fornecendo o arquivo CSV contendo os dados como parâmetro. Ex:

```
ruby entrypoint.rb /home/joao/code/PUC/asset_porfolio/data/data.csv
```

Caso um arquivo CSV não seja fornecido, o projeto utilizará o arquivo <code>data.csv</code> presente na pasta <code>data</code>. Como é fácil perceber, os usuários deste projeto também podem, convenientemente ,adicionar o arquivo na basta <code>data</code> ao invés de passá-lo como parâmetro. No entanto, caso escolha por colocar o arquivo na pasta, é necessário que o nome seja <code>data.csv</code>, ou alterar o arquivo <code>entrypoint.rb</code> com o nome desejado.

Com o projeto iniciado, basta selecionar a opção desejada no menu da aplicação.