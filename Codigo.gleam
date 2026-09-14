import sgleam/check
import gleam/option.{type Option, None, Some}

///tipos produto.
///Tipo produto principal.Esse tipo de dado representa uma partida entre duas equipes e suas acacterísticas
pub type Partida {
	Partida(id: Int, equipe1: Equipe, equipe2: Equipe, pontuacao1: Int, pontuacao2: Int, duracao: Int)
}

///Compõe a hierarquia. Representa os dados de uma equipe participante do campeonato
pub type Equipe {
	Equipe(id: Int, nome: String, partidas: List(Partida))
}

///Compõe a hierarquia. Exibe as equipes em determinada fase do campeonato
pub type Fase {
	Fase(tipo: Tipo_fase, equipes: List(Equipes))
}

///Compõe a hierarquia. Representa os dados do campeonato
pub type Campeonato {
	Campeonato(nome: String, jogo: Jogo, equipes_fase: List(Fase))
}

pub type Jogo {
	Jogo(nome: Str, tipo: Tipo_jogo, duracao_media_partida: Int)
}

///tipo soma
pub type Tipo_jogo {
	MOBA
	FPS
	Luta
	Battle Royale
	Estrategia
}

pub type Resultado {
	Vitoria
	Derrota
	Empate
}

pub type Tipo_fase {
	Grupo
	Eliminatoria
	Final
}

///validação dos dados
pub fn validar_jogo(jogo: Jogo) -> Bool {
	jogo.duracao_media_partida > 0 && jogo.num_obj_medios >= 0
}

pub fn validar_partida(pontuacao: Int, objetivos: Int, duracao: Int) -> Bool {
	pontuacao >= 0 && objetivos >= 0 && duracao > 0
}

///funções construtoras
pub fn registrar_partida(id: Int, equpe1: Equipe, equipe2: Equipe, pontuacao: Int, objetivos: Int, duracao: Int) -> Result(Partida, String) {
	case validar_partida(pontuacao, objetivos, duracao) {
    	True -> Ok(Partida(id, equipe1, equipe2, pontuacao, objetivos, duracao, resultado))
    	False -> Error("Dados inválidos para registrar uma partida")
	}
}

pub fn registrar_jogo(nome: String, tipo: Tipo_jogo, duracao_media_partida: Int, num_obj_medios: Int) -> Result(Jogo, String) {
	case validar_jogo(duracao_media_partida, num_obj_medios) {
    	True -> Ok(Jogo(nome, tipo, duracao_media_partida, num_obj_medios))
    	False -> Error("Dados do Jogo inválidos")
	}
}

///operações

pub fn pontos_resultado(resul: Resultado) -> Int{
	Vitoria -> 3
	Derrota -> 0
	Empate -> 1
}

///calcula a pontuação total de uma determinada equipe
pub fn pontuacao_total(eq: Equipe) -> Int {
	case eq.partidas {
    	[] -> None
    	[n, ..resto] ->
        	case eq == equipe1 {
           	 
        	}
        	case eq == equipe2 {

        	}
	}
}


pub fn melhor_desempenho(camp: Campeonato) -> Equipe {
    
}

pub taxa_vitorias(partidas: List(Partida)) -> Float {

}

///função com recursividade
pub busca_equipe(lista: List(Equipe), id: Int) -> Option(Equipe) {
	case equipes {
    	[] -> None
    	[n, ..resto] ->
        	case n.id == id {
            	True -> option.Some(n)
            	False -> busca_equipe(resto, id)
        	}
	}
}

pub classificacao_resumida(equipe: Equipe) -> String {

}





