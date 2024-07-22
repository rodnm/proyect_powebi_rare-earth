# Extractor de datos de Series Estadísticas de BCRP ----

#######################################
# Preparando el entorno ----
#######################################
rm(list=ls()) # limpia los objetos guardados en memoria
# dev.off() # apaga el visor de graficos. Solo funciona en una sesion interactiva
graphics.off() # limpia los graficos de la memoria
# cat("\014") # es el codigo que envia el comando ctrl+L para limpiar la consola en RStudio
# cat("\f") # tambien limpia la consola y es mas sencillo de recordar

directorio <- dirname(rstudioapi::getSourceEditorContext()$path) # path del directorio que contiene este archivo R
setwd(directorio)

#######################################
# cargar las librerias ----
#######################################

# library(tidyverse)
# library(lubridate)
# library(stringr)
# library(ggplot2)
# library(ggthemes)
# library(readr)
# library(gridExtra)
# library(cowplot)
# library(dplyr)

# Instala los paquetes necesarios si no los tienes instalados
if (!require(jsonlite)) install.packages("jsonlite")
if (!require(dplyr)) install.packages("dplyr")
if (!require(openxlsx)) install.packages("openxlsx")

# Carga los paquetes
library(jsonlite)
library(dplyr)
library(openxlsx)

# Define el directorio de trabajo donde están los archivos JSON
directorio <- dirname(rstudioapi::getSourceEditorContext()$path) # path del directorio que contiene este archivo R
setwd(directorio)

# Obtén la lista de archivos JSON en la carpeta
archivos_json <- list.files(path = directorio, pattern = "*.json", full.names = TRUE)

# Define el rango de años
anios <- 1995:2022

# Verifica si la cantidad de archivos coincide con la cantidad de años
if (length(archivos_json) != length(anios)) {
  stop("El número de archivos JSON no coincide con el número de años.")
}

# Importa cada archivo JSON, añade la columna Year y almacena en una lista
lista_dataframes <- lapply(seq_along(archivos_json), function(i) {
  # Importa el archivo JSON
  df <- fromJSON(archivos_json[i])
  
  # Convierte los nombres de las columnas a minúsculas
  colnames(df) <- tolower(colnames(df))
  
  # Añade la columna Year
  df <- mutate(df, year = anios[i])
  
  return(df)
})

# Combina todos los dataframes en uno solo
df_combinado <- bind_rows(lista_dataframes)

# Define el nombre del archivo de salida en Excel y CSV
archivo_excel <- "net_trade_data.xlsx"
archivo_csv <- "net_trade_data.csv"

# Crea un nuevo workbook y añade el dataframe combinado con la hoja nombrada "net_trade"
wb <- createWorkbook()
addWorksheet(wb, "net_trade")
writeData(wb, "net_trade", df_combinado)

# Guarda el workbook en un archivo
saveWorkbook(wb, archivo_excel, overwrite = TRUE)

# Exporta el dataframe combinado como CSV separado por "|"
write.csv(df_combinado, archivo_csv, row.names = FALSE, sep = "|")
# readr::write_excel_csv2(df_combinado, archivo_csv, row.names = FALSE, delim = "|")

# Mensaje de éxito
cat("El archivo Excel ha sido guardado como", archivo_excel, "\n")
cat("El archivo CSV ha sido guardado como", archivo_csv, "\n")