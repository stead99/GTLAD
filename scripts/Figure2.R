library(dplyr)
library(ComplexHeatmap)
source('./code/config.R')

### data input ------
mat_snv <- readRDS('./data/figure2/mat_snv.rds')
mat_fusion <- readRDS('./data/figure2/mat_snv.rds')
mat_arm <- readRDS('./data/figure2/mat_arm.rds')
  
### complex heatmap ------  
mat_anno <- readRDS('./data/figure2/mat_phe.rds')
pt_bottom <- HeatmapAnnotation(
  df = df_anno, 
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

