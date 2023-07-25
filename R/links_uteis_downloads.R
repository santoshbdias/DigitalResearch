#MANUAL DE USO DA API VIME
#Recuperando modelos disponíveis para consulta:
#  https://apivime.inmet.gov.br/modelos
#Recuperando as áreas disponíveis para consulta com o modelo passado como parâmetro:
#  https://apivime.inmet.gov.br/areas/modelo
#https://apivime.inmet.gov.br/areas/COSMO7
#Recuperando os parâmetros disponíveis para consulta com o modelo e área passados como parâmetro:
#  https://apivime.inmet.gov.br/parametros/modelo/area
#https://apivime.inmet.gov.br/parametros/COSMO7/BRA
#Recuperando as datas disponíveis para consulta com o modelo, área e parâmetro passados como parâmetro:
#  https://apivime.inmet.gov.br/datas/modelo/area/parâmetro
#https://apivime.inmet.gov.br/datas/COSMO7/BRA/prec24h
#Recuperando as rodadas disponíveis para consulta com o modelo, área, parâmetro e data passados como parâmetro:
#  https://apivime.inmet.gov.br/rodadas/modelo/area/parâmetro/data
#https://apivime.inmet.gov.br/rodadas/COSMO7/BRA/prec24h/2019-10-23
#Recuperando a imagem disponível com o modelo, área, parâmetro, data e rodada passados como parâmetro:
#  https://apivime.inmet.gov.br/rodadas/modelo/area/parâmetro/data/rodada
#https://apivime.inmet.gov.br/COSMO7/BRA/prec24h/2019-10-23/00:00
#A API irá retornar todas as validades dispoíveis
#A imagem está dispoível no campo "base64"
#Recuperando última imagem disponível de uma região específica:
#  https://apivime.inmet.gov.br/area
#https://apivime.inmet.gov.br/CO
#OBS.: Os valores encontrados no campo "sigla" de cada retorno que será usado para as buscas posteriores.

#######################################################################################################################
#######################################################################################################################
#######################################################################################################################

#MANUAL DE USO DA API SATÉLITE
#Recuperando satélites disponíveis para consulta:
#
#  https://apisat.inmet.gov.br/satelites
#Recuperando as áreas disponíveis para consulta com o satélite passado como parâmetro:
#
#  https://apisat.inmet.gov.br/areas/<satelite>
#  https://apisat.inmet.gov.br/areas/GOES
#Recuperando os parâmetros disponíveis para consulta com o satélite e área passados como parâmetro:
#
#  https://apisat.inmet.gov.br/<parametros>/<satelite>/<area>
#  https://apisat.inmet.gov.br/parametros/GOES/BR
#Recuperando as datas disponíveis para consulta com o satélite, área e parâmetro passados como parâmetro:
#
#  https://apisat.inmet.gov.br/<datas>/<satelite>/<area>/<parâmetro>
#  https://apisat.inmet.gov.br/datas/GOES/BR/TN
#Recuperando as horas disponíveis para consulta com o satélite, área, parâmetro e data passados como parâmetro:
#
#  https://apisat.inmet.gov.br/<horas>/<satelite>/<area>/<parâmetro>/<data>
#  https://apisat.inmet.gov.br/horas/GOES/BR/TN/2019-10-23
#Recuperando as imagens disponíveis com o satélite, área, parâmetro e data passados como parâmetro:
#
#  https://apisat.inmet.gov.br/<satelite>/<area>/<parâmetro>/<data>
#  https://apisat.inmet.gov.br/GOES/BR/TN/2019-10-23
#A API irá retornar todas as horas dispoíveis
#A imagem está dispoível no campo "base64"
#Recuperando somente uma imagem com o satélite, área, parâmetro, data e hora passados como parâmetro:
#
#  https://apisat.inmet.gov.br/<satelite>/<area>/<parâmetro>/<data>/<hora>
#  https://apisat.inmet.gov.br/GOES/BR/TN/2019-10-23/09:00
#A imagem está dispoível no campo "base64"
#OBS.: Os valores encontrados no campo "sigla" de cada retorno que será usado para as buscas posteriores.

#######################################################################################################################
#######################################################################################################################
#######################################################################################################################

#MANUAL DE USO DA API PREVISÃO DO TEMPO
#Previsão do Tempo para cada Cidade a partir do geocode fornecido pelo IBGE (http://servicodados.ibge.gov.br/):
#  https://apiprevmet3.inmet.gov.br/previsao/<geocode>
#  https://apiprevmet3.inmet.gov.br/previsao/5300108
#Previsão para
#todas as  Capitais:
#  https://apiprevmet3.inmet.gov.br/previsao/capitais

#######################################################################################################################
#######################################################################################################################
#######################################################################################################################


#MANUAL DE USO DA API NORMAIS
#Recuperar todas as normais:
#  https://apitempo.inmet.gov.br/normais


#Recuperar todos os atributos referentes à normal e estação passada como parâmetro:
#  https://apitempo.inmet.gov.br/n... + normal + estacao
#https://apitempo.inmet.gov.br/normais/atributos/5/83377


#Recuperar todos os dados referentes à normal, atributo e estação passada como parâmetro:
#  https://apitempo.inmet.gov.br/n... + normal + atributo + estacao
#https://apitempo.inmet.gov.br/normais/consulta/5/N201/83377

#######################################################################################################################
#######################################################################################################################
#######################################################################################################################


#MANUAL DE USO DA API MAPA DE PRECIPITAÇÃO
#Recuperar imagens referentes à data passada como parâmetro:
#  https://apiprec.inmet.gov.br + data
#https://apiprec.inmet.gov.br/2019-10-22

#######################################################################################################################
#######################################################################################################################
#######################################################################################################################


#MANUAL DE USO DA API MAPA DE CONDIÇÕES REGISTRADAS
#Recuperar parâmetros disponíveis:
#  https://apitempo.inmet.gov.br/parametros/CondicoesRegistradas


#Recuperar datas disponíveis para o produto passado como parâmetro:
#  https://apitempo.inmet.gov.br/datas/CondicoesRegistradas


#Recuperar horários disponíveis para o produto e data passados como parâmetros:
#  https://apitempo.inmet.gov.br/h... + data
#https://apitempo.inmet.gov.br/horarios/CondicoesRegistradas/2019-10-23


#Recuperar a imagem disponível para o produto, data e horário passados como parâmetros:
#  https://apitempo.inmet.gov.br/C... + parâmetro + data + horário
#https://apitempo.inmet.gov.br/CondicoesRegistradas/TEMPAR/2019-10-23/00

#######################################################################################################################
#######################################################################################################################
#######################################################################################################################


#MANUAL DE USO DA API GEONETCAST
#Recuperando satélites disponíveis para consulta:
#
#  https://apigeonet.inmet.gov.br/satelites
#Recuperando produtos disponíveis para consulta(chamada apenas para método POST com os parâmetros area e id_satelite)
#
#https://apigeonet.inmet.gov.br/produtos
#Recuperando as datas disponíveis a partir do produto selecionado(chamada apenas para método POST com o parâmetro id_produto)
#
#https://apigeonet.inmet.gov.br/imagemdatas
#Recuperando as horas disponíveis a partir da data selecionada(chamada apenas para método POST com os parâmetros date e id_produto)
#
#https://apigeonet.inmet.gov.br/horas
#Recuperando imagens de alta resolução(chamada apenas para método POST com o parâmetro id)

#https://apigeonet.inmet.gov.br/imagemar

#######################################################################################################################
#######################################################################################################################
#######################################################################################################################

if(!require("pacman")) install.packages("pacman");pacman::p_load(
  httr,jsonlite,dplyr)

sats <- GET('https://apisat.inmet.gov.br/satelites')
sats <- fromJSON(rawToChar(sats$content), flatten = TRUE)


estaut <- GET(paste0('https://apisat.inmet.gov.br/areas/',sats$sigla[1]))
estaut <- fromJSON(rawToChar(estaut$content), flatten = TRUE)

t1 <- GET(paste0('https://apisat.inmet.gov.br/parametros/',sats$sigla[1],'/',estaut$sigla[2]))
t1 <- fromJSON(rawToChar(t1$content), flatten = TRUE)

t2 <- GET(paste0('https://apisat.inmet.gov.br/datas/',sats$sigla[1],'/',estaut$sigla[2],'/',t1$sigla[2]))
t2 <- fromJSON(rawToChar(t2$content), flatten = TRUE)

t3 <- GET(paste0('https://apisat.inmet.gov.br/datas/',sats$sigla[1],'/',estaut$sigla[2],'/',t1$sigla[2],'/',t2$sigla[5]))
t3 <- fromJSON(rawToChar(t3$content), flatten = TRUE)

t4 <- GET(paste0('https://apisat.inmet.gov.br/areas/',sats$sigla[1]))
t4 <- fromJSON(rawToChar(t4$content), flatten = TRUE)


