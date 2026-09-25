import src/tipos
import src/analise
import src/validacao

pub fn validar_performance_examples() {
    check.eq(validar_performance(Performance(0, Empate)), Ok(Performance(0, Empate)))
    check.eq(validar_performance(Performance(-1, Empate)), Error(Nil))
    check.eq(validar_performance(Performance(-2, Derrota)), Error(Nil))
}

let partida_correta = Partida(1, performance1_1, 2, performance1_2, 40)
let partida_errada1 = Partida(1, performance1_1, 1, performance1_2, 40)
let partida_errada2 = Partida(1, performance1_1, 2, performance1_2, -10)
let partida_errada3 = Partida(1, performance_vitoria, 2, performance_vitoria, 40)
let partida_errada4 = Partida(1, performance_vitoria, 2, performance_empate, 40)
let partida_errada5 = Partida(1, performance_derrota, 2, performance_empate, 40)
let partida_errada6 = Partida(1, performance_derrota, 2, performance_derrota, 40)

pub fn validar_partida_examples() {
    check.eq(validar_partida(partida_correta), Ok(partida_correta))
    check.eq(validar_partida(partida_errada1), Error(Nil))
    check.eq(validar_partida(partida_errada2), Error(Nil))
    check.eq(validar_partida(partida_errada3), Error(Nil))
    check.eq(validar_partida(partida_errada4), Error(Nil))
    check.eq(validar_partida(partida_errada5), Error(Nil))
    check.eq(validar_partida(partida_errada6), Error(Nil))
}

let partida_1x2 = partida_correta
let partida_1x3 = Partida(1, performance1_1, 3, performance1_2, 50)

pub fn validar_lista_partidas() {
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

let lista_partidas_correta = [partida_1x2, partida_1x3]

pub fn validar_equipe_examples() {
    check.eq(validar_equipe(Equipe(1, "LOUD", 2, lista_partidas_correta)), Ok(Equipe(1, "LOUD", 2, lista_partidas_correta)))
    check.eq(validar_equipe(Equipe(0, "LOUD", 2, lista_partidas_correta)), Error(Nil))
    check.eq(validar_equipe(Equipe(1, "", 2, lista_partidas_correta)), Error(Nil))
    check.eq(validar_equipe(Equipe(0, "LOUD", -1, lista_partidas_correta)), Error(Nil))
    check.eq(validar_equipe(Equipe(0, "LOUD", 2, [partida_errada1])), Error(Nil))
}

let equipe_certa = Equipe(1, "LOUD", 2, lista_partidas_correta)
let equipe_errada = Equipe(0, "", -1, [partida_errada1])

pub fn validar_lista_equipes_examples() {
    check.eq(validar_lista_equipes([]), Ok([]))
    check.eq(validar_lista_equipes([equipe_certa]), Ok([equipe_certa]))
    check.eq(validar_lista_equipes([equipe_certa]), Ok([equipe_certa]))
    check.eq(validar_lista_equipes([equipe_certa, equipe_certa]), Error(Nil))
    check.eq(validar_lista_equipes([equipe_certa, equipe_certa]), Error(Nil))
}

let fase_teste_semifinal = Fase(Semifinal, [equipe_certa, Equipe(..equipe_certa,  id: 2), Equipe(..equipe_certa,  id: 3), Equipe(..equipe_certa,  id: 4)], None)
let fase_teste_final = Fase(Final, [equipe_certa, Equipe(..equipe_certa,  id: 3)], fase_teste_semifinal)

pub fn validar_fase_examples() {
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

    let equipe1_grupos = Equipe(1, "LOUD", List(partida1, partida2, partida3))
    let equipe2_grupos = Equipe(1, "Furia", List(partida1, partida4, partida5))
    let equipe3_grupos = Equipe(1, "RED Canids", List(partida2, partida4, partida6))
    let equipe4_grupos = Equipe(1, "VKS", List(partida3, partida5, partida6))

    let equipe1_semi = Equipe(1, "LOUD", List(partida7))
    let equipe2_semi = Equipe(1, "Furia", List(partida7))
    let equipe3_semi = Equipe(1, "RED Canids", List(partida8))
    let equipe4_semi = Equipe(1, "VKS", List(partida8))

    let equipe1_final = Equipe(1, "LOUD", List(partida9))
    let equipe3_final = Equipe(1, "RED Canids", List(partida9))

    let equipes_grupo_camp1 = List(equipe1, equipe2, equipe3, equipe4)

    let fase6_camp1 = Fase(Final, equipes_final_camp1, None)
    let fase5_camp1 = Fase(Semifinal, equipes_semifinal_camp1, None)
    let fase4_camp1 = Fase(Quarta, equipes_quarta_camp1, None)
    let fase1_camp1 = Fase(Grupo, equipes_grupo_camp1, None)

    let jogo1 = Jogo("LOL", MOBA, 40)
    let camp1 = Campeonato("SECOMP", jogo1, fase1_camp1)

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