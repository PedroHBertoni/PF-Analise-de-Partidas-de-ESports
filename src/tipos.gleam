import gleam/option.{type Option, None, Some}

pub type Performance {
  Performance(objetivos: Int, resultado: SomaResultado)
}

/// Tipo produto Principal
/// Compõe a HIERARQUIA.
/// Esse tipo de dado representa uma partida entre duas equipes e suas cacterísticas
pub type Partida {
  Partida(
    id_equipe1: Int,
    performance_equipe1: Performance,
    id_equipe2: Int,
    performance_equipe2: Performance,
    duracao: Int,
  )
}

/// Compõe a HIERARQUIA.
/// Representa os dados e Partidas de uma Equipe participante de uma Fase no Campeonato
pub type Equipe {
  Equipe(id: Int, nome: String, partidas: List(Partida))
}

/// Compõe a HIERARQUIA.  Apresenta AUTORREFERENCIA: Encadeando todas as fases até o seu
/// início com *fase_anterior* Vazio.
/// Exibe as Equipes participantes em determinada Fase do Campeonato
pub type Fase {
  Fase(categoria: Somafase, equipes: List(Equipe), fase_anterior: Option(Fase))
}

/// Compõe a HIERARQUIA.
/// Representa os dados e Fases do Campeonato
pub type Campeonato {
  Campeonato(nome: String, jogo: Jogo, fase_atual: Fase)
}

/// Especifica um Jogo a ser referenciado no Campeonato
pub type Jogo {
  Jogo(nome: String, tipo: SomaJogo, duracao_media: Int)
}

/// Traz *apenas 5* gêneros de Jogos para o sistema
pub type SomaJogo {
  MOBA
  FPS
  Luta
  Battle_Royale
  Estrategia
}

/// Traz *todos* os Resultados possíveis para uma partida
pub type SomaResultado {
  Vitoria
  Derrota
  Empate
}

/// Traz *todas* as Fases que fecham um campeonato
pub type SomaFase {
  Grupo
  Eliminatoria
  Oitava
  Quarta
  Semifinal
  Final
}
