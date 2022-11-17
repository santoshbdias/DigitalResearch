#'Função lista todas as estações automaticas do INMET Brasil
#'
#'Está função serve para listar todas as estações INMET Brasil
#'
#'@example
#'seasons_INMT()
#'
#'@export
#'@return Returns a data.frame with the AWS data requested
#'@author Santos Henrique Brant Dias


seasons_INMT <- function() {

  if(!require("pacman")) install.packages("pacman");pacman::p_load(
    httr,jsonlite,dplyr)

  estaut<-GET('https://apitempo.inmet.gov.br/estacoes/T')
  estaut <- fromJSON(rawToChar(estaut$content), flatten = TRUE)

  names(estaut)<-c("Cod_Oscar", "Cidade", "FL_Capital", "Fim_Operacao",
                   "Situacao", "TP_Estacao", "Latitude", "Cod_WSI",
                   "Cod_Distrito", "Altitude", "Estado", "Entidade",
                   "Cod_Estacao", "Longitude", "Inicio_Operacao")

  return(estaut)
}
