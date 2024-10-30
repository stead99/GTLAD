library(dplyr)
library(ggplot2)
library(ggthemes)
library(survival)
library(survminer)
library(data.table)
library(networkD3)

### Figure 1B and 1C ------
dt_cli <- readRDS('./data/figure1/lc_1000_cli.rds')
dt_cli_long <- data.table(table(dt_cli[, c('GGO', 'P_stage2'), with = FALSE])) %>% 
  dcast(GGO ~ P_stage2, value.var = 'N') %>% 
  gather(key = 'key', value = 'value', -GGO)
dt_cli_long <- dt_cli_long[dt_cli_long$value > 0, ]

colnames(dt_cli_long) <- c("source", "target", "value")
dt_cli_long$target <- paste(dt_cli_long$target, " ", sep = "")

nodes <- data.frame(name=c(as.character(dt_cli_long$source), as.character(dt_cli_long$target)) %>% unique())
dt_cli_long$IDsource = match(dt_cli_long$source, nodes$name) - 1 
dt_cli_long$IDtarget = match(dt_cli_long$target, nodes$name) - 1

# prepare colour scale
ggo_stage_color <- 'd3.scaleOrdinal() .range(["#6BAED6", "#FD8D3C", "#9E9AC8", "#C6DBEF", "#08519C", "#FDAE6B", "#D94801", "#9E9AC8"])'
ColourScal = ggo_stage_color
sankeyNetwork(Links = dt_cli_long, 
              Nodes = nodes,
              Source = "IDsource", 
              Target = "IDtarget",
              Value = "value", 
              NodeID = "name", 
              sinksRight = FALSE, 
              colourScale = ColourScal, 
              nodeWidth = 40, 
              fontSize = 13, 
              nodePadding = 20)


three_var <- list(c('GGO', 'RFS_Status', 'P_stage2'))
dt_cli_d <- dt_cli[RFS_Status == 1]
dt_cli_long_ggo <- data.table(table(dt_cli_d[, c('GGO', 'RFS_Status'), with = FALSE])) %>% 
  dcast(GGO ~ RFS_Status, value.var = 'N') %>% 
  gather(key = 'key', value = 'value', -GGO)
colnames(dt_cli_long_ggo) <- c("source", "target", "value")

dt_cli_long_stage <- data.table(table(dt_cli_d[, c('RFS_Status', 'P_stage2'), with = FALSE])) %>% 
  dcast(RFS_Status ~ P_stage2, value.var = 'N') %>% 
  gather(key = 'key', value = 'value', -RFS_Status)
colnames(dt_cli_long_stage) <- c("source", "target", "value")
dt_cli_long <- rbind(dt_cli_long_ggo, dt_cli_long_stage)

nodes <- data.frame(name=c(as.character(dt_cli_long$source), as.character(dt_cli_long$target)) %>% unique())
dt_cli_long$IDsource = match(dt_cli_long$source, nodes$name) - 1 
dt_cli_long$IDtarget = match(dt_cli_long$target, nodes$name) - 1

# prepare colour scale
ggo_stage_color <- 'd3.scaleOrdinal() .range(["#FD8D3C", "#9E9AC8", "darkred", "#C6DBEF", "#08519C", "#FDAE6B", "#D94801", "#9E9AC8"])'
ColourScal = ggo_stage_color
sankeyNetwork(Links = dt_cli_long, 
              Nodes = nodes,
              Source = "IDsource", 
              Target = "IDtarget",
              Value = "value", 
              NodeID = "name", 
              sinksRight = FALSE, 
              colourScale = ColourScal, 
              nodeWidth = 40, 
              fontSize = 13, 
              nodePadding = 20)

### Figure 1D and 1E ------
lapply(c('P_stage2', 'GGO'), function(x){
  dt_sur_u <- dt_cli[x, on = 'gene']
  
  fit_sp_os <- survfit(Surv(OS_Time, OS_Status) ~ var, data = dt_sur_u)
  fit_sp_rfs <- survfit(Surv(RFS_Time, RFS_Status) ~ var, data = dt_sur_u)
  ggsurvplot(fit_sp_os, 
             pval = TRUE, 
             palette = color_peak, 
             data = dt_sur, 
             risk.table = TRUE, 
             tables.height = 0.25) 
  
  ggsurvplot(fit_sp_rfs, 
             pval = TRUE, 
             palette = color_peak, 
             data = dt_sur, 
             risk.table = TRUE, 
             tables.height = 0.25) 
})

### Figure 1F-1I ------
dt_ratio_cli <- readRDS('./data/figure1/cli_ratio.rds')
lapply(c('age', 'somking', 'gender', 'histology'), function(x){
  dt_ratio <- dt_ratio_cli[x, on = 'var']
  pt <- ggplot(dt_ratio, 
               aes(x = group, 
                   y = ratio, 
                   fill = type)) +
    geom_bar(stat = "identity") + 
    facet_grid(. ~ var_type) + 
    theme_few() +
    theme(axis.text.x = element_text(angle = 45, 
                                     vjust = 1, 
                                     size = 8, 
                                     hjust = 1))
  print(pt)
})

### Figure 1J and 1K ------
dt_num_cli <- readRDS('./data/figure1/cli_ratio.rds')
lapply(c('met_site', 'rfs_time'), function(x){
  dt_num <- dt_num_cli[x, on = 'var']
  pt <- ggplot(dt_num, 
               aes(x = group, 
                   y = ratio, 
                   fill = group)) +
    geom_bar(stat = "identity") + 
    theme_few() +
    theme(axis.text.x = element_text(angle = 45, 
                                     vjust = 1, 
                                     size = 8, 
                                     hjust = 1))
  print(pt)
})