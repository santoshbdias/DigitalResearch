#'Função para extrair valores dos rasters utilizando coordenadas individuais ou em dataframe
#'
#'Esta função serve para extrair valores de raster
#'
#'@param rasterE um stack raster
#'@param kml um arquivo kml com os pontos a serem extraidos
#'
#'@example
#'extract_values_kml(rasterE, kml)
#'
#'@export
#'@return Returns a data.frame with the AWS data requested
#'@author Santos Henrique Brant Dias
#'

extract_values_kml <- function(rasterE, kml) {

  if(!require("pacman")) install.packages("pacman");pacman::p_load(
    raster, sp, rgdal, terra)

  rasterE <- raster::stack(rasterE)

  kml <- readOGR(kml)

  df <- as.data.frame(kml)

  kml <- sp::spTransform(kml, proj4string(rasterE))

  data <- as.data.frame(terra::extract(rasterE, kml))

  df <- cbind(df,data)

  rm(rasterE,kml,data)

  return(df)
}

