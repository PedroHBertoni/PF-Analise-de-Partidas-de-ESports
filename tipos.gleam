import gleam/option.{type Option, None, Some}
import sgleam/check

/// Tipo produto Principal
/// Compõe a HIERARQUIA.
/// Esse tipo de dado representa uma partida entre duas equipes e suas cacterísticas
pub type Partida {
  Partida(
    id: Int,
    equipe: Int,
    pontuacao: Int,
    objetivos: Int,
    duracao: Int,
    resultado: SomaResultado,
    oponente: Option(Partida),
  )
}

/// Compõe a HIERARQUIA.
/// Representa os dados e Partidas de uma Equipe participante de uma Fase no Campeonato
pub type Equipe {
  Equipe(id: Int, nome: String, partidas: List(Partida))
}

/// Compõe a HIERARQUIA.
/// Exibe as Equipes participantes em determinada Fase do Campeonato
pub type Fase {
  Fase(tipo: Somafase, equipes: List(Equipe))
}

/// Compõe a HIERARQUIA.
/// Representa os dados e Fases do Campeonato
pub type Campeonato {
  Campeonato(nome: String, jogo: Jogo, equipes_fase: List(Fase))
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
  Final
}
