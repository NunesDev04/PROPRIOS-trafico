library(tjsp)
library(tidyverse)
library(lubridate)
library(JurisMiner)

?tjsp

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

movimentacao <- movimentacao |> 
  tempo_movimentacao()

tempo_processo <- movimentacao |> 
  group_by(processo) |> 
  summarise(tempo = max(decorrencia_acumulada))

relator_ementa <- cjsg |> 
  select(data_julgamento,processo, relator, orgao_julgador, ementa)

relator_ementa <- relator_ementa |> 
  distinct()

decisoes <- tjsp_ler_decisoes_cposg(diretorio = "data_raw/cposg")

decisoes <- decisoes |> 
  distinct()

decisoes2 <- decisoes |> 
  select(dispositivo)

decisoes3 <- decisoes |> 
  select(processo, dispositivo)

## agora preciso juntar decises com relator ementa - NAO CONSEGUI AINDA

base_final <- merge(relator_ementa, decisoes2) # deu certo mas deu errado

base_final <- base_final |> 
  distinct()

base_final2 <- relator_ementa |> 
  inner_join(relator_ementa, join_by(processo)) |> 
  inner_join(decisoes3, join_by(processo))
  


  #full_join(relator_ementa, decisoes, by="processo" )
  
  #anti_join(relator_ementa, decisoes, by="processo" )
  
  #inner_join(relator_ementa, decisoes, by="processo" )
  
  #semi_join(relator_ementa, decisoes, by="processo" )

#base_final2 <- base_final |> 
  #mutate(decisao = tjsp_classificar_sentenca())
#rm(base_final2)

