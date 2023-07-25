#'Função lista todas as estações automaticas do INMET Brasil
#'
#'Está função serve para listar todas as estações INMET Brasil
#'
#'@example
#'creating()
#'
#'@export
#'@return Returns a data.frame with the AWS data requested
#'@author Santos Henrique Brant Dias

#Melhor estratégia que pensei é criar um grid regular com o comando seq e depois ajustar esse grid (ou georeferenciar), ajustar grid a uma linha existente

rm(list = ls()); gc(); removeTmpFiles(h=0)

Lat1 <- -25.086488
long1 <- -50.098229

Lat2 <- -25.085285
long2 <- -50.096791

espL <- 0.5
pm <- 10


creating <- function() {

  if(!require("pacman")) install.packages("pacman");pacman::p_load(
    sp, rgdal, mapplots)

  ## create vectors of the longitude and latitude values
  x <- seq(from = long1, to = long2, by = (0.025*espL/10000000))
  y <- seq(from = Lat1, to = Lat2, by = (0.025*(1/pm)/10000000))

  dg <- as.data.frame(cbind(x,y))


  grd <- make.grid(landings$Lon,landings$Lat,landings$LiveWeight, espL, 1/pm, c(long1,long2), c(Lat1,Lat2))

  names(dg)<-c('R_Factor','y','x')

  coordinates(dg)<-~x+y #Adicionar coordenadas X e Y ao arquivo

  proj4string(dg) <- CRS("+init=epsg:4326") # Colocar proje??o WGS84 coordenadas geogr?ficas
  plot(dg)




  ## create a grid of all pairs of coordinates (as a data.frame)
  xy <- expand.grid(x = x, y = y)

  ## load the "foreign" package to write to DBF
  library(foreign)
  write.dbf(xy, file = "S:/OneDrive/Acad_Profisional/Corteva/para fazer grid de pontos/xy.dbf")


  plot(xy)

  library(mapview)
  mapview(dg)









  return(estaut)
}
