library(dplyr)
library(ggplot2)
library(ggthemes)
library(survival)
library(survminer)
library(data.table)
library(ggpubr)
library(VennDiagram)
source('./code/config.R')

### Figure 6A ------
dt_vol <- readRDS('./data/figure6/cnv_pr_volcano.rds')
pt_v <- ggplot(dt_vol, 
               aes(x = logFC, 
                   y = logpavlue, 
                   color = group)) + 
  geom_point() +
  facet_wrap(~ compare_group, nrow = 1) + 
  geom_text_repel(data = subset(dt_vol, 
                                abs(logFC) >= 1.0 & adj.P.Val < 0.05),
                  aes(label = gene_name),
                  size = 3,
                  box.padding = unit(0.15, "lines"),
                  point.padding = unit(0.15, "lines")) + 
  scale_color_manual(values = c(Up = 'firebrick3', 
                                L_up = 'pink', 
                                Down = 'dodgerblue4', 
                                L_down = 'lightskyblue1', 
                                Non_Diff = 'grey')) +
  geom_vline(xintercept = c(-1, 1), 
             colour = 'grey', 
             linetype = "dashed") + 
  geom_hline(yintercept = -log10(0.05), 
             colour = 'grey', 
             linetype = "dashed") + 
  labs(x = 'Log2FC', 
       y = '-log10 (qvalue)', 
       title = NULL) +
  theme_few(base_size = 18) 
print(pt_v)

### Figure 6B and D ------
lapply(c('up', 'down'), function(x){
  if(x == 'up'){
    ggo_degs <- dt_vol[group == 'GGO'][logFC >= 1 & adj.P.Val < 0.05][['gene_name']]
    pstage_degs <- dt_vol[group == 'stage'][logFC >= 1 & adj.P.Val < 0.05][['gene_name']]
    degs_14q13.3 <- dt_vo[group == '1413.3']l[logFC >= 1 & adj.P.Val < 0.05][['gene_name']]
  } else if (x == 'down'){
    ggo_degs <- dt_vol[group == 'GGO'][logFC <= -1 & adj.P.Val < 0.05][['gene_name']]
    pstage_degs <- dt_vol[group == 'stage'][logFC <= -1 & adj.P.Val < 0.05][['gene_name']]
    degs_14q13.3 <- dt_vol[group == '1413.3'][logFC <= -1 & adj.P.Val < 0.05][['gene_name']]
  }
  
  gene_name_list3 <- list(ggo_degs, pstage_degs, degs_14q13.3)
  file_list3 <- c('Solid_vs_GGO', 'IAC_vs_AIS&MIA', 'Amp_vs_None')
  color_compare3 <- c('deepskyblue2', 'plum3', 'orange1')
  names(color_compare3) <- file_list3
  names(gene_name_list3) <- file_list3
  venn_plot3 <- venn.diagram(gene_name_list3, 
                             filename = NULL, 
                             fill = color_compare3, 
                             alpha = c(0.3, 0.3, 0.3), 
                             cex = 2,
                             col = color_compare3, 
                             lwd = 2,
                             cat.col  = color_compare3, 
                             cat.cex = 2,  
                             cat.fontface = "bold",
                             cat.default.pos = "outer")
})

### Figure 6C and E ------
dt_box <- readRDS('./data/figure6/lc_1000_gene_exp.rds')
lapply(c('14q.13.3', 'GGO', 'stage'), function(x){
  dt_box_u <- dt_box[var == x][gene == 'SPP1']
  pt <- ggboxplot(dt_box_u, 
                  x = 'group', 
                  y = "SPP1", 
                  color = 'group', 
                  fill = 'group', 
                  alpha = 0.6, 
                  add = "jitter",
                  add.params = list(size = 0.05, 
                                    jitter = 0.2, 
                                    alpha = 2),
                  outlier.shape = NA) +
        theme_few() + 
        theme(axis.text.x = element_text(angle = 45, 
                                         vjust = 1, 
                                         hjust = 1)) + 
        labs(x = 'Group', 
             y = 'Gene Expression', 
             title = x)
  print(pt)
})

lapply(c('14q.13.3', 'GGO', 'stage'), function(x){
  dt_box_u <- dt_box[var == x][gene == 'SFPTC']
  pt <- ggboxplot(dt_box_u, 
                  x = 'group', 
                  y = "SFPTC", 
                  color = 'group', 
                  fill = 'group', 
                  alpha = 0.6, 
                  add = "jitter",
                  add.params = list(size = 0.05, 
                                    jitter = 0.2, 
                                    alpha = 2),
                  outlier.shape = NA) +
    theme_few() + 
    theme(axis.text.x = element_text(angle = 45, 
                                     vjust = 1, 
                                     hjust = 1)) + 
    labs(x = 'Group', 
         y = 'Gene Expression', 
         title = x)
  print(pt)
})

### Figure 6F and G ------
dt_sur_exp <- readRDS('./data/figure6/lc_1000_gene_exp_sur.rds')
lapply(c('SPP1', 'SFPTC'), function(x){
  dt_sur_u <- dt_sur_exp[x, on = 'gene']
  
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

### Figure 6H ------
dt_tme <- readRDS('./data/figure6/gene_exp.rds')
lapply(c('CD8+T', 'Tregs'), function(x){
  dt_box_u <- dt_tme[var == x]
  pt <- ggboxplot(dt_box_u, 
                  x = 'group', 
                  y = "value", 
                  color = 'group', 
                  fill = 'group', 
                  alpha = 0.6, 
                  add = "jitter",
                  add.params = list(size = 0.05, 
                                    jitter = 0.2, 
                                    alpha = 2),
                  outlier.shape = NA) +
    theme_few() + 
    theme(axis.text.x = element_text(angle = 45, 
                                     vjust = 1, 
                                     hjust = 1)) + 
    labs(x = 'Group', 
         y = 'Score', 
         title = x)
  print(pt)
})

### Figure 6I ------
dt_box <- readRDS('./data/figure6/tcga_gene_exp.rds')
lapply(c('SPP1', 'SPFTC'), function(x){
  dt_box_u <- dt_box[gene == x]
  pt <- ggboxplot(dt_box_u, 
                  x = 'group', 
                  y = "value", 
                  color = 'group', 
                  fill = 'group', 
                  alpha = 0.6, 
                  add = "jitter",
                  add.params = list(size = 0.05, 
                                    jitter = 0.2, 
                                    alpha = 2),
                  outlier.shape = NA) +
    theme_few() + 
    theme(axis.text.x = element_text(angle = 45, 
                                     vjust = 1, 
                                     hjust = 1)) + 
    labs(x = 'Group', 
         y = 'Gene Expression', 
         title = x)
  print(pt)
})

### Figure 6J ------
dt_sur_exp <- readRDS('./data/figure6/tcga_gene_exp_sur.rds')
lapply(c('SPP1', 'SFPTC'), function(x){
  dt_sur_u <- dt_sur_exp[x, on = 'gene']
  
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