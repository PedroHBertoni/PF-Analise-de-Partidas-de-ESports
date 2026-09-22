import sgleam/check
import src/tipos

/// Performance(objetivos: Int, resultado: SomaResultado)
let performance1_1 = Performance(13, Vitória)
let performance1_2 = Performance(4, Derrota)
let performance2_1 = Performance(10, Vitória)
let performance2_2 = Performance(1, Derrota)
let performance3_1 = Performance(10, Vitória)
let performance3_2 = Performance(6, Derrota)
let performance4_1 = Performance(9, Vitória)
let performance4_2 = Performance(13, Derrota)
let performance5_1 = Performance(10, Vitória)
let performance5_2 = Performance(8, Derrota)
let performance6_1 = Performance(12, Vitória)
let performance6_2 = Performance(6, Derrota)

let performance7_1 = Performance(15, Vitória)
let performance7_2 = Performance(10, Derrota)
let performance8_1 = Performance(6, Vitória)
let performance8_2 = Performance(0, Derrota)

let performance9_1 = Performance(16, Vitória)
let performance9_2 = Performance(10, Derrota)


/// Partida(id_equipe1: Int, performance_equipe1: Performance, id_equipe2: Int, performance_equipe2: Performance, duracao: Int)
let partida1 = Partida(1, performance1_1, 2, performance1_2, 50)
let partida2 = Partida(1, performance2_1, 3, performance2_2, 52)
let partida3 = Partida(1, performance3_1, 4, performance3_2, 15)
let partida4 = Partida(2, performance4_1, 3, performance4_2, 28)
let partida5 = Partida(2, performance5_1, 4, performance5_2, 15)
let partida6 = Partida(3, performance6_1, 4, performance6_2, 15)

let partida7 = Partida(1, performance7_1, 2, performance7_2, 50)
let partida8 = Partida(3, performance8_1, 4, performance8_2, 42)

let partida9 = Partida(1, performance9_1, 3, performance9_2, 60)


/// Equipe(id: Int, nome: String, partidas: List(Partida))
let equipes_grupo_camp1 = List(equipe1, equipe2, equipe3, equipe4)

/// SomaFase {Grupo, Eliminatoria, Oitava, Quarta, Semifinal, Final}
/// Fase(categoria: Somafase, equipes: List(Equipe), fase_anterior: Option(Fase))
let fase6_camp1 = Fase(Grupo, equipes_final_camp1, None)
let fase5_camp1 = Fase(Grupo, equipes_semifinal_camp1, None)
let fase4_camp1 = Fase(Grupo, equipes_quarta_camp1, None)
let fase1_camp1 = Fase(Grupo, equipes_grupo_camp1, None)

/// SomaJogo = {MOBA, FPS, Luta, Battle_Royale, Estrategia}
/// Jogo(nome: String, tipo: SomaJogo, duracao_media: Int)
let jogo1 = Jogo("LOL", MOBA, 40)

/// Campeonato(nome: String, jogo: Jogo, fase_atual: Fase)
let camp1 = Campeonato("SECOMP", jogo1, fase1_camp1)
