#'Função gera informações a partir de imagens sentinel já corrigidas (Download feito pelo plugin SCP - Semi-Automatic Classification plugin). Gera os seguintes indices de vegetação: NDVI, SFDVI, NDII e EVI. Gera também arquivo xlsx da mediana destes indices.
#'
#'Está função serve para analisar imagens do satélite sentinel
#'
#'@param kml link dos arquivos kml
#'@param past link dos arquivos sentinel corrigidos
#'@param savall link da pasta para salvar todos os resultados
#'
#'@example
#'analises_sentinel('C:/Users/OneDrive/KMLs_areas','C:/Users/OneDrive/Sentinel_Images/22KDF_22KDG_22KEF',
#''C:/Users/OneDrive/FET/Projects/R')
#'
#'@export
#'@return Returns a images indices and data excel
#'@author Santos Henrique Brant Dias

analises_sentinel <- function(kml,past, savall) {

  if(!require("pacman")) install.packages("pacman");pacman::p_load(
  raster, rgdal, rgeos,stringr, xlsx, sp, terra)

  kmls <-  dir(kml, full.names = T, include.dirs = T)

  #Mudar a pasta que as imagens desse kml está
  pasts <-  dir(past, full.names = T, include.dirs = T)

  img1 <- dir(pasts[1],pattern = ".jp2",full.names = T, recursive =T, include.dirs = T)

  for (j in 1:length(kmls)) {
    nkml <- str_sub(unlist(strsplit(kmls[z],'/'))[length(unlist(strsplit(kmls[z],'/')))], 1,-5)

    print(nkml)

    area_shape <- readOGR(kmls[j])

    area_shape <- sp::spTransform(area_shape, proj4string(raster(img1[1])))


  for (i in 1:length(pasts)) {
    dat<-stringr::str_sub(pasts[i],start=-10)
    print(paste0(i,' / ',dat))

    B02<-raster(dir(pasts[i], pattern = '_B02.jp2',full.names = T, recursive =T, include.dirs = T))
    B03<-raster(dir(pasts[i], pattern = '_B03.jp2',full.names = T, recursive =T, include.dirs = T))
    B04<-raster(dir(pasts[i], pattern = '_B04.jp2',full.names = T, recursive =T, include.dirs = T))
    B08<-raster(dir(pasts[i], pattern = '_B08.jp2',full.names = T, recursive =T, include.dirs = T))
    B06<-raster(dir(pasts[i], pattern = '_B06.jp2',full.names = T, recursive =T, include.dirs = T))
    B11<-raster(dir(pasts[i], pattern = '_B11.jp2',full.names = T, recursive =T, include.dirs = T))


    cort <- gBuffer(area_shape, width = 200)

    if(!is.null(intersect(extent(cort),B02))){
      print('kml dentro da imagem')}else{
        print('Próximo')
        rm(B02,B03,B04,B08,B06,B11,cort,dat)
        next}

    B02 <- mask(crop(B02,extent(cort)),cort)
    B03 <- mask(crop(B03,extent(cort)),cort)
    B04 <- mask(crop(B04,extent(cort)),cort)
    B08 <- mask(crop(B08,extent(cort)),cort)
    B06 <- mask(crop(B06,extent(cort)),cort)
    B11 <- mask(crop(B11,extent(cort)),cort)

    B06 <- resample(B06, B04, method='bilinear')
    B11 <- resample(B11, B04, method='bilinear')

    #Indices
    {
      NDVI <- (B08-B04)/(B08+B04)
      plot(NDVI, main='NDVI')

      SFDVI <- ((B08+B03)/2)/((B04+B06)/2)
      plot(SFDVI, main='SFDVI')

      NDII <- (B08-B11)/(B08+B11)
      plot(NDII, main='NDII')

      EVI <- (2.5*(B08-B04))/(B08+6*B04+7.5*B02+1)
      plot(EVI, main='EVI')

    }

    NDVI <- disaggregate(NDVI, fact = c(6,6), method='bilinear')
    SFDVI <- disaggregate(SFDVI, fact = c(6,6), method='bilinear')
    NDII <- disaggregate(NDII, fact = c(6,6), method='bilinear')
    EVI <- disaggregate(EVI, fact = c(6,6), method='bilinear')

    NDVI <- mask(crop(NDVI,extent(area_shape)),area_shape)
    SFDVI <- mask(crop(SFDVI,extent(area_shape)),area_shape)
    NDII <- mask(crop(NDII,extent(area_shape)),area_shape)
    EVI <- mask(crop(EVI,extent(area_shape)),area_shape)


    cm_plot<-paste0(savall, '/Imgs_PNG/',nkml)
    cm_plot_SF <- paste0(savall, '/Imgs_PNG/', nkml,'/SFDVI')

    if(dir.exists(cm_plot)==T){'Pasta já existe'}else{dir.create(cm_plot)}
    if(dir.exists(cm_plot_SF)==T){'Pasta já existe'}else{dir.create(cm_plot_SF)}

    png(paste0(cm_plot,'/NDVI_',dat,".png"),
        width=1500, height=1350, res=200)
    plot(NDVI, main=paste0('NDVI',' | ',dat,' | ',nkml))
    plot(area_shape, add=T)
    dev.off()

    png(paste0(cm_plot_SF,'/SFDVI_',dat,".png"),
        width=2400, height=1800, res=300)
    plot(SFDVI, main=paste0('SFDVI',' | ',dat,' | ',nkml))
    plot(area_shape, add=T)
    dev.off()

    #plot(area_shape[5,],add=T)

    for (s in 1:length(area_shape)) {

      vsdndvi <- sd(getValues(mask(crop(NDVI,extent(area_shape[s,])),area_shape[s,])), na.rm = TRUE)

      vndvi <- median(getValues(mask(crop(NDVI,extent(area_shape[s,])),area_shape[s,])), na.rm = TRUE)
      vsfdvi <- median(getValues(mask(crop(SFDVI,extent(area_shape[s,])),area_shape[s,])), na.rm = TRUE)
      vndii <- median(getValues(mask(crop(NDII,extent(area_shape[s,])),area_shape[s,])), na.rm = TRUE)
      vevi <- median(getValues(mask(crop(EVI,extent(area_shape[s,])),area_shape[s,])), na.rm = TRUE)

      vb02 <- median(getValues(mask(crop(B02,extent(area_shape[s,])),area_shape[s,])), na.rm = TRUE)
      vb03 <- median(getValues(mask(crop(B03,extent(area_shape[s,])),area_shape[s,])), na.rm = TRUE)
      vb04 <- median(getValues(mask(crop(B04,extent(area_shape[s,])),area_shape[s,])), na.rm = TRUE)
      vb06 <- median(getValues(mask(crop(B06,extent(area_shape[s,])),area_shape[s,])), na.rm = TRUE)
      vb08 <- median(getValues(mask(crop(B08,extent(area_shape[s,])),area_shape[s,])), na.rm = TRUE)
      vb11 <- median(getValues(mask(crop(B11,extent(area_shape[s,])),area_shape[s,])), na.rm = TRUE)

      vrt <- data.frame(nkml,dat,s,area_shape$Name[s],vsdndvi,vndvi,vsfdvi,vndii,vevi,vb02,vb03,vb04,vb06,vb08,vb11)
      names(vrt)<-c('Area','Data','N','Nome_Area','Desvio_NDVI','NDVI','SFDVI','NDII','EVI','B02','B03','B04','B06','B08','B11')
      if(exists('santosT')==T){santosT<-rbind(santosT, vrt)}else{santosT<-vrt}
    }

    cm_area<-paste0(savall,'/Indices_areas/',nkml)

    if(dir.exists(cm_area)==T){'Pasta já existe'}else{dir.create(cm_area)}

    writeRaster(NDVI, filename = (paste0(cm_area,'/','NDVI_',dat,'.tif')),
                format ="GTiff", epsg = 4326, overwrite=TRUE)

    writeRaster(SFDVI, filename = (paste0(cm_area,'/','SFDVI_',dat,'.tif')),
                format ="GTiff", epsg = 4326, overwrite=TRUE)

    writeRaster(NDII, filename = (paste0(cm_area,'/','NDII_',dat,'.tif')),
                format ="GTiff", epsg = 4326, overwrite=TRUE)

    writeRaster(EVI, filename = (paste0(cm_area,'/','EVI_',dat,'.tif')),
                format ="GTiff", epsg = 4326, overwrite=TRUE)


    rm(dat,i,s,B02,B03,B04,B08,B06,B11,NDVI,SFDVI,NDII,EVI,cort,vrt,
       vsdndvi,vndvi,vsfdvi,vndii,vevi,vb02,vb03,vb04,vb06,vb08,vb11,
       cm_plot,cm_plot_SF)
  }

  write.xlsx(santosT,paste0(savall, '/Indices_areas/',
                            'dados_',nkml,'.xlsx'))
  rm(santosT,area_shape,cm_area,i,nkml)
}}

