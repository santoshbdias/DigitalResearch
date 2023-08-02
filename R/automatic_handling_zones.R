
#
##Crie um script em R, para fazer o download das bandas 2, 3, 4, 8 e 11 dos satélites sentinel 2 a partir de um arquivo kml.  Utilize um pacote do cran para o download#
#
##aut_handling_zones <- function() {
#
#  if(!require("pacman")) install.packages("pacman");pacman::p_load(
#    rgdal, raster)
#
#  # Caminho do arquivo KML
#  kml_file <- "S:/OneDrive/Acad_Profisional/0_Pericias/Analises_Satelite/Alexandre/Tomate_MG/Àreas tomate.kml"
#
#  # Lendo o arquivo KML
#  kml_data <- readOGR(dsn = kml_file)
#
#  i=1
#  # Loop para baixar as imagens
#  for (i in 1:nrow(kml_data)) {
#
#    # Coordenadas da imagem
#    coords <- as.numeric(kml_data[i,c("xmin","ymin","xmax","ymax")])
#
#    j=2
#    # Loop para baixar as bandas desejadas
#    for(j in c(2,3,4,8,11)) {
#
#      # URL da imagem no servidor Sentinel
#      sentinel_url <- paste0("https://sentinel-s2-l1c.s3.amazonaws.com/tiles/",
#                             kml_data[i,"path"], "/", kml_data[i,"row"], "/",
#                             kml_data[i,"productid"],"/",kml_data[i,"productid"],"_B0",j,".jp2")
#
#      # Baixando a imagem
#      download.file(sentinel_url, destfile = paste0("imagem_", i, "_B0",j,".jp2"))
#    }
#  }


















#  return(estaut)
#}
