library(readxl)
library(data.table)
library(stringr)

#gps <- data.table(read_excel("gps_data.xlsx", sheet = 1))

print(gps[,Name_FirstLast][1])
Players <- c()
num_players <- 0

for (p in gps[,Name_FirstLast]) {
  if (p %in% Players == FALSE) {
    Players <- c(Players,p)
    num_players <- num_players + 1
  }
}

# Get wanted stats and create columns in dt
stats <- c()
stats_to_search <- c("MP","Eff_Cnt","PL")
for (n in stats_to_search) {
  # Get all column names containing n
  stats <- c(stats,grep(n,colnames(gps),value=TRUE))
}

cols <- colnames(gps)[2:length(colnames(gps))]
gps.mean <- gps[,lapply(.SD, base::mean, na.rm = TRUE, null.rm = TRUE), by = Name_FirstLast, .SDcols = stats]

########### IGNORE FOR NOW ##########
if (FALSE) {
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
}
###############################################

saveRDS(gps.mean,"player_data.rds") 
rm(n,num_players,p,Players,stats,stats_to_search, cols)
  
  
  
  