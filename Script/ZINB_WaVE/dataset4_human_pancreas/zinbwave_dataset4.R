source('../ZINB_WaVE_analysis.R')

nThread = 8
base_name = basename(getwd())
options(Ncpus = 1) 
b1_rc = fast_read_table('b1_exprs_clean.txt')
b2_rc = fast_read_table('b2_exprs_clean.txt')
b3_rc = fast_read_table('b3_exprs_clean.txt')
b4_rc = fast_read_table('b4_exprs_clean.txt')
b5_rc = fast_read_table('b5_exprs_clean.txt')
# b1_rc = expm1(b1_rc)
# ez_head(b1_rc)
b1_cell_anno = fast_read_table('b1_celltype_clean.txt')
b2_cell_anno = fast_read_table('b2_celltype_clean.txt')
b3_cell_anno = fast_read_table('b3_celltype_clean.txt')
b4_cell_anno = fast_read_table('b4_celltype_clean.txt')
b5_cell_anno = fast_read_table('b5_celltype_clean.txt')

all_b_rc = ezcbind(b1_rc, b2_rc, b3_rc, b4_rc, b5_rc)
all_b_rc = expm1(all_b_rc)
all_b_rc = round(all_b_rc)
### filter genes
# gene_exp = rowSums(all_b_rc)
# # hist(log1p(gene_exp))
# all_b_rc = all_b_rc[gene_exp > 0, ]
# # ez_head(all_b_rc)
all_b_rc_f = seurat_filter_norm_data(all_b_rc)
all_b_rc = all_b_rc[rownames(all_b_rc_f), colnames(all_b_rc_f), drop = F]

all_b_cell_anno = ezrbind(b1_cell_anno, b2_cell_anno, b3_cell_anno, b4_cell_anno, b5_cell_anno)
temp =  create_group(list(colnames(b1_rc), colnames(b2_rc), colnames(b3_rc), colnames(b4_rc), colnames(b5_rc))
                     , c("batch1", "batch2", "batch3", "batch4", "batch5"))
all_b_cell_anno$batch = temp[, 1]
colnames(all_b_cell_anno)[1] = "cell_type"
all_b_cell_anno = all_b_cell_anno[colnames(all_b_rc), , drop = F]

ZINB_WaVE_analysis(all_b_rc, all_b_cell_anno, base_name, nthread = nThread, bigdata = T, prop_fit = 0.1)



