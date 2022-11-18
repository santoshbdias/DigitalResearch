# DigitalResearch
DigitalResearch é um pacote de ferramentas R para uso de pesquisadores e responsáveis por experimentos vinculados a área de Agricultura Digital. Atualmente o pacote integra apenas dados climáticos do INMET, mas será incrementado outras bases a medida que as demandas forem surgindo.

# Instalação
Para instalar a última versão do pacote DigitalResearch siga estes passos:

1 - Instalar os pacotes necesários para iniciar as instalações:
```
install.packages(devtools)
```

2 - Instalar via github pacote DigitalResearch
```
devtools::install_github("santoshbdias/DigitalResearch")
```

# Exemplo

```
#Limpar todas as variáveis e memória ocupada pelo R
rm(list = ls()); gc(); removeTmpFiles(h=0)

#Carregar o pacote necessário
library(DigitalResearch)

#Calcula evapotranspiração de referência diária de todas as estações automáticas do Brasil em uma determinada data no formato: '2022-12-25'. O comando abaixo é para a data de ontem.
df <- ETo_BR(Sys.Date()-1)

#Todos os dados climaticos diários de todas as estações automáticas do Brasil em uma determinada data no formato: '2022-12-25'. O comando abaixo é para a data de ontem.
df2 <- clim_day_BR(Sys.Date()-1)

#Dados climaticos horários para ontem.
df3 <- clim_hour_BR(Sys.Date()-1)

#Estações meteorológicas automáticas do INMET
df4 <- station_INMET()

#Comando para download de dados horários de um intervalo de datas e determinadas estações meteorológicas.
df5 <- data_hour_selected('2022-06-01','2022-11-16',c(50,89,256,368,502))

```
