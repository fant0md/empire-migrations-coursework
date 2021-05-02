cd "C:\Documents\stata"
sysdir set PLUS C:\Documents\stata

import delimited "C:\Documents\PythonDocuments\empire-migrations-coursework\data\interactions.csv", encoding(UTF-8)

gen log_mig_t = log(mig_total+1)
gen log_pop_i = log(pop_total_i)
gen log_pop_j = log(pop_total_j)
gen log_dist = log(distance_capitals)
reg log_mig_t log_pop_i log_pop_j log_dist, cluster(log_dist)

poisson mig_total log_pop_i log_pop_j log_dist, cluster(log_dist)

ppml mig_total log_pop_i log_pop_j log_dist, cluster(log_dist)

gen log_lit_abs = log(abs(lit_rate_total_j - lit_rate_total_i))
gen log_r_abs = log(abs(pop_rate_j - pop_rate_i))
gen log_ind_abs = log(abs(industry_pc_j - industry_pc_i))

ppml mig_total log_pop_i log_pop_j log_dist log_lit_abs log_r_abs log_ind_abs, cluster(log_dist)

gen log_lit_i = log(lit_rate_total_i)
gen log_lit_j = log(lit_rate_total_j)
gen log_r_i = log(pop_rate_i)
gen log_r_j = log(pop_rate_j)
gen log_ind_i = log(industry_pc_i)
gen log_ind_j = log(industry_pc_j)

ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j log_r_i log_r_j log_ind_i log_ind_j, cluster(log_dist)