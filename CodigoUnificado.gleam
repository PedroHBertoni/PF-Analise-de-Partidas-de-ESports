import gleam/option.{type Option, None, Some}
import gleam/list

pub type Performance {
  Performance(objetivos: Int, resultado: SomaResultado)
}

/// Tipo produto Principal
/// Compõe a HIERARQUIA.
/// Esse tipo de dado representa uma partida entre duas equipes e suas cacterísticas
pub type Partida {
  Partida(
    id_equipe1: Int,
    perform_equipe1: Performance,
    id_equipe2: Int,
    perform_equipe2: Performance,
    duracao: Int,
  )
}

/// Compõe a HIERARQUIA.
/// Representa os dados e Partidas de uma Equipe participante de uma Fase no Campeonato
pub type Equipe {
  Equipe(id: Int, nome: String, pontuacao: Int, partidas: List(Partida))
}

/// Compõe a HIERARQUIA.  Apresenta AUTORREFERENCIA: Encadeando todas as fases até o seu
/// início com *fase_anterior* Vazio.
/// Exibe as Equipes participantes em determinada Fase do Campeonato
pub type Fase {
  Fase(categoria: SomaFase, equipes: List(Equipe), fase_anterior: Option(Fase))
}

/// Compõe a HIERARQUIA.
/// Representa os dados e Fases do Campeonato
pub type Campeonato {
  Campeonato(nome: String, jogo: Jogo, fase_atual: Option(Fase))
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
      case validar_equipe(primeiro), busca_equipe(primeiro.id, resto) {
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


pub fn validar_performance_examples() {
    check.eq(validar_performance(Performance(0, Empate)), Ok(Performance(0, Empate)))
    check.eq(validar_performance(Performance(-1, Empate)), Error(Nil))
    check.eq(validar_performance(Performance(-2, Derrota)), Error(Nil))
}



pub fn validar_partida_examples() {
    let partida_correta = Partida(1, performance1_1, 2, performance1_2, 40)
    let partida_errada1 = Partida(1, performance1_1, 1, performance1_2, 40)
    let partida_errada2 = Partida(1, performance1_1, 2, performance1_2, -10)
    let partida_errada3 = Partida(1, performance_vitoria, 2, performance_vitoria, 40)
    let partida_errada4 = Partida(1, performance_vitoria, 2, performance_empate, 40)
    let partida_errada5 = Partida(1, performance_derrota, 2, performance_empate, 40)
    let partida_errada6 = Partida(1, performance_derrota, 2, performance_derrota, 40)

    check.eq(validar_partida(partida_correta), Ok(partida_correta))
    check.eq(validar_partida(partida_errada1), Error(Nil))
    check.eq(validar_partida(partida_errada2), Error(Nil))
    check.eq(validar_partida(partida_errada3), Error(Nil))
    check.eq(validar_partida(partida_errada4), Error(Nil))
    check.eq(validar_partida(partida_errada5), Error(Nil))
    check.eq(validar_partida(partida_errada6), Error(Nil))
}



pub fn validar_lista_partidas() {
    let partida_correta = Partida(1, performance1_1, 2, performance1_2, 40)
    let partida_errada1 = Partida(1, performance1_1, 1, performance1_2, 40)

    let partida_1x3 = Partida(1, performance1_1, 3, performance1_2, 50)
    let partida_1x2 = partida_correta
    
    check.eq(validar_lista_partidas([]), Ok([]))

    check.eq(validar_lista_partidas([partida_1x2], 1), Ok([partida_1x2]))
    check.eq(validar_lista_partidas([partida_1x2], 2), Ok([partida_1x2]))
    check.eq(validar_lista_partidas([partida_1x2], 3), Error(Nil))

    check.eq(validar_lista_partidas([partida_1x2, partida_1x3], 1), Ok([partida_1x2, partida_1x3]))
    check.eq(validar_lista_partidas([partida_1x2, partida_1x3], 2), Error(Nil))
    check.eq(validar_lista_partidas([partida_1x2, partida_1x3], 3), Error(Nil))
    check.eq(validar_lista_partidas([partida_1x2, partida_1x3], 4), Error(Nil))

    check.eq(validar_lista_partidas([partida_errada1], 1), Error(Nil))
    check.eq(validar_lista_partidas([partida_correta, partida_errada1], 1), Error(Nil))
    check.eq(validar_lista_partidas([partida_errada1, partida_correta], 1), Error(Nil))
}


pub fn validar_equipe_examples() {
    let partida_errada1 = Partida(1, performance1_1, 1, performance1_2, 40)
    let partida_1x3 = Partida(1, performance1_1, 3, performance1_2, 50)
    let partida_1x2 = Partida(1, performance1_1, 2, performance1_2, 40)
    let lista_partidas_correta = [partida_1x2, partida_1x3]

    check.eq(validar_equipe(Equipe(1, "LOUD", 2, lista_partidas_correta)), Ok(Equipe(1, "LOUD", 2, lista_partidas_correta)))
    check.eq(validar_equipe(Equipe(0, "LOUD", 2, lista_partidas_correta)), Error(Nil))
    check.eq(validar_equipe(Equipe(1, "", 2, lista_partidas_correta)), Error(Nil))
    check.eq(validar_equipe(Equipe(0, "LOUD", -1, lista_partidas_correta)), Error(Nil))
    check.eq(validar_equipe(Equipe(0, "LOUD", 2, [partida_errada1])), Error(Nil))
}


pub fn validar_lista_equipes_examples() {
    let partida_errada1 = Partida(1, performance1_1, 1, performance1_2, 40)
    let partida_1x3 = Partida(1, performance1_1, 3, performance1_2, 50)
    let partida_1x2 = Partida(1, performance1_1, 2, performance1_2, 40)
    let lista_partidas_correta = [partida_1x2, partida_1x3]

    let equipe_certa = Equipe(1, "LOUD", 2, lista_partidas_correta)
    let equipe_errada = Equipe(0, "", -1, [partida_errada1])

    check.eq(validar_lista_equipes([]), Ok([]))
    check.eq(validar_lista_equipes([equipe_certa]), Ok([equipe_certa]))
    check.eq(validar_lista_equipes([equipe_certa]), Ok([equipe_certa]))
    check.eq(validar_lista_equipes([equipe_certa, equipe_certa]), Error(Nil))
    check.eq(validar_lista_equipes([equipe_certa, equipe_certa]), Error(Nil))
}


pub fn validar_fase_examples() {
    let partida_errada1 = Partida(1, performance1_1, 1, performance1_2, 40)
    let partida_1x3 = Partida(1, performance1_1, 3, performance1_2, 50)
    let partida_1x2 = Partida(1, performance1_1, 2, performance1_2, 40)
    let lista_partidas_correta = [partida_1x2, partida_1x3]

    let equipe_certa = Equipe(1, "LOUD", 2, lista_partidas_correta)
    let equipe_errada = Equipe(0, "", -1, [partida_errada1])

    let fase_teste_semifinal = Fase(Semifinal, [equipe_certa, Equipe(..equipe_certa,  id: 2), Equipe(..equipe_certa,  id: 3), Equipe(..equipe_certa,  id: 4)], None)
    let fase_teste_final = Fase(Final, [equipe_certa, Equipe(..equipe_certa,  id: 3)], fase_teste_semifinal)

    check.eq(validar_fase(fase_teste_semifinal), Ok(fase_teste_semifinal))
    check.eq(validar_fase(fase_teste_final), Ok(fase_teste_final))
    check.eq(validar_fase(Fase(..fase_teste_final, equipes: [equipe_certa]), Error(Nil)))
    check.eq(validar_fase(Fase(..fase_teste_final, equipes: [equipe_certa, equipe_errada]), Error(Nil)))
}


/// Exemplos com base no *variaveis_test.gleam*
pub fn validar_campeonato_examples() {
    let performance_vitoria = Performance(1, Vitoria)
    let performance_empate = Performance(0, Empate)
    let performance_derrota = Performance(0, Derrota)

    let performance1_1 = Performance(13, Vitoria)
    let performance1_2 = Performance(4, Derrota)
    let performance2_1 = Performance(10, Vitoria)
    let performance2_2 = Performance(1, Derrota)
    let performance3_1 = Performance(10, Vitoria)
    let performance3_2 = Performance(6, Derrota)
    let performance4_1 = Performance(9, Vitoria)
    let performance4_2 = Performance(13, Derrota)
    let performance5_1 = Performance(10, Vitoria)
    let performance5_2 = Performance(8, Derrota)
    let performance6_1 = Performance(12, Vitoria)
    let performance6_2 = Performance(6, Derrota)

    let performance7_1 = Performance(15, Vitoria)
    let performance7_2 = Performance(10, Derrota)
    let performance8_1 = Performance(6, Vitoria)
    let performance8_2 = Performance(0, Derrota)

    let performance9_1 = Performance(16, Vitoria)
    let performance9_2 = Performance(10, Derrota)

    let partida1 = Partida(1, performance1_1, 2, performance1_2, 50)
    let partida2 = Partida(1, performance2_1, 3, performance2_2, 52)
    let partida3 = Partida(1, performance3_1, 4, performance3_2, 15)
    let partida4 = Partida(2, performance4_1, 3, performance4_2, 28)
    let partida5 = Partida(2, performance5_1, 4, performance5_2, 15)
    let partida6 = Partida(3, performance6_1, 4, performance6_2, 15)

    let partida7 = Partida(1, performance7_1, 2, performance7_2, 50)
    let partida8 = Partida(3, performance8_1, 4, performance8_2, 42)

    let partida9 = Partida(1, performance9_1, 3, performance9_2, 60)

    let equipe1_grupos = Equipe(1, "LOUD", 10, [partida1, partida2, partida3])
    let equipe2_grupos = Equipe(2, "Furia", 10, [partida1, partida4, partida5])
    let equipe3_grupos = Equipe(3, "RED Canids", 10, [partida2, partida4, partida6])
    let equipe4_grupos = Equipe(4, "VKS", 10, [partida3, partida5, partida6])

    let equipe1_semi = Equipe(1, "LOUD", 10, [partida7])
    let equipe2_semi = Equipe(2, "Furia", 10, [partida7])
    let equipe3_semi = Equipe(3, "RED Canids", 10, [partida8])
    let equipe4_semi = Equipe(4, "VKS", 10, [partida8])

    let equipe1_final = Equipe(1, "LOUD", 10, [partida9])
    let equipe3_final = Equipe(3, "RED Canids", 10, [partida9])

    let equipes_grupo_camp1 = [equipe1_grupos, equipe2_grupos, equipe3_grupos, equipe4_grupos]
    let equipes_semifinal_camp1 = [equipe1_semi, equipe2_semi, equipe3_semi, equipe4_semi]
    let equipes_final_camp1 = [equipe1_final, equipe3_final]

    let fase1_camp1 = Some(Fase(Grupo, equipes_grupo_camp1, None))
    let fase2_camp1 = Some(Fase(Semifinal, equipes_semifinal_camp1, fase1_camp1))
    let fase3_camp1 = Some(Fase(Final, equipes_final_camp1, fase2_camp1))

    let jogo1 = Jogo("LOL", MOBA, 40)
    let camp1 = Campeonato("SECOMP", jogo1, fase3_camp1)

    check.eq(validar_campeonato(camp1), Ok(camp1))
    check.eq(validar_campeonato(Campeonato(..camp1, fase_atual: None)), Ok(Campeonato(..camp1, fase_atual: None)))
    check.eq(validar_campeonato(Campeonato(..camp1, jogo: Jogo(..jogo1, nome: ""))), Error(Nil))
    check.eq(validar_campeonato(Campeonato(..camp1, fase_atual: Fase(..fase_teste_final, equipes: [equipe_certa, equipe_errada]))), Error(Nil))
}

pub fn validar_jogo_examples() {
    let jogo1 = Jogo("LOL", MOBA, 40)

    check.eq(validar_jogo(jogo1), Ok(jogo1))
    check.eq(validar_jogo(Jogo(..jogo1, duracao_media: 0)), Error(Nil))
    check.eq(validar_jogo(Jogo(..jogo1, nome: "")), Error(Nil))
}