#'Função gera os dados climáticos horários das estações automaticas do Brasil em uma determinada data
#'
#'Está função serve para baixar os dados climáticos de todas estações INMET Brasil em uma determinada data
#'
#'@param date uma data
#'
#'@example
#'clim_hour_BR(Sys.Date()-1)
#'
#'@export
#'@return Returns a data.frame with the AWS data requested
#'@author Santos Henrique Brant Dias

clim_hour_BR <- function(date) {

  date <- as.Date(date)

  if(!require("pacman")) install.packages("pacman");pacman::p_load(
    httr,jsonlite,dplyr)

  df<-GET(paste0('https://apitempo.inmet.gov.br/estacao/dados/',date))
  df<-fromJSON(rawToChar(df$content), flatten = TRUE)

  names(df)

  df <- df %>% dplyr::select(c('UF','CD_ESTACAO','DC_NOME','VL_LATITUDE','VL_LONGITUDE',
                               'DT_MEDICAO','HR_MEDICAO','TEM_INS','TEM_MIN','TEM_MAX',
                               'UMD_INS','UMD_MIN','UMD_MAX','PRE_INS','PRE_MIN',
                               'PRE_MAX','PTO_INS','PTO_MIN','PTO_MAX',
                               'VEN_RAJ','VEN_DIR','VEN_VEL','RAD_GLO','CHUVA'))

  df <- mutate_at(df, vars('VL_LATITUDE','VL_LONGITUDE','TEM_INS','TEM_MIN','TEM_MAX',
                           'UMD_INS','UMD_MIN','UMD_MAX','PRE_INS','PRE_MIN','PRE_MAX',
                           'PTO_INS','PTO_MIN','PTO_MAX','VEN_RAJ','VEN_DIR','VEN_VEL',
                           'RAD_GLO','CHUVA'), as.numeric)

  return(df)
}
