import src/validacao
import variaveis_test
import gleam/list

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
    check.eq(validar_lista_equipes([equipe_certa], [equipe_certa]), Error(Nil))
    check.eq(validar_lista_equipes([equipe_certa], [equipe_certa]), Error(Nil))
}

let fase_teste_semifinal = Fase(Semifinal, [equipe_certa, Equipe(..equipe_certa,  id: 2), Equipe(..equipe_certa,  id: 3), Equipe(..equipe_certa,  id: 4)], None)
let fase_teste_final = Fase(Final, [equipe_certa, Equipe(..equipe_certa,  id: 3)], fase_teste_semifinal)

pub fn validar_fase_examples() {
    check.eq(validar_fase(fase_teste_semifinal), Ok(fase_teste_semifinal))
    check.eq(validar_fase(fase_teste_final), Ok(fase_teste_final))
    check.eq(validar_fase(Fase(..fase_teste_final, equipes: [equipe_certa]), Error(Nil)))
    check.eq(validar_fase(Fase(..fase_teste_final, equipes: [equipe_certa], [equipe_errada]), Error(Nil)))
}


/// Exemplos com base no *variaveis_test.gleam*
pub fn validar_campeonato_examples() {
    check.eq(validar_campeonato(camp1), Ok(camp1))
    check.eq(validar_campeonato(Campeonato(..camp1, fase_atual: None)), Ok(Campeonato(..camp1, fase_atual: None)))
    check.eq(validar_campeonato(Campeonato(..camp1, jogo: Jogo(..jogo1, nome: ""))), Error(Nil))
    check.eq(validar_campeonato(Campeonato(..camp1, fase_atual: Fase(..fase_teste_final, equipes: [equipe_certa], [equipe_errada]))), Error(Nil))
}

pub fn validar_jogo_examples() {
    check.eq(validar_jogo(jogo1), Ok(jogo1))
    check.eq(validar_jogo(Jogo(..jogo1, duracao_media: 0)), Error(Nil))
    check.eq(validar_jogo(Jogo(..jogo1, nome: "")), Error(Nil))
}