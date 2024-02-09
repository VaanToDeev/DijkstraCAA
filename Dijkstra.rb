class Grafo
  attr_reader :grafo, :nos, :anterior, :distancia

  INFINITO = 1 << 64

  def initialize
    @grafo = {}
    @nos = Array.new
  end

  def conectar_grafo(origem, destino, peso)
    if !grafo.has_key?(origem)
      grafo[origem] = { destino => peso }
    else
      grafo[origem][destino] = peso
    end

    nos << origem unless nos.include?(origem)
  end

  def adicionar_aresta(origem, destino, peso)
    conectar_grafo(origem, destino, peso)
    conectar_grafo(destino, origem, peso)
  end

  def dijkstra(origem)
    @distancia = {}
    @anterior = {}

    nos.each do |no|
      @distancia[no] = INFINITO
      @anterior[no] = -1
    end

    @distancia[origem] = 0
    nos_nao_visitados = nos.compact

    while nos_nao_visitados.size > 0
      u = nil

      nos_nao_visitados.each do |min|
        if !u || (@distancia[min] && @distancia[min] < @distancia[u])
          u = min
        end
      end

      break if @distancia[u] == INFINITO

      nos_nao_visitados = nos_nao_visitados - [u]

      grafo[u].keys.each do |vertice|
        alt = @distancia[u] + grafo[u][vertice]

        if alt < @distancia[vertice]
          @distancia[vertice] = alt
          @anterior[vertice] = u
        end
      end
    end
  end

  def encontrar_caminho(destino)
    if @anterior[destino] != -1
      encontrar_caminho(@anterior[destino])
    end

    @caminho << destino
  end

  def caminhos_mais_curto(origem)
    @caminhos_grafo = []
    @origem = origem

    dijkstra(origem)

    nos.each do |destino|
      @caminho = []

      encontrar_caminho(destino)

      distancia_atual = if @distancia[destino] != INFINITO
                         @distancia[destino]
                       else
                         "sem caminho"
                       end

      @caminhos_grafo << "Destino (#{destino}) -> #{@caminho.join(' --> ')}: #{distancia_atual}"
    end

    @caminhos_grafo
  end

  def imprimir_resultado
    @caminhos_grafo.each do |caminho|
      puts caminho
    end
  end
end

if __FILE__ == $0
  gr = Grafo.new
  gr.adicionar_aresta("a", "c", 7)
  gr.adicionar_aresta("a", "e", 14)
  gr.adicionar_aresta("a", "f", 9)
  gr.adicionar_aresta("c", "d", 15)
  gr.adicionar_aresta("c", "f", 10)
  gr.adicionar_aresta("d", "f", 11)
  gr.adicionar_aresta("d", "b", 6)
  gr.adicionar_aresta("f", "e", 2)
  gr.adicionar_aresta("e", "b", 9)

  gr.caminhos_mais_curto("a")
  gr.imprimir_resultado
end
