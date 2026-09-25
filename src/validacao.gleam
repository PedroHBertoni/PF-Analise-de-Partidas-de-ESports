import tipos
import analise

/// Verifica Performance de um time não ter um número de objetivos negativos
pub fn validar_performance(performance: Performance) -> Result(Performance, Nil) {
  case performance.objetivos >= 0 {
    True -> Ok(performance)
    False -> Error(Nil)
  }
}

/// Verifica Partida não ter a mesma equipe lutando contra si mesma, e os identificadores
/// de cada um serem positivos + suas Performances também devem ser válidas
pub fn validar_partida(partida: Partida) -> Result(Partida, Nil) {
  case
    validar_performance(partida.perform_equipe1),
    validar_performance(partida.perform_equipe2),
    partida.id_equipe1 != partida.id_equipe2
    && partida.id_equipe1 > 0
    && partida.id_equipe2 > 0
    && partida.duracao >= 0
  {
    Ok(_), Ok(_), True -> case partida.perform_equipe1, partida.perform_equipe2 {
      Vitoria, Derrota | Empate, Empate | Derrota, Vitoria -> Ok(partida)
      _, _ -> Error(Nil)
    }
    _, _, _ -> Error(Nil)
  }
}

/// Valida todas as Partidas agrupadas em uma Lista e verifica se todas elas apresentam o
/// mesmo time por *id*, seja como equipe 1 ou 2
pub fn validar_lista_partidas(
  partidas: List(Partida),
  id: Int,
) -> Result(List(Partida), Nil) {
  case partidas {
    [] -> Ok(partidas)
    [primeiro, ..resto] ->
      case
        primeiro.id_equipe1 == id || primeiro.id_equipe2 == id,
        validar_partida(primeiro)
      {
        True, Ok(_) -> validar_lista_partidas(resto, id)
        _ -> Error(Nil)
      }
  }
}

/// Valida uma equipe ter identificador positivo, um nome não vazio e pontuação não negativa,
/// além de validar todas as partidas, considerando que devem ter seu id
pub fn validar_equipe(equipe: Equipe) -> Result(Equipe, Nil) {
  case equipe.id > 0 && equipe.nome != "" && equipe.pontuacao >= 0 {
    True ->
      case validar_lista_partidas(equipe.partidas, equipe.id) {
        Ok(_) -> Ok(equipe)
        Error(Nil) -> Error(Nil)
      }
    False -> Error(Nil)
  }
}

/// Valida todas as Equipes agrupadas em uma Lista e verifica se são únicas na Lista
pub fn validar_lista_equipes(equipes: List(Equipe)) -> Result(List(Equipe), Nil) {
  case equipes {
    [] -> Ok(equipes)
    [primeiro, ..resto] ->
      case validar_equipe(primeiro), encontra_equipe(primeiro.id, resto) {
        Ok(_), None -> validar_lista_equipes(resto)
        _, _ -> Error(Nil)
      }
  }
}


/// Valida uma fase passando por todas as suas equipes, e recursivamente verifica sua fase anterior
/// a qual também deve ser válida
pub fn validar_fase(fase: Fase) -> Result(Fase, Nil) {
  case fase.categoria, list.length(fase.equipes) {
    Grupo, _ | Eliminatoria, _ | Oitava, 16 | Quarta, 8 | Semifinal, 4 | Final, 2 -> case validar_lista_equipes(fase.equipes) {
      Ok(_) ->
        case fase.fase_anterior {
          None -> Ok(fase)
          Some(anterior) -> validar_fase(anterior)
        }
      Error(Nil) -> Error(Nil)
    }
    _, _ -> Error(Nil)
  }
}

/// Valida um campeonato verificando seu Jogo e sua Fase Atual, além de seu nome não ser vazio
pub fn validar_campeonato(campeonato: Campeonato) -> Result(Campeonato, Nil) {
  case campeonato.nome != "" {
    True ->
      case validar_jogo(campeonato.jogo), validar_fase(campeonato.fase_atual) {
        Ok(_), Ok(_) -> Ok(campeonato)
        _, _ -> Error(Nil)
      }
    False -> Error(Nil)
  }
}

/// Valida um jogo com duração média positiva e nome não vazio
pub fn validar_jogo(jogo: Jogo) -> Result(Jogo, Nil) {
  case jogo.duracao_media > 0 && jogo.nome != "" {
    True -> Ok(jogo)
    False -> Error(Nil)
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