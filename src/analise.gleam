import tipos
import validacao

/// Soma todas as pontuações de uma equipe *id_equipe* para todas as fases do Campeonato
/// 
pub fn pontuacao_total(id_equipe: Int, campeonato: Campeonato) -> Int {
  pontuacao_total_fase(id_equipe, campeonato.primeira_fase)
}

pub fn auxiliar_pontuacao_total(id_equipe: Int, fase: Fase) -> Int {
  let equipe = busca_equipe(id_equipe, fase.equipes)
  case equipe {
    None -> 0
    _ ->
      equipe.pontuacao
      + case fase.prox_fase {
        None -> 0
        _ -> auxiliar_pontuacao_total(id_equipe, fase.prox_fase)
      }
  }
}

/// Retorna uma Equipe por seu *id_equipe* específico, em uma lista de *equipes*
pub fn busca_equipe(id_equipe: Int, equipes: List(Equipe)) -> Option(Equipe) {
  case equipes {
    [] -> None
    [em_analise, ..resto] ->
      case em_analise.id == id_equipe {
        True -> em_analise
        False -> busca_equipe(id_equipe, resto)
      }
  }
}
