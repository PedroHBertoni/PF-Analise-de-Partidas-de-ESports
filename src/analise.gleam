import tipos
import validacao

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
