library(tidyverse)
library(fs)
library(stringr)
library(data.table)


# 1.0 Importing Data ----

# 1.1 Getting all the File Paths ----
Geodaten_paths <- fs::dir_ls("Data/Geodaten", glob = "*.csv")
Fahrzeug_paths <- fs::dir_ls("Data/Fahrzeug", glob = "*OEM1*")
#TODO Remove Fehleranalyse from List
Komponente_paths <- fs::dir_ls("Data/Komponente", glob = "*K1*|*K3*")

Motor_Teile_IDs <- sprintf('%0.2d', 2:10)
Schaltung_Teile_IDs <- 21:27
Relevante_Teile_IDs <- c(Motor_Teile_IDs, Schaltung_Teile_IDs)
Einzelteilfilter <- ""
for (ID in Relevante_Teile_IDs) {
  Einzelteilfilter <- paste(Einzelteilfilter, "*", toString(ID), "*|", sep="")
}
Einzelteilfilter <- str_sub(Einzelteilfilter, end = -2)
Einzelteil_paths <- fs::dir_ls("Data/Einzelteil", glob = Einzelteilfilter)
Zulassungen_paths <- fs::dir_ls("Data/Zulassungen")

# 1.2 Importing the Data from their directories and naming them
Geodaten_all <- list()
Fahrzeugdaten_all <- list()
Komponentendaten_all <- list()
Einzelteildaten_all <- list()
#TODO function für die ganzen for loops schreiben und lapply anwenden
#weil schöner
for (i in seq_along(Geodaten_paths)) {
  Geodaten_all[[i]] <- fread(Geodaten_paths[[i]])
}
Geodaten_all <- set_names(Geodaten_all, str_sub(Geodaten_paths, start = 15, end = -5))

for (i in seq_along(Fahrzeug_paths)) {
    Fahrzeugdaten_all[[i]] <- fread(Fahrzeug_paths[[i]])
}
Fahrzeugdaten_all <- set_names(Fahrzeugdaten_all, str_sub(Fahrzeug_paths, start = 15, end = -5))

for (i in seq_along(Komponente_paths)) {
   Komponentendaten_all[[i]] <- fread(Komponente_paths[[i]], quote="")
}
Komponentendaten_all <- set_names(Komponentendaten_all, str_sub(Komponente_paths, start = 17, end = -5))

# 
# for (i in seq_along(Einzelteil_paths)) {
#   Einzelteildaten_all[[i]] <- fread(Einzelteil_paths[[i]])
# }
# Einzelteildaten_all <- set_names(Einzelteildaten_all, str_sub(Einzelteil_paths, start = 16, end = -5))
# 
# 

#Git Test
