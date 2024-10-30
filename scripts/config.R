### config files ------
vc_cols = c('#1F78B4', 
            '#FB9A99', 
            '#B2DF8A', 
            '#A6CEE3', 
            '#33A02C', 
            '#FF7F00', 
            '#FDBF6F', 
            '#CAB2D6', 
            '#6A3D9A', 
            '#FFFF99', 
            '#B15928', 
            '#E31A1C',  
            '#9ECAE1', 
            'firebrick3', 
            'deepskyblue2', 
            'plum3', 
            'plum3', 
            '#FD8D3C', 
            '#1F78B4', 
            '#33A02C', 
            '#6A3D9A', 
            '#E31A1C',
            'white')

names(vc_cols) = c(
  'Missense_Mutation',
  'Frame_Shift_Ins',
  'Nonsense_Mutation',
  'Frame_Shift_Del',
  'Multi_Hit',
  'In_Frame_Del',
  'In_Frame_Ins',
  'Splice_Site',
  'Translation_Start_Site',
  'Truncating',
  'Inframe_Mutation',
  'Promoter_Mutation',
  'Nonstop_Mutation',
  'Amp',
  'Del',
  'Yes',
  'Fusion')

alter_fun = list(
  background = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = "#F8F8F8", col = NA))
  },
  # NA
  miss = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = "white", col = NA))
  } ,
  # Missense_Mutation
  Missense_Mutation = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = vc_cols["Missense_Mutation"], col = NA))
  },
  # Nonsense_Mutation
  Nonsense_Mutation = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = vc_cols["Nonsense_Mutation"], col = NA))
  },
  # Splice_Site
  Splice_Site = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = vc_cols["Splice_Site"], col = NA))
  },
  # Frame_Shift_Del
  Frame_Shift_Del = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = vc_cols["Frame_Shift_Del"], col = NA))
  },
  # Frame_Shift_Ins
  Frame_Shift_Ins = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = vc_cols["Frame_Shift_Ins"], col = NA))
  },
  # In_Frame_Del
  In_Frame_Del = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = vc_cols["In_Frame_Del"], col = NA))
  },
  # In_Frame_Ins
  In_Frame_Ins = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = vc_cols["In_Frame_Ins"], col = NA))
  },
  # Multi_Hit
  Multi_Hit = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = vc_cols["Multi_Hit"], col = NA))
  }, 
  # Translation_Start_Site
  Translation_Start_Site = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = vc_cols["Translation_Start_Site"], col = NA))
  },
  # Truncating
  Truncating = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = vc_cols["Truncating"], col = NA))
  },
  # Inframe_Mutation
  Inframe_Mutation = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = vc_cols["Inframe_Mutation"], col = NA))
  },
  # Promoter_Mutation
  Promoter_Mutation = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = vc_cols["Promoter_Mutation"], col = NA))
  },
  # Nonstop_Mutation
  Nonstop_Mutation = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = vc_cols["Nonstop_Mutation"], col = NA))
  },
  # Amplification
  Amp = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = vc_cols["Amp"], col = NA))
  },
  # Deletion
  Del = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"),
              gp = gpar(fill = vc_cols["Del"], col = NA))
  },
  # Gene Fusion Yes
  Yes = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = vc_cols["Yes"], col = NA))
  },
  # Gene Fusion Fusion
  Fusion = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), 
              gp = gpar(fill = vc_cols["Fusion"], col = NA))
  }
  )