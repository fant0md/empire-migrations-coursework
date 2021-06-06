clear
cd "C:\PythonDocuments\empire-migrations-coursework"
sysdir set PLUS C:\Documents\stata
use "interactions.dta"

*** basic

reg log_mig_t log_pop_i log_pop_j log_dist
poisson mig_total log_pop_i log_pop_j log_dist
ppml mig_total log_pop_i log_pop_j log_dist
est store base

ppml mig_total log_pop_i log_pop_j log_dist borders sea_i sea_j log_lit_i log_lit_j log_urb_i log_urb_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_serfs_i log_serfs_j east_slavic_abs polish_abs jewish_abs german_abs capital_i capital_j tmp_diff wet_diff pre_diff frs_diff vap_diff
est store all

ppml mig_total log_pop_i log_pop_j log_dist borders sea_i sea_j log_lit_i log_lit_j log_urb_i log_urb_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_serfs_i log_serfs_j log_east_slavic_abs log_polish_abs log_jewish_abs log_german_abs capital_i capital_j tmp_diff wet_diff pre_diff frs_diff vap_diff
est store log_all

* test
predict XB, xb
gen XB2 = XB^2
gen XB3 = XB^3
quietly ppml mig_total log_pop_i log_pop_j log_dist borders sea_i sea_j log_lit_i log_lit_j log_urb_i log_urb_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_serfs_i log_serfs_j log_east_slavic_abs log_polish_abs log_jewish_abs log_german_abs capital_i capital_j tmp_diff wet_diff pre_diff frs_diff vap_diff XB2 XB3, cluster(log_dist)
test XB2 XB3
*test XB3 = 0

esttab all log_all


ppml mig_total log_pop_i log_pop_j log_dist borders sea_i sea_j log_lit_i log_lit_j log_urb_i log_urb_j log_den_rur_i log_den_rur_j log_ind_share_i log_ind_share_j log_serfs_i log_serfs_j log_east_slavic_abs log_polish_abs log_jewish_abs log_german_abs capital_i capital_j tmp_diff wet_diff pre_diff frs_diff vap_diff
est store log_denrur

ppml mig_total log_pop_i log_pop_j log_dist borders sea_i sea_j log_lit_i log_lit_j log_urb_i log_urb_j log_ind_share_i log_ind_share_j log_serfs_i log_serfs_j log_east_slavic_abs log_polish_abs log_jewish_abs log_german_abs capital_i capital_j tmp_diff wet_diff pre_diff frs_diff vap_diff
est store log_noden

ppml mig_total log_pop_i log_pop_j log_dist borders log_lit_i log_lit_j log_urb_i log_urb_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_serfs_i log_serfs_j log_east_slavic_abs log_polish_abs log_jewish_abs log_german_abs capital_i capital_j
est store log_nogeo

esttab log_all log_noden log_nogeo
 

ppml mig_total log_pop_i log_pop_j log_dist borders sea_i sea_j log_lit_i log_lit_j log_urb_i log_urb_j log_den_i log_den_j log_ind_i log_ind_j log_serfs_i log_serfs_j log_east_slavic_abs log_polish_abs log_jewish_abs log_german_abs capital_i capital_j tmp_diff wet_diff pre_diff frs_diff vap_diff
est store log_outputs

esttab log_all log_outputs

esttab base log_all log_outputs log_noden using text/tables/results-main.tex, not replace longtable mtitle("Base" "Industry shares" "Industry outputs" "No density") r2 label title("Результаты\label{table:res}") order(log_pop_i log_pop_j log_dist borders sea_i sea_j log_lit_i log_lit_j log_urb_i log_urb_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_ind_i log_ind_j log_serfs_i log_serfs_j log_east_slavic_abs log_polish_abs log_jewish_abs log_german_abs capital_i capital_j tmp_diff wet_diff pre_diff frs_diff vap_diff)

gen log_urb_den_i = log_urb_i * log_den_i
gen log_urb_den_j = log_urb_j * log_den_j

ppml mig_total log_pop_i log_pop_j log_dist borders sea_i sea_j log_lit_i log_lit_j log_urb_i log_urb_j log_den_i log_den_j log_urb_den_i log_urb_den_j log_ind_share_i log_ind_share_j log_serfs_i log_serfs_j log_east_slavic_abs log_polish_abs log_jewish_abs log_german_abs capital_i capital_j tmp_diff wet_diff pre_diff frs_diff vap_diff

*** add abs, maybe wont use

*ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j log_urb_i log_urb_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_agr_share_i log_agr_share_j log_serfs_i log_serfs_j russian_abs polish_abs jewish_abs german_abs capital_i capital_j sea_i sea_j tmp_diff wet_diff pre_diff borders lit_abs urb_abs r_abs den_abs ind_share_abs agr_share_abs serfs_abs
*est store abs_all

*ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j log_urb_i log_urb_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_agr_share_i log_agr_share_j  log_serfs_i log_serfs_j log_russian_abs log_polish_abs log_jewish_abs log_german_abs capital_i capital_j sea_i sea_j tmp_diff wet_diff pre_diff borders log_lit_abs log_urb_abs log_r_abs log_den_abs log_ind_share_abs log_agr_share_abs log_serfs_abs
*est store log_abs_all

*esttab abs_all log_abs_all

*ppmlhdfe mig_total log_dist log_russian_abs log_polish_abs log_jewish_abs log_german_abs borders log_lit_abs log_urb_abs log_r_abs log_den_abs log_ind_share_abs log_agr_share_abs log_serfs_abs, a(region_i region_j)
*est store fe

*esttab log_abs_all fe

*** rural-urban breakdown

ppml mig_rural log_pop_i log_pop_j log_dist borders sea_i sea_j log_lit_i log_lit_j log_urb_i log_urb_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_serfs_i log_serfs_j log_east_slavic_abs log_polish_abs log_jewish_abs log_german_abs capital_i capital_j tmp_diff wet_diff pre_diff frs_diff vap_diff
est store log_all_rural

ppml mig_urban log_pop_i log_pop_j log_dist borders sea_i sea_j log_lit_i log_lit_j log_urb_i log_urb_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_serfs_i log_serfs_j log_east_slavic_abs log_polish_abs log_jewish_abs log_german_abs capital_i capital_j tmp_diff wet_diff pre_diff frs_diff vap_diff
est store log_all_urban

esttab log_all log_all_rural log_all_urban using text/tables/results-br.tex, not replace longtable r2 label title("Urban-Rural breakdown\label{table:ruralurban}")

*** only europe

ppml mig_total log_pop_i log_pop_j log_dist borders sea_i sea_j log_lit_i log_lit_j log_urb_i log_urb_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_serfs_i log_serfs_j log_east_slavic_abs log_polish_abs log_jewish_abs log_german_abs capital_i capital_j tmp_diff wet_diff pre_diff frs_diff vap_diff if macroregion_i=="European Russia" & macroregion_j=="European Russia"
est store log_all_eu

ppml mig_total log_pop_i log_pop_j log_dist borders sea_i sea_j log_lit_i log_lit_j log_urb_i log_urb_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_serfs_i log_serfs_j log_east_slavic_abs log_polish_abs log_jewish_abs log_german_abs capital_i capital_j tmp_diff wet_diff pre_diff frs_diff vap_diff lnrail_i lnrail_j grain_prod_i grain_prod_j log_land_price_i log_land_price_j log_peasant_inc_i log_peasant_inc_j if macroregion_i=="European Russia" & macroregion_j=="European Russia"
est store log_add_eu

ppml mig_total log_pop_i log_pop_j log_dist borders sea_i sea_j log_lit_i log_lit_j log_urb_i log_urb_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_serfs_i log_serfs_j log_east_slavic_abs log_polish_abs log_jewish_abs log_german_abs capital_i capital_j tmp_diff wet_diff pre_diff frs_diff vap_diff lnrail_i lnrail_j grain_prod_i grain_prod_j log_land_price_i log_land_price_j log_peasant_inc_i log_peasant_inc_j if macroregion_i=="European Russia" & macroregion_j=="European Russia"

ppml mig_urban log_pop_i log_pop_j log_dist borders sea_i sea_j log_lit_i log_lit_j log_urb_i log_urb_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_serfs_i log_serfs_j log_east_slavic_abs log_polish_abs log_jewish_abs log_german_abs capital_i capital_j tmp_diff wet_diff pre_diff frs_diff vap_diff lnrail_i lnrail_j grain_prod_i grain_prod_j log_land_price_i log_land_price_j log_peasant_inc_i log_peasant_inc_j if macroregion_i=="European Russia" & macroregion_j=="European Russia"
est store log_add_eu_urb

ppml mig_rural log_pop_i log_pop_j log_dist borders sea_i sea_j log_lit_i log_lit_j log_urb_i log_urb_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_serfs_i log_serfs_j log_east_slavic_abs log_polish_abs log_jewish_abs log_german_abs capital_i capital_j tmp_diff wet_diff pre_diff frs_diff vap_diff lnrail_i lnrail_j grain_prod_i grain_prod_j log_land_price_i log_land_price_j log_peasant_inc_i log_peasant_inc_j if macroregion_i=="European Russia" & macroregion_j=="European Russia"
est store log_add_eu_rur

esttab log_all log_all_eu log_add_eu_urb log_add_eu_rur using text/tables/results-eu.tex, not replace longtable mtitle("All regions" "Only European" "Added vars, urban" "Added vars, rural") r2 label title("Европейская Россия\label{table:eu}") drop(log_east_slavic_abs log_polish_abs log_jewish_abs log_german_abs tmp_diff wet_diff pre_diff frs_diff vap_diff)
