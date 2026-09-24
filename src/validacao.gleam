import tipos

pub fn validar_performance(performance: Performance) -> Result(Performance, Nil) {
  case performance.objetivos >= 0 {
    True -> Ok(performance)
    False -> Error(Nil)
  }
}

pub fn validar_partida(partida: Partida) -> Result(Partida, Nil) {
  case
    validar_performance(partida.perform_equipe1),
    validar_performance(partida.perform_equipe2),
    partida.id_equipe1 != partida.id_equipe2
    && partida.id_equipe1 > 0
    && partida.id_equipe2 > 0
    && partida.duracao >= 0
  {
    Ok(_), Ok(_), True -> Ok(partida)
    _, _, _ -> Error(Nil)
  }
}

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

pub fn validar_lista_equipes(equipes: List(Equipe)) -> Result(List(Equipe), Nil) {
  case equipes {
    [] -> Ok(equipes)
    [primeiro, ..resto] ->
      case validar_equipe(primeiro) {
        Ok(_) -> validar_lista_equipes(resto)
        Error(Nil) -> Error(Nil)
      }
  }
}

pub fn validar_fase(fase: Fase) -> Result(Fase, Nil) {
  case validar_lista_equipes(fase.equipes) {
    Ok(_) ->
      case fase.fase_anterior {
        None -> Ok(fase)
        Some(anterior) -> validar_fase(anterior)
      }
    Error(Nil) -> Error(Nil)
  }
}

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

pub fn validar_jogo(jogo: Jogo) -> Result(Jogo, Nil) {
  case jogo.duracao_media > 0 && jogo.nome != "" {
    True -> Ok(jogo)
    False -> Error(Nil)
  }
}
