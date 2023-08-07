#'Está função serve para analisar imagens do satélite sentinel
#'
#'@description Função gera informações a partir de imagens sentinel já corrigidas (Download feito pelo plugin SCP - Semi-Automatic Classification plugin). Gera os seguintes indices de vegetação: NDVI, SFDVI, NDII e EVI. Gera também arquivo xlsx da mediana destes indices.
#'
#'
#'@param kml link dos arquivos kml
#'@param past link dos arquivos sentinel corrigidos
#'@param savall link da pasta para salvar todos os resultados
#'
#'@importFrom terra crds crop mask writeRaster rast
#'
#'@example
#'#analises_sentinel(kml, past, savall)
#'
#'@export
#'@return Returns a images indices and data excel
#'@author Santos Henrique Brant Dias

analises_sentinel <- function(kml, past, savall) {

  library(raster)
  library(rgdal)
  library(stringr)
  library(xlsx)
  library(sp)
  library(terra)

  kmls <-  kml

  #Mudar a pasta que as imagens desse kml está
  pasts <-  dir(past, full.names = T, include.dirs = T)

  img1 <- dir(pasts[1],pattern = ".jp2",full.names = T, recursive =T, include.dirs = T)

  #j=1
  for (j in 1:length(kmls)) {
    nkml <- stringr::str_sub(unlist(strsplit(kmls[j],'/'))[length(unlist(strsplit(kmls[j],'/')))], 1,-5)

    print(nkml)


    area_shape <- rgdal::readOGR(kmls[j])
    print('Read kml')
    area_shape <- sp::spTransform(area_shape, proj4string(raster(img1[1])))
    print('CRS reprojection done')


  #i=1
    for (i in 1:length(pasts)) {
    dat<-stringr::str_sub(pasts[i],start=-10)
    print(paste0(i,' / ',dat))

    print('Opening raster files')

    B02 <- raster::raster(dir(pasts[i], pattern = '_B02.jp2',full.names = T, recursive =T, include.dirs = T))
    B03 <- raster::raster(dir(pasts[i], pattern = '_B03.jp2',full.names = T, recursive =T, include.dirs = T))
    B04 <- raster::raster(dir(pasts[i], pattern = '_B04.jp2',full.names = T, recursive =T, include.dirs = T))
    B08 <- raster::raster(dir(pasts[i], pattern = '_B08.jp2',full.names = T, recursive =T, include.dirs = T))
    B06 <- raster::raster(dir(pasts[i], pattern = '_B06.jp2',full.names = T, recursive =T, include.dirs = T))
    B11 <- raster::raster(dir(pasts[i], pattern = '_B11.jp2',full.names = T, recursive =T, include.dirs = T))


    cort <- raster::buffer(area_shape, width = 200)

    if(!is.null(raster::intersect(raster::extent(cort),B02))){
      print('kml inside the raster image')}else{
        print('Próximo')
        rm(B02,B03,B04,B08,B06,B11,cort,dat)
        next}

    print('Cutting rasters with kml')
    B02 <- mask(crop(B02,extent(cort)),cort)
    B03 <- mask(crop(B03,extent(cort)),cort)
    B04 <- mask(crop(B04,extent(cort)),cort)
    B08 <- mask(crop(B08,extent(cort)),cort)
    B06 <- mask(crop(B06,extent(cort)),cort)
    B11 <- mask(crop(B11,extent(cort)),cort)

    print("Changing resolution B06 and B11 to 10m")
    B06 <- resample(B06, B04, method='bilinear')
    B11 <- resample(B11, B04, method='bilinear')

    print("Calculating the NDVI, SFDVI, NDII and EVI indices")
    #Indices
      NDVI <- (B08-B04)/(B08+B04)
      SFDVI <- ((B08+B03)/2)/((B04+B06)/2)
      NDII <- (B08-B11)/(B08+B11)
      EVI <- (2.5*(B08-B04))/(B08+6*B04+7.5*B02+1)

    print('Improving the resolution of images, longer step')

    NDVI <- raster::disaggregate(NDVI, fact = c(5,5), method='bilinear')
    SFDVI <- raster::disaggregate(SFDVI, fact = c(5,5), method='bilinear')
    NDII <- raster::disaggregate(NDII, fact = c(5,5), method='bilinear')
    EVI <- raster::disaggregate(EVI, fact = c(5,5), method='bilinear')

    NDVI <- mask(crop(NDVI,extent(area_shape)),area_shape)
    SFDVI <- mask(crop(SFDVI,extent(area_shape)),area_shape)
    NDII <- mask(crop(NDII,extent(area_shape)),area_shape)
    EVI <- mask(crop(EVI,extent(area_shape)),area_shape)


    print('Creating the folder to save the image')
    if(dir.exists(savall)==T){print('Folder already exists')}else{dir.create(savall)}

    if(dir.exists(paste0(savall, '/Imgs_PNG'))==T){print('Folder already exists')}else{dir.create(paste0(savall, '/Imgs_PNG'))}

    cm_plot<-paste0(savall, '/Imgs_PNG/',nkml)

    if(dir.exists(cm_plot)==T){print('Folder already exists')}else{dir.create(cm_plot)}

    print("Saving PNG image")

    png(paste0(cm_plot,'/NDVI_',dat,".png"),
        width=1500, height=1350, res=200)
    base::plot(NDVI, main=paste0('NDVI',' | ',dat,' | ',nkml))
    base::plot(area_shape, add=T)
    dev.off()

    print("Extracting values from each polygon")

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

    print("Saving GeoTIFF files")

    if(dir.exists(paste0(savall, '/Indices_areas'))==T){print('Folder already exists')}else{dir.create(paste0(savall, '/Indices_areas'))}

    if(dir.exists(paste0(savall,'/Indices_areas/',nkml))==T){print('Folder already exists')}else{dir.create(paste0(savall,'/Indices_areas/',nkml))}

    writeRaster(NDVI, filename = (paste0(savall,'/Indices_areas/',nkml,'/','NDVI_',dat,'.tif')),
                format ="GTiff", epsg = 4326, overwrite=TRUE)

    writeRaster(SFDVI, filename = (paste0(savall,'/Indices_areas/',nkml,'/','SFDVI_',dat,'.tif')),
                format ="GTiff", epsg = 4326, overwrite=TRUE)

    writeRaster(NDII, filename = (paste0(savall,'/Indices_areas/',nkml,'/','NDII_',dat,'.tif')),
                format ="GTiff", epsg = 4326, overwrite=TRUE)

    writeRaster(EVI, filename = (paste0(savall,'/Indices_areas/',nkml,'/','EVI_',dat,'.tif')),
                format ="GTiff", epsg = 4326, overwrite=TRUE)


    rm(dat,i,s,B02,B03,B04,B08,B06,B11,NDVI,SFDVI,NDII,EVI,cort,vrt,
       vsdndvi,vndvi,vsfdvi,vndii,vevi,vb02,vb03,vb04,vb06,vb08,vb11,
       cm_plot,cm_plot_SF)
  }

    print("Saving excel of medians extracted from each polygon")


    write.xlsx(santosT,paste0(savall, '/Indices_areas/',
                            'dados_',nkml,'.xlsx'))
  rm(santosT,area_shape,cm_area,i,nkml)
}}

