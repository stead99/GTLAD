library(dplyr)
library(ggplot2)
library(ggthemes)
library(survival)
library(survminer)
library(data.table)
library(ggpubr)
source('./code/config.R')

### Figure 7B ------
dt_maf_rs <- readRDS('./data/figure7/rs_maf.rds')
dt_maf_rn <- readRDS('./data/figure7/rn_maf.rds')
pt <- coBarplot(m1 = dt_maf_rs, m2 = dt_maf_rn, m1Name = "Relapse", m2Name = "Non-relapse", 
          genes = genes_sig, yLims = c(50, 50), colors = vc_cols, pctSize = 0.3, orderBy = 'm1')
print(pt)

### Figure 7C-D ------
dt_snv_path_peak <- readRDS('./data/figure7/dt_snv_path_peak.rds')
pt <- ggplot(dt_snv_path_peak, aes(phenotype, gene_symbol, fill = logP)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "dodgerblue4", high = "firebrick3", mid = "white", 
                       midpoint = 3, space = "Lab", 
                       name = "log10(P)") +
  theme_minimal()+ # minimal theme
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 8, hjust = 1)) +
  geom_text(aes(phenotype, gene_symbol, label = sigp), color = "gray33", size = 5) +
  facet_grid(data_type ~ ., scales = 'free', space = 'free') +  
  coord_trans() + 
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

### Figure 7E ------
dt_fre_site_core <- readRDS('./data/figure7/dt_fre_site_core.rds')
pt <- ggplot(dt_fre_site_core, aes(x = group, y = mut_fre, fill = group)) +
  geom_bar(stat = "identity") + 
  scale_fill_manual(values = color_phe[c(unique(as.character(dt_fre_site$group)))]) +
  facet_wrap(. ~ SBS, nrow = 2, scales = 'free_x') + 
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 8, hjust = 1))
print(pt)

### Figure 7F ------
dt_hr_rfs_sig <- readRDS('./data/figure7/dt_hr_rfs_sig.rds')
pt <- ggplot(
  dt_hr_rfs_sig, aes(x = reorder(var_name, HR), y =  HR, ymin = HR_low, ymax = HR_high)) +  
  geom_pointrange(color = 'lightgrey', fill = 'firebrick3', shape = 22, lwd = 1, size = 5, fatten = 3) +
  geom_hline(yintercept = 1, colour = 'grey', linetype = "dashed") + 
  labs(x = 'Gene', y = 'HR') +
  scale_y_break(c(8, 10), scales = 0.5) + 
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))
print(pt)

### Figure 7G-H ------
dt_snv_path_peak <- readRDS('./data/figure7/dt_snv_path_peak.rds')
pt <- ggplot(dt_snv_path_peak, aes(phenotype, gene_symbol, fill = logP)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "dodgerblue4", high = "firebrick3", mid = "white", 
                       midpoint = 0, space = "Lab", 
                       name = "log10(P)") +
  theme_minimal()+ # minimal theme
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 8, hjust = 1)) +
  geom_text(aes(phenotype, gene_symbol, label = sigp), color = "gray33", size = 5) +
  facet_grid(data_type ~ ., scales = 'free', space = 'free') +  
  coord_trans() + 
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