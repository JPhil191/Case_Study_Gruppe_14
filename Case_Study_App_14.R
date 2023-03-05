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

Motor_Teile_IDs <- sprintf('%0.2d', 1:10)
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
#TODO function für die ganzen for loops schreiben und lapply anwenden
#weil schöner
for (i in seq_along(Geodaten_paths)) {
  data<- fread(Geodaten_paths[[i]])
  assign(str_sub(Geodaten_paths[[i]], start = 15, end = -5), data)
}

for (i in seq_along(Fahrzeug_paths)) {
    data <- fread(Fahrzeug_paths[[i]], header=TRUE)
    assign(str_sub(Fahrzeug_paths[[i]], start = 15, end = -5), data)
}

for (i in seq_along(Komponente_paths)) {
  if (Komponente_paths[[i]] == "Data/Komponente/Komponente_K1DI2.txt") {
    Komponentendaten_all[[i]] <- fread(Komponente_paths[[i]], header=TRUE, sep = "\t", sep2="\\", quote="")
  } else if (Komponente_paths[[i]] == "Data/Komponente/Komponente_K3AG2.txt") {
    data <- fread(Komponente_paths[[i]], sep = "\\", quote="")
  } else {
    data <- fread(Komponente_paths[[i]], quote="")
  }
  assign(str_sub(Komponente_paths[[i]], start = 17, end = -5), data)
}

for (i in seq_along(Einzelteil_paths)) {
  data <- fread(Einzelteil_paths[[i]])
  assign(str_sub(Einzelteil_paths[[i]], start = 17, end = -5), data)
}









convert_column_to_binary_factor <- function(data, column_name) {
  
  data <- data %>%
    mutate(faulty_factor = as.factor(column_name))
  return(data)
}

