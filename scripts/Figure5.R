library(dplyr)
library(ggplot2)
library(ggthemes)
library(survival)
library(survminer)
library(data.table)
library(ggpubr)
source('./code/config.R')

### Figure 5B-D ------
dt_tmb <- fread('./data/figure5/lc_1000_tmb.csv')
dt_ratio <- fread('./data/figure5/lc_1000_sbs_wgd.csv')

pt <- ggboxplot(dt_tmb,
                x = 'GGO', 
                y = "total_perMB_log", 
                color = 'GGO', 
                fill = 'GGO',
                alpha = 0.6,
                add = "jitter", 
                add.params = list(size = 0.5, alpha = 2),
                outlier.shape = NA) +
  theme_few() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(x = NULL)
print(pt)

pt <- ggboxplot(dt_tmb,
                x = 'GGO', 
                y = "sv_log", 
                color = 'GGO', 
                fill = 'GGO',
                alpha = 0.6,
                add = "jitter", 
                add.params = list(size = 0.5, alpha = 2),
                outlier.shape = NA) +
  theme_few() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(x = NULL)
print(pt)

pt <- ggplot(dt_ratio, 
             aes(x = reorder(GGO, sbs2_13), 
                 y = sbs2_13, 
                 fill = GGO)) +
  geom_bar(stat = "identity") + 
  theme_few() +
  theme(axis.text.x = element_text(angle = 45, 
                                   vjust = 1, 
                                   size = 8, 
                                   hjust = 1))
print(pt)

pt <- ggplot(dt_ratio, 
             aes(x = reorder(GGO, wgd), 
                 y = wgd, 
                 fill = GGO)) +
  geom_bar(stat = "identity") + 
  theme_few() +
  theme(axis.text.x = element_text(angle = 45,
                                   vjust = 1, 
                                   size = 8, 
                                   hjust = 1))
print(pt)

### Figure 5E ------
lc_maf_1000 <- read.maf('./data/figure2/lc_1000.maf')
lc_maf_s <- subsetMaf(lc_maf_1000, tsb = sample_s, restrictTo = "all", mafObj = TRUE)
lc_maf_ns <- subsetMaf(lc_maf_1000, tsb = sample_ns, restrictTo = "all", mafObj = TRUE)
coBarplot(m1 = dt_maf_s, 
          m2 = dt_maf_ns, 
          m1Name = "Solid", 
          m2Name = "Non-solid", 
          genes = genes_sig, 
          yLims = c(65, 65), 
          colors = vc_cols, 
          pctSize = 0.3, 
          orderBy = 'm1')

### Figure 5F-G ------
dt_gene_fre <- readRDS('./data/figure5/gene_frequency_per_ggo.rds')
ggplot(dt_gene_fre, aes(x = GGO, y = frequency)) + 
      geom_bar(aes(fill = type), 
               stat = 'identity', 
               color = 'black') +
      facet_wrap(.~ gene_symbol, 
                 nrow = 2, 
                 scales = 'free_y') +
      theme(axis.text.x = element_text(angle = 45, 
                                       vjust = 1, 
                                       hjust = 1)) +
      labs(x = 'Group', y = 'Frequency (%)')

### Figure 5H ------
mat_hall <- readRDS('./data/figure5/ggo_hallmark.rds')
HT = Heatmap(mat_hall, 
             name = "H  enrichemnt score", 
             col = colorRamp2(c(-1, 0, 1), c('dodgerblue4', "white", "brown")),
             top_annotation = ha, 
             column_split = dt_cli_dd[['GGO']], 
             show_row_names = TRUE, 
             show_column_names = FALSE, 
             clustering_method_columns = 'ward.D2', 
             clustering_method_rows = 'ward.D2', 
             cluster_columns = TRUE, 
             column_dend_reorder = TRUE, 
             cluster_column_slices = FALSE,
             cluster_rows = TRUE, 
             row_dend_reorder = TRUE, 
             show_row_dend = TRUE, 
             show_column_dend = TRUE, 
             show_heatmap_legend = TRUE,
             row_names_gp = gpar(fontsize = 13, fontface = "bold"),
             column_names_gp = gpar(fontsize = 16, fontface = "bold")) + 
      Heatmap(left_anno, name = "anno", col = left_colors,   width = 10)


### Figure 5I ------
dt_vol <- readRDS('./data/figure5/ggo_volcano.rds')
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
      labs(x = 'Solid/GGO', 
           y = '-log10 (qvalue)', 
           title = NULL) +
      theme_few(base_size = 18) 
print(pt_v)