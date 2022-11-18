#'Função gera os dados climáticos horários de determinados intervalo de dias de determinadas estações automaticas do INMET Brasil
#'
#'Está função serve para baixar os dados climáticos horários de determinados intervalo de dias de determinadas estações automaticas do INMET Brasil
#'
#'@param date_ini uma data inicial no formato ano-mes-dia '2022-11-16'
#'@param date_fin uma data final no formato ano-mes-dia '2022-11-16'
#'
#'@param stations Número(s) das estações de interesse de acordo com a função station_INMT()
#'
#'@example
#'data_hour_selected('2022-06-01','2022-11-16',c(50,89,256,368,502))
#'
#'@export
#'@return Returns a data.frame with the AWS data requested
#'@author Santos Henrique Brant Dias

data_hour_selected <- function(date_ini,date_fin,stations) {

  date_ini <- as.Date(date_ini)
  date_fin <- as.Date(date_fin)

if(!require("pacman")) install.packages("pacman");pacman::p_load(
  httr,jsonlite,dplyr)

  estaut<-station_INMT()
  estaut<-estaut[stations,]

for (i in 1:nrow(estaut)) {
  print(stations[i])
  Sys.sleep(1)
  d1<-GET(paste0('https://apitempo.inmet.gov.br/estacao/diaria/',date_ini,'/',date_fin,'/',estaut[i,13]))
  d2<-fromJSON(rawToChar(d1$content), flatten = TRUE)

  tt<-cbind(as.data.frame(stations[i]),as.data.frame(estaut[i,]),as.data.frame(d2),row.names = NULL)
  if(exists('SantosHBDias')==T){SantosHBDias<-rbind(SantosHBDias, tt)}else{SantosHBDias<-tt}
  rm(d1,d2,tt)
}
  return(SantosHBDias)
  }







