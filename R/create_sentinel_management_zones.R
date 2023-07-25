#'Função gera o mapa das zonas de manejo com os downloads das imagens sentinel e um kml
#'
#'Está função serve para criar zonas de manejo com imagens sentinel
#'
#'@param date uma data
#'
#'@example
#'create_sentinel_management_zones(kml,'pastes/imagens/sentinel')
#'
#'@export
#'@return Returns a data.frame with the AWS data requested
#'@author Santos Henrique Brant Dias

#create_sentinel_management_zones <- function(kml,sentinel) {

date <- as.Date(date)

if(!require("pacman")) install.packages("pacman");pacman::p_load(
  raster,sp,e1071,rgdal,httr)

# Configurar as credenciais
set_credentials <- function(user, password) {
  httr::set_config(httr::basic_auth(user, password))
}
set_credentials("santoshbdias", "Gta8565$")

# Lê o arquivo KML
kml_file <- readOGR("C:/Users/server_SantosDias/Desktop/Poligonokmlexemplo.kml")

# Extrai as coordenadas de cada polígono
coords <- lapply(kml_file@polygons, function(x) x@Polygons[[1]]@coords)


# Selecionar as imagens com base nas datas desejadas
start_date <- "2022-01-01"
end_date <- "2022-12-31"
images <- search(kml_file, start_date, end_date)

# Fazer download das imagens
download(images)





  #sen2r para baixar imagens sentinel



  qmaxzmj <- 20
  L <- 0.5

  cm.pasta.sentinel <- ''

  sr <- bnir/bred #Razão Simples (SR)
  ndvi <- (bnir-bred)/(bnir+bred)#índice de Vegetação por Diferença Normalizada (NDVI)
  ndwi <- (NIR.tm4-MidIR.tm5)/(NIR.tm4+MidIR.tm5)#índice de Umidade por Diferença Normalizada ou Índice de Água (“Water Index”) (NDMI ou NDWI)
  savi <- (1+L)*(bnir-bred)/(bnir+bred+L)#índice de Vegetação Ajustado ao Solo (SAV1) e SAVl Modificado (MSAVI)
  tvi <- 0.5*(120*(bnir-bgreen))-200*(bred-bgreen) #índice de Vegetação Triangular (TVI)




  raster_in  <- Raster_de_Entrada[[1]]
  groups <- Quantidade_Maxima_de_Zonas_de_Manejo

  #raster_in <- brick('D:/GustavoArquivos/Gustavo/RemoteSensing/zonas_manejo/dados_zm/raster/ndvi_sem_estr.tif')[[1]]
  #groups <- 20

  set.seed(1)

  raster_in_pts <- as.data.frame(rasterToPoints(raster_in))

  pc_calc <- prcomp(~ raster_in_pts[,1] + raster_in_pts[,2] + raster_in_pts[,3], scale = TRUE)
  pc_data <- as.data.frame(pc_calc$x)

  x <- 2:groups
  wss <- as.vector(matrix(NA, nrow = groups - 1))
  for( i in x)
    wss[i-1] <- cmeans(pc_data, i, 200, verbose=TRUE, method="cmeans")$withinerror

  plot(x, wss, ylab = "Funcao de erro (withinerror)",
       xlab = "Numero de Zonas de Manejo",
       main = "Algoritmo Fuzzy C-Means Clustering (Biblioteca e1071 - R)")
  spl <- smooth.spline(x, wss, spar=0.05)
  newx <- seq(min(x), max(x), 0.1)
  pred <- predict(spl, x=newx, deriv=0)
  # solve for tangent at a given x
  for(i in x){
    newx <- i
    pred0 <- predict(spl, x=newx, deriv=0)
    pred1 <- predict(spl, x=newx, deriv=1)
    yint <- pred0$y - (pred1$y*newx)
    xint <- -yint/pred1$y
    xint
    nx <- (newx-10):(newx+10)
    lines(nx, yint + pred1$y*nx, col=4) # tangent (1st deriv. of spline at newx)
  }
  lines(pred, col=2)
  points(x, wss, pch = 19, cex = 1.2)
  text(x, wss + min(wss), paste(x), cex = 1.2, offset = 0, pos = 4)

  legend("topright", c("Ponto que representa o erro", "Funcao que descreve o erro", "Tangente no ponto (1st derivada)"),
         col = c(1, 2, 4),  pch = c(19, NA, NA), lty = c(NA, 1, 1), cex = c(1.2,1.2,1.2))









  ##AgriStart=group
  ##Raster_de_Entrada=raster
  ##Quantidade_de_Zonas_de_Manejo=number 2
  ##Quantidade_de_Refinamentos=number 10
  ##Poligono_Unidade_Produtiva=optional vector
  ##Inicial_do_identificador=string ZM
  ##Poligono_Zonas_de_Manejo=output vector
  library(raster)
  library(sp)
  library(rgdal)
  library(e1071)
  library(igraph)
  library(rgeos)
  library(TSP)
  raster_in  <- Raster_de_Entrada[[1]]
  groups <- Quantidade_de_Zonas_de_Manejo
  num_de_refinamentos <- Quantidade_de_Refinamentos
  pol_mask <- Poligono_Unidade_Produtiva
  iniID <- Inicial_do_identificador
  #raster_in <- brick('D:/GustavoArquivos/Gustavo/RemoteSensing/zonas_manejo/arquivos_zm_v2/dados_zm/raster/ndvi_sem_estr.tif')[[1]]
  #groups <- 40
  #num_de_refinamentos <- 5
  #pol_file <- 'D:/GustavoArquivos/Gustavo/RemoteSensing/zonas_manejo/arquivos_zm_v2/dados_zm/vetor/unidade_produtiva.shp'
  #pol_mask <- readOGR(dirname(pol_file), strsplit(basename(pol_file), '[.]')[[1]][1] )
  #iniID <- "A"
  set.seed(1)
  raster_in_pts <- as.data.frame(rasterToPoints(raster_in))
  pc_calc <- prcomp(~ raster_in_pts[,1] + raster_in_pts[,2] + raster_in_pts[,3], scale = TRUE)
  #biplot(pc_calc)
  pc_data <- as.data.frame(pc_calc$x)
  pc_kmeans <- cmeans(pc_data, groups, 500,verbose=TRUE, method="cmeans")

  raster_in_pts <- data.frame(x = raster_in_pts$x, y = raster_in_pts$y, cluster = pc_kmeans$cluster)
  cluster_raster <- rasterFromXYZ(raster_in_pts)
  cluster_raster@crs <- raster_in@crs
  #plot(cluster_raster, col = topo.colors(30))

  cluster_ref <- setValues(cluster_raster, NA)
  for(i in 1:groups){
    mask_i <- setValues(cluster_raster, NA)
    mask_i[cluster_raster == i ] <- i
    clump_i <- clump(mask_i, direction = 4)
    clump_i_freq <- na.exclude(as.data.frame(freq(clump_i)))
    valueID <- clump_i_freq$value[which.max(clump_i_freq$count)]
    maxi <- max(clump_i_freq$count)
    excludeID <- clump_i_freq$value[which(clump_i_freq$count < maxi)]
    clump_i_mask <- clump_i
    clump_i_mask[clump_i %in% excludeID] <- NA
    clump_i_mask[clump_i == valueID] <- i
    cluster_ref[clump_i_mask == i ] <- i
  }
  #plot(cluster_ref, col = topo.colors(30))
  func_viz <- function(x){
    feq_class <- na.exclude(as.data.frame(table(x)))
    if(nrow(feq_class)!=0) {
      colnames(feq_class) <- c("Class","Freq")
      value_noData <- as.numeric(as.character(feq_class$Class[feq_class$Freq==max(feq_class$Freq)]))
      return( value_noData ) }
    else {
      return( NA ) }
  }

  cluster_ref <- extend(cluster_ref, c(5, 5))
  #num_de_refinamentos <- 5
  for( i in 1:num_de_refinamentos){
    if(i == 1){
      cluster_ref_foc <- focal(cluster_ref, w=matrix(1,nrow=3,ncol=3), fun=func_viz, pad=T)
      #cluster_ref_foc[is.na(cluster_raster)] <- NA
    }else{
      cluster_ref_foc <- focal(cluster_ref_foc, w=matrix(1,nrow=3,ncol=3), fun=func_viz, pad=T)
      #cluster_ref_foc[is.na(cluster_raster)] <- NA
    }
  }

  pol_clust_ref <- rasterToPolygons(cluster_ref_foc, dissolve=TRUE)
  #spplot(pol_clust_ref)

  if(class(pol_mask) == "SpatialPolygonsDataFrame"){
    row.names(pol_mask) <- "1"
    clip_mask <- gIntersection(pol_clust_ref, pol_mask, byid = T, drop_lower_td = TRUE)
    row.names(clip_mask) <- gsub(" 1", "", row.names(clip_mask))
    keep <- row.names(clip_mask)
    clip_mask <- spChFIDs(clip_mask, keep)
    pol_clust_ref <- SpatialPolygonsDataFrame(clip_mask, data.frame(layer = pol_clust_ref@data[keep, ]))
  }else{
    raster_in_1 <- raster_in
    raster_in_1[!is.na(raster_in_1)] <- 1
    pol_1 <- rasterToPolygons(raster_in_1, dissolve=TRUE)
    row.names(pol_1) <- "1"
    clip_mask <- gIntersection(pol_clust_ref, pol_1, byid = T, drop_lower_td = TRUE)
    row.names(clip_mask) <- gsub(" 1", "", row.names(clip_mask))
    keep <- row.names(clip_mask)
    clip_mask <- spChFIDs(clip_mask, keep)
    pol_clust_ref <- SpatialPolygonsDataFrame(clip_mask, data.frame(layer = pol_clust_ref@data[keep, ]))
  }

  #caminho minimo
  centroids <- gCentroid(pol_clust_ref, byid=TRUE)
  centroids_pts <- SpatialPointsDataFrame(centroids, as.data.frame(centroids))
  proj4string(centroids_pts) <- pol_clust_ref@proj4string

  pts_xy <- as.data.frame(centroids@coords)
  pts_xy$id_old <- 1:nrow(pts_xy)
  dist_xy <- dist(pts_xy)
  tsp <- TSP(dist_xy)
  tour <- solve_TSP(tsp, method =  "farthest_insertion", rep=20,
                    two_opt =TRUE, two_opt_repetitions = 10)

  tour_pts <- pts_xy[tour,]
  maxy <- which.min(tour_pts$y)
  tour_pts <- rbind( tour_pts[maxy:nrow(tour_pts), ], tour_pts[0:(maxy-1), ] )

  pol_resul <- pol_clust_ref[tour_pts$id_old,]
  pol_resul@data$layer <- NULL
  pol_resul@data$NomeID <- 1:nrow(pts_xy)
  #width_str <- length(strsplit(as.character(nrow(pts_xy)), "")[[1]])
  width_str <- 3
  pol_resul@data$Nome <- paste(iniID, formatC(1:nrow(pts_xy), width = width_str, flag = "0"), sep = "")

  mean_r <- extract(raster_in, pol_resul, fun = mean, na.rm = T, small = T)
  sd_r <- extract(raster_in, pol_resul, fun = sd, na.rm = T, small = T)
  cv <- sd_r/mean_r * 100
  len_r <- extract(raster_in, pol_resul, fun=function(x,...)length(x), na.rm = T, small = T)
  area_cell <- res(raster_in)[1]^2
  area_r <- len_r * area_cell
  area_total <- sum(area_r)

  if(groups > 3) {
    apt_kmeans <- kmeans(mean_r, 3)$cluster
    apt_mean_cluster <- as.data.frame(cbind(mean_r, apt_kmeans))
    apt_mean_cluster$ordem <- 1:nrow(apt_mean_cluster)
    agreg <- aggregate( V1 ~ apt_kmeans, FUN = mean, data = apt_mean_cluster)
    agreg <- agreg[order(agreg$V1),]
    agreg$aptidao <- c("BAIXA", "MEDIA", "ALTA")
    agreg_merg <- merge(apt_mean_cluster, agreg, 'apt_kmeans', sort = FALSE)
    field_apt <- agreg_merg[agreg_merg$ordem, ]$aptidao
  } else{
    field_apt <- "MEDIA"
  }

  pol_resul@data$Media <- as.vector(mean_r)
  pol_resul@data$Desv_Pad <- as.vector(sd_r)
  pol_resul@data$CV <- as.vector(cv)
  pol_resul@data$Area_ha <- as.vector(area_r / 10000)
  pol_resul@data$Aptidao <- field_apt
  pol_resul@data$Constante <- 1

  Poligono_Zonas_de_Manejo =  pol_resul























  return(det)

