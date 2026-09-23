import tipos

pub fn validar_performance(performance: Performance) -> Result(Performance, Nil) {
  case jogo.duracao_media > 0 && jogo.nome != "" {
    True -> Ok(jogo)
    False -> Error(Nil)
  }
}

pub fn validar_partida(partida: Partida) -> Result(Partida, Nil) {
  case
    partida.perform_equipe1.objetivos >= 0
    && partida.perform_equipe2.objetivos >= 0
    && id_equipe1 > 0
    && id_equipe2 > 0
    && duracao >= 0
  {
    True -> Ok(partida)
    False -> Error(Nil)
  }
}

pub fn validar_lista_partidas(
  partidas: List(Partida),
  id: Int,
) -> Result(List(Partida), Nil) {
  case partidas {
    [] -> Ok(partidas)
    [primeiro, ..resto] ->
      case primeiro.id_equipe1 == id || primeiro.id_equipe2 == id {
        True -> valida_lista_partidas(resto, id)
        False -> Error(Nil)
      }
  }
}

pub fn validar_equipe(equipe: Equipe) -> Result(Equipe, Nil) {
  case equipe.id > 0 && equipe.nome != "" && equipe.pontuacao > 0 {
    True ->
      case valida_lista_partidas(equipe.partidas) {
        Ok(partidas) -> Ok(equipe)
        Error(Nil) -> Error(Nil)
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

pub fn validar_lista_equipes(equipes: List(Equipe)) -> Result(List(Equipe), Nil) {
  case equipes {
    [] -> Ok(equipes)
    [primeiro, ..resto] ->
      case validar_equipe(primeiro) {
        Ok(equipe) -> validar_lista_equipes(resto)
        Error(Nil) -> Error(Nil)
      }
  }
}

pub fn validar_fase(fase: Fase) -> Result(Fase, Nil) {
  case validar_lista_equipes(fase.equipes) {
    Ok(List(Equipe)) ->
      case fase_anterior {
        None -> Ok(fase)
        _ -> validar_fase(fase.fase_anterior)
      }
    Error(Nil) -> Error(Nil)
  }
}

pub fn validar_campeonato(campeonato: Campeonato) -> Result(Campeonato, Nil) {
  case campeonato.nome != "" {
    True ->
      case validar_jogo(campeonato.jogo), validar_fase(campeonato.fase_atual) {
        Ok(Jogo), Ok(Fase) -> Ok(campeonato)
        _, _ -> Error(Nil)
      }
    False -> Error(Nil)
  }
}
