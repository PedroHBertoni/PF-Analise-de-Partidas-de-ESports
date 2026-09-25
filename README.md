# Sistema de Análise de Campeonato de E-Sports

## 1. Tema e Informações Gerais

* **Tema:** Tema 10 — Análise de Jogos Digitais e E-Sports
* **Linguagem:** Gleam 
* **Disciplina:** Programação Funcional
* **Professor:** Wagner Igarashi
* **Integrantes:**
  * Anna Lísia de Almeida Yaguti - RA145093
  * Pedro Henrique Bertoni de Souza - RA143345

## 2. Breve Descrição do Sistema

O sistema é uma solução desenvolvida em **Gleam** voltada para a estruturação, validação rigorosa de consistência e análise estatística de torneios de jogos digitais e e-sports.

A aplicação gerencia a hierarquia completa de um campeonato (`Campeonato → Fase → Equipe → Partida`), aplicando regras de integridade histórica (como verificação de coerência de vitórias/derrotas, impedimento de confrontos de uma equipe contra si mesma e checagem de fases encadeadas) através de **pattern matching**, **recursão estrutural** e tipos algébricos, garantindo a ausência total de mutabilidade e de efeitos colaterais.

## 3. Tipos Criados (`src/tipos.gleam`)

### Tipos Produto (Estruturas Compostas)

* **`Performance`**: Associa o número de objetivos cumpridos (não-negativo) ao resultado obtido (`SomaResultado`).
* **`Partida`**: Registra os identificadores das duas equipes (`id_equipe1`, `id_equipe2`), suas respectivas `Performance`s e a duração total em minutos.
* **`Equipe`**: Armazena identificador único (`id`), nome, pontuação acumulada e a lista do histórico de partidas (`List(Partida)`).
* **`Fase`**: Estrutura autorreferente que armazena a categoria da etapa (`SomaFase`), a lista de equipes participantes (`List(Equipe)`) e um ponteiro opcional para a fase anterior (`Option(Fase)`).
* **`Jogo`**: Armazena o nome, o gênero (`SomaJogo`) e a duração média prevista em minutos.
* **`Campeonato`**: Tipo topo da hierarquia, associando o nome do torneio, o `Jogo` disputado e a fase atual (`Option(Fase)`).

### Tipos Soma 

* **`SomaJogo`**: `MOBA` | `FPS` | `Luta` | `Battle_Royale` | `Estrategia`
* **`SomaResultado`**: `Vitoria` | `Derrota` | `Empate`
* **`SomaFase`**: `Grupo` | `Eliminatoria` | `Oitava` | `Quarta` | `Semifinal` | `Final`

## 4. Mapeamento de Funcionalidades (F1–F10)

| ID | Funcionalidade Exigida | Função(ões) Implementadora(s) | Módulo |
| :--- | :--- | :--- | :--- |
| **F1** | Definição dos Tipos do Domínio | `Performance`, `Partida`, `Equipe`, `Fase`, `Campeonato`, `Jogo` | `tipos.gleam` |
| **F2** | Construtores e Validações Primárias | `validar_performance`, `validar_jogo` | `validacao.gleam` |
| **F3** | Agregação por Recursão Estrutural | `pontuacao_total`, `soma_pontuacao` | `analise.gleam` |
| **F4** | Busca e Filtragem com `Option` | `busca_equipe` | `analise.gleam` |
| **F5** | Mapeamento e Transformação de Dados | `validar_lista_partidas` | `validacao.gleam` |
| **F6** | Ordenação / Unicidade de Elementos | `validar_lista_equipes` | `validacao.gleam` |
| **F7** | Validação de Regras de Confronto | `validar_partida` | `validacao.gleam` |
| **F8** | Decomposição em Funções Auxiliares | `validar_partida`, `validar_equipe`, `soma_pontuacao` | `validacao.gleam` / `analise.gleam` |
| **F9** | Navegação em Estrutura Autorreferente | `validar_fase` | `validacao.gleam` |
| **F10** | Validação e Consolidação Global | `validar_campeonato` | `validacao.gleam` |
