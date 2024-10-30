library(dplyr)
library(ggplot2)
library(ggthemes)
library(survival)
library(survminer)
library(data.table)

### Fiugre 4B ------
dt_tmb <- fread('./data/figure4/lc_1000_tmb.csv')
dt_ratio <- fread('./data/figure4/lc_1000_sbs_wgd.csv')

pt <- ggboxplot(dt_tmb,
                x = 'group', 
                y = "total_perMB_log", 
                color = 'group', 
                fill = 'group',
                alpha = 0.6,
                add = "jitter", 
                add.params = list(size = 0.5, alpha = 2),
                outlier.shape = NA) +
      theme_few() +
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
      labs(x = NULL)
print(pt)

pt <- ggboxplot(dt_tmb,
                x = 'group', 
                y = "sv_log", 
                color = 'group', 
                fill = 'group',
                alpha = 0.6,
                add = "jitter", 
                add.params = list(size = 0.5, alpha = 2),
                outlier.shape = NA) +
  theme_few() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(x = NULL)
print(pt)

pt <- ggplot(dt_ratio, 
             aes(x = reorder(group, sbs2_13), 
                 y = sbs2_13, 
                 fill = group)) +
  geom_bar(stat = "identity") + 
  theme_few() +
  theme(axis.text.x = element_text(angle = 45, 
                                   vjust = 1, 
                                   size = 8, 
                                   hjust = 1))
print(pt)

pt <- ggplot(dt_ratio, 
             aes(x = reorder(group, wgd), 
                 y = wgd, 
                 fill = group)) +
  geom_bar(stat = "identity") + 
  theme_few() +
  theme(axis.text.x = element_text(angle = 45,
                                   vjust = 1, 
                                   size = 8, 
                                   hjust = 1))
print(pt)

### Figure 4C and 4D ------
dt_regions_l <- readRDS('./data/figure4/ld_region_fdr.rds')
pt <- ggplot(dt_regions_l, 
             aes(x = ldiff, 
                 y = -log10(fdr), 
                 colour = type, 
                 label = peak_chr_pos)) + 
      theme_classic() +
      geom_point(show.legend = FALSE) +
      geom_text_repel(data = subset(dt_regions_l, 
                                    fdr < 0.1 & abs(ldiff) >= 0.2 & n_obs > 10)) +
      geom_vline(xintercept = 0.2, 
                 linetype = 3, 
                 colour = "grey60") +
      geom_vline(xintercept = -0.2, 
                 linetype = 3, 
                 colour = "grey60") +
      geom_hline(yintercept = -log10(0.1), 
                 linetype = 3, 
                 colour="grey60") +
      scale_colour_manual(values = c("firebrick3", "deepskyblue2")) +
      xlab(paste('Latent Difference ', '(', x[2], '/', x[1], ')', sep = '')) + 
      ylab("-log10 (FDR)")
print(pt)

dt_gscore <- readRDS('./data/figure4/diff_gscore.rds')
dt_gscore_chr14 <- dt_gscore['Amp', on = 'type'][chromosome == 'Chr14']
dt_gscore_chr9 <- dt_gscore['Del', on = 'type'][chromosome == 'Chr9']

pt <- ggplot(dt_gscore_chr14, 
             aes(x = start/10^6, 
                 y = value, 
                 color = group)) +
      geom_line() +
      scale_color_manual(values = color_phe[unique(dt_gscore$group)]) + 
      labs(title = cytoband,
           x = "position (Mbp)", 
           y = "G-score") + 
      theme_few () +  
      theme(legend.position = "top", 
            axis.text.y = element_text(color = "black", size = 14),
            axis.title.y = element_text(color = "black", size = 16))
print(pt)

pt <- ggplot(dt_gscore_chr9, 
             aes(x = start/10^6, 
                 y = value, 
                 color = group)) +
      geom_line() +
      scale_color_manual(values = color_phe[unique(dt_gscore$group)]) + 
      labs(title = cytoband,
           x = "position (Mbp)",
           y = "G-score") + 
      theme_few () +  
      theme(legend.position = "top", 
            axis.text.y = element_text(color = "black", size = 14),
            axis.title.y = element_text(color = "black", size = 16))
print(pt)

### Figure 4E-H ------
dt_sur_peak_sbs <- readRDS('./data/figure4/sbs_peak_sur.rds')
lapply(c('14q13.3', '9p31.3', 'SBS2', 'SBS13'), function(x){
  dt_sur_u <- dt_sur_peak_sbs[x, on = 'var']
  
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