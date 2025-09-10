library(dplyr)
library(ggplot2)
library(ggthemes)
library(survival)
library(survminer)
library(data.table)
library(networkD3)

### Figure 1B ------
dt_nrd <- readRDS('./data/figure1/dt_nrd.rds')
pt <- ggplot(dt_nrd, aes(var, group, fill = ratio)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "#1F78B4", mid = "white",  high = "orange2", 
                       midpoint = 50, space = "Lab", 
                       name = "log10(P)") +
  theme_minimal()+ # minimal theme
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 8, hjust = 1)) +
  facet_grid(facet_g ~ phe, scales = 'free', space = 'free') +  
  coord_trans() + 
  geom_text(aes(var, group, label = ratio2), color = "black", size = 4) +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    legend.justification = c(-2, 0),
    legend.position = c(0.6, 0.7),
    legend.direction = "vertical") +
  guides(fill = guide_colorbar(barwidth = 1.5, barheight = 10,
                               title.position = "top", title.hjust = 0.5))
print(pt)

### Figure 1C and 1D ------
dt_cli <- readRDS('./data/figure1/lc_1000_cli.rds')
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