library(dplyr)
library(ComplexHeatmap)
library(maftools)
library(ggplot2)
library(ggthemes)
source('./code/config.R')

### data input ------
mat_snv <- readRDS('./data/figure2/mat_snv.rds')
mat_fusion <- readRDS('./data/figure2/mat_snv.rds')
mat_arm <- readRDS('./data/figure2/mat_arm.rds')
  
### Figure 2A ------  
mat_anno <- readRDS('./data/figure2/mat_phe.rds')
pt_bottom <- HeatmapAnnotation(
  df = mat_anno, 
  col = col_anno, 
  na_col = 'lightgrey',
  simple_anno_size = unit(0.35, "cm")
)

heatmap_legend_param = list(title = "Alternations", 
                            at = names(vc_cols), 
                            labels = names(vc_cols))

ht <- oncoPrint(mat_snv, 
                column_order = NULL, 
                show_row_names= TRUE, 
                remove_empty_rows = FALSE,
                alter_fun = alter_fun, 
                col = vc_cols,
                row_names_side = 'left', 
                pct_side = 'right',
                top_annotation = NULL, 
                show_pct = TRUE,
                heatmap_legend_param = heatmap_legend_param) %v% 
      oncoPrint(mat_fusion,
                column_order = NULL, 
                show_row_names= TRUE, 
                remove_empty_rows = FALSE,
                alter_fun = alter_fun, 
                col = vc_cols, 
                row_names_side = 'left', 
                pct_side = 'right',
                top_annotation = NULL, 
                show_pct = TRUE,
                heatmap_legend_param = heatmap_legend_param) %v% 
      oncoPrint(mat_arm, 
                column_order = NULL, 
                show_row_names= TRUE,
                remove_empty_rows = FALSE,
                alter_fun = alter_fun, 
                col = vc_cols, 
                row_names_side = 'left', 
                pct_side = 'right',
                top_annotation = NULL, 
                show_pct = TRUE,
                heatmap_legend_param = heatmap_legend_param,
                bottom_annotation = pt_bottom)
print(ht)

### Figure 2B ------
lc_maf_1000 <- read.maf('./data/figure2/lc_1000.maf')
lc_maf_1000 <- read.maf('./data/figure2/lc_197.maf')
lollipopPlot(m1 = lc_maf_1000, 
             gene = "MAP2K1", 
             AACol = "HGVSp_Short")

lollipopPlot(m1 = lc_maf_197, 
             gene = "MAP2K1", 
             AACol = "HGVSp_Short")

### Figure 2D ------
tcgaCompare(maf = lc_maf_1000, 
            cohortName = 'FUSCC', 
            logscale = TRUE, 
            capture_size = 35.8, 
            col = "firebrick3", 
            bg_col = c("grey", "#2C7FB8"), 
            rm_zero = FALSE)

### Figure 2E ------
gscore_inv <- readRDS('./figure2/gscore_inv.rds')
gscore_pre <- readRDS('./figure2/gscore_pre.rds')

# invasive ---
gisticChromPlot(gistic = gscore_inv, 
                fdrCutOff = 0.25, 
                cytobandOffset = 0.03,
                ref.build = "hg38")

# preinvasive ---
gisticChromPlot(gistic = gscore_pre, 
                fdrCutOff = 0.25, 
                cytobandOffset = 0.03,
                ref.build = "hg38")

### Figure 2F ------
dt_co_ex <- readRDS('./figure2/lc_1000_co_exp_mat.rds')
pt <- ggplot(dt_co_ex, aes(gene1, gene2, fill = log10fdr)) +
      geom_tile(color = "white") +
      scale_fill_gradient2(low = "purple", 
                           high = "darkseagreen3", 
                           mid = "aliceblue", 
                           midpoint = 0, space = "Lab", 
                           name = "log10(FDR)") +
      theme_minimal()+ # minimal theme
      theme(axis.text.x = element_text(angle = 45,
                                       vjust = 1, 
                                       size = 8, 
                                       hjust = 1)) +
      coord_fixed() + 
      geom_text(aes(gene1, gene2, label = sig_res), 
                color = "white",
                size = 6) +
      theme(axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            panel.grid.major = element_blank(),
            panel.border = element_blank(),
            panel.background = element_blank(),
            axis.ticks = element_blank(),
            legend.justification = c(1, 0),
            legend.position = c(0.6, 0.7),
            legend.direction = "horizontal") +
      guides(fill = guide_colorbar(barwidth = 10,
                                   barheight = 1,
                                   title.position = "top",
                                   title.hjust = 0.5))
print(pt)