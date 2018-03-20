library(readxl)
library(data.table)
library(stringr)

#gps <- data.table(read_excel("gps_data.xlsx"))

print(gps[,Name_FirstLast][1])
Players <- c()
num_players <- 0

for (p in gps[,Name_FirstLast]) {
  if (p %in% Players == FALSE) {
    Players <- c(Players,p)
    num_players <- num_players + 1
  }
}

# Create new data table to hold stats for each player
dt <- data.table(Name_FirstLast=Players)
# Get wanted stats and create columns in dt
stats <- c()
stats_to_search <- c("MP")
for (n in stats_to_search) {
  # Get all column names containing n
  stats <- grep(n,colnames(gps),value=TRUE)
  # Add each name in stats as column in dt, assigning 0 to each value
  dt[,stats] <- 0
}
# Gather the stats from the data
for (i in 1:nrow(gps)) {
  player <- gps[,Name_FirstLast][i]
  for (j in 1:nrow(dt)) {
    if (dt[,Name_FirstLast][j] == player) {
      row <- j
      break
    }
  }
  for (stat in colnames(dt)) {
    if (stat != "Name_FirstLast") {
      if (gps[[stat]][i] != "NULL") {
        dt[[stat]][row] <- dt[[stat]][row] + gps[[stat]][i]
      }
    }
  }
}

saveRDS(dt,"player_data.rds")
  
  
  
  
  
  