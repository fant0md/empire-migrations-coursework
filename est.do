clear
cd "C:\PythonDocuments\empire-migrations-coursework"
sysdir set PLUS C:\Documents\stata
use "interactions.dta"

*** basic

reg log_mig_t log_pop_i log_pop_j log_dist
poisson mig_total log_pop_i log_pop_j log_dist
ppml mig_total log_pop_i log_pop_j log_dist
est store base

*quietly ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j lit_abs log_urb_i log_urb_j urb_abs log_r_i log_r_j r_abs log_den_i log_den_j den_abs log_ind_share_i log_ind_share_j ind_share_abs log_agr_share_i log_agr_share_j agr_share_abs russian_abs polish_abs jewish_abs ukrainian_abs belorus_abs capital_i capital_j sea_i sea_j tmp_diff wet_diff pre_diff frs_diff vap_diff borders, cluster(log_dist)
*predict XB, xb
*gen XB2 = XB^2
*gen XB3 = XB^3
*quietly ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j lit_abs log_urb_i log_urb_j urb_abs log_r_i log_r_j r_abs log_den_i log_den_j den_abs log_ind_share_i log_ind_share_j ind_share_abs log_agr_share_i log_agr_share_j agr_share_abs russian_abs polish_abs jewish_abs ukrainian_abs belorus_abs capital_i capital_j sea_i sea_j tmp_diff wet_diff pre_diff frs_diff vap_diff borders XB2 XB3, cluster(log_dist)
*test XB2 = 0
*test XB3 = 0

*****

ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j log_urb_i log_urb_j log_r_i log_r_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_agr_share_i log_agr_share_j log_serfs_i log_serfs_j russian_abs polish_abs jewish_abs ukrainian_abs belorus_abs german_abs capital_i capital_j sea_i sea_j tmp_diff wet_diff pre_diff borders lit_abs urb_abs r_abs den_abs ind_share_abs agr_share_abs serfs_abs
est store abs_all

ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j log_urb_i log_urb_j log_r_i log_r_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_agr_share_i log_agr_share_j  log_serfs_i log_serfs_j log_russian_abs log_polish_abs log_jewish_abs log_ukrainian_abs log_belorus_abs log_german_abs capital_i capital_j sea_i sea_j tmp_diff wet_diff pre_diff borders log_lit_abs log_urb_abs log_r_abs log_den_abs log_ind_share_abs log_agr_share_abs log_serfs_abs
est store log_abs_all

esttab abs_all log_abs_all


ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j log_urb_i log_urb_j log_r_i log_r_j log_den_rur_i log_den_rur_j log_ind_share_i log_ind_share_j log_agr_share_i log_agr_share_j  log_serfs_i log_serfs_j log_russian_abs log_polish_abs log_jewish_abs log_ukrainian_abs log_belorus_abs log_german_abs capital_i capital_j sea_i sea_j tmp_diff wet_diff pre_diff borders log_lit_abs log_urb_abs log_r_abs log_den_rur_abs log_ind_share_abs log_agr_share_abs log_serfs_abs
est store log_abs_denrur

ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j log_urb_i log_urb_j log_r_i log_r_j log_ind_share_i log_ind_share_j log_agr_share_i log_agr_share_j  log_serfs_i log_serfs_j log_russian_abs log_polish_abs log_jewish_abs log_ukrainian_abs log_belorus_abs log_german_abs capital_i capital_j sea_i sea_j tmp_diff wet_diff pre_diff borders log_lit_abs log_urb_abs log_r_abs log_den_abs log_ind_share_abs log_agr_share_abs log_serfs_abs
est store log_abs_noden

ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j log_urb_i log_urb_j log_r_i log_r_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_agr_share_i log_agr_share_j  log_serfs_i log_serfs_j log_russian_abs log_polish_abs log_jewish_abs log_ukrainian_abs log_belorus_abs log_german_abs capital_i capital_j borders log_lit_abs log_urb_abs log_r_abs log_den_abs log_ind_share_abs log_agr_share_abs log_serfs_abs
est store log_abs_nogeo

esttab log_abs_all log_abs_denrur log_abs_noden log_abs_nogeo
 

ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j log_urb_i log_urb_j log_r_i log_r_j log_den_i log_den_j log_ind_i log_ind_j log_agr_i log_agr_j  log_serfs_i log_serfs_j log_russian_abs log_polish_abs log_jewish_abs log_ukrainian_abs log_belorus_abs log_german_abs capital_i capital_j sea_i sea_j tmp_diff wet_diff pre_diff borders log_lit_abs log_urb_abs log_r_abs log_den_abs log_ind_abs log_agr_abs log_serfs_abs
est store log_abs_outputs

esttab log_abs_all log_abs_outputs


ppmlhdfe mig_total log_dist log_russian_abs log_polish_abs log_jewish_abs log_ukrainian_abs log_belorus_abs log_german_abs borders log_lit_abs log_urb_abs log_r_abs log_den_abs log_ind_share_abs log_agr_share_abs log_serfs_abs, a(region_i region_j)
est store fe

esttab log_abs_all fe