library(tjsp)
library(tidyverse)

classe <- "417"
assuntos <- "3607,3608,5885,10523,5894,5895,5896,5897,5898,5899,5900,5901,10987"

tjsp_baixar_cjsg(
  livre = "",
  aspas = FALSE,
  classe = classe,
  assunto = assuntos,
  orgao_julgador = "",
  inicio = "",
  fim = "",
  inicio_pb = "",
  fim_pb = "",
  tipo = "A",
  n = 20,
  diretorio = "data_raw/cjsg"
)

autenticar()

cjsg <- tjsp_ler_cjsg(diretorio = "data_raw/cjsg")

tjsp_baixar_cposg(cjsg$processo, diretorio = "data_raw/cposg")

arquivos <- list.files("data_raw/cposg", full.names = TRUE)

dados <- ler_dados_cposg(arquivos = arquivos)

partes <- tjsp_ler_partes(arquivos)

movimentacao <- ler_movimentacao_cposg(arquivos)
############################
n_proc_comarca <- cjsg |> 
  count(comarca)

comarca_rio_preto <- cjsg |> 
  filter(str_detect(comarca, "^São José do Rio Preto"))

proc_p_relator <- cjsg |> 
  count(relator)
############################

library(JurisMiner)

movimentacao <- movimentacao |> 
  tempo_movimentacao()

tempo_processo <- movimentacao |> 
  group_by(processo) |> 
  summarise(tempo = max(decorrencia_acumulada))

relator_ementa <- cjsg |> 
  select(relator, ementa)


  
  
