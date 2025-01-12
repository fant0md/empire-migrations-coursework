clear
cd "C:\PythonDocuments\empire-migrations-coursework"
sysdir set PLUS C:\Documents\stata
import delimited "data\interactions.csv", encoding(UTF-8)

*** encode strings

encode name_i, gen(region_i)
encode name_j, gen(region_j)
encode macroregion_i, gen(macro_i)
encode macroregion_j, gen(macro_j)


*** basic variables

gen log_mig_t = log(mig_total+1)
gen log_pop_i = log(pop_total_i)
gen log_pop_j = log(pop_total_j)
gen log_dist = log(distance_capitals)


*** interaction-specific variables

gen log_east_slavic_abs = log(abs(east_slavic_j - east_slavic_i))
gen east_slavic_abs = abs(east_slavic_i - east_slavic_j) / 100

gen log_russian_abs = log(abs(russian_j - russian_i))
gen russian_abs = abs(russian_j - russian_i) / 100

gen log_ukrainian_abs = log(abs(ukrainian_j - ukrainian_i))
gen ukrainian_abs = abs(ukrainian_i - ukrainian_j) / 100

gen log_belorus_abs = log(abs(belorus_j - belorus_i))
gen belorus_abs = abs(belorus_j - belorus_i) / 100

gen log_polish_abs = log(abs(polish_j - polish_i))
gen polish_abs = abs(polish_i - polish_j) / 100

gen log_jewish_abs = log(abs(jewish_j - jewish_i))
gen jewish_abs = abs(jewish_i - jewish_j) / 100

gen log_german_abs = log(abs(german_j - german_i))
gen german_abs = abs(german_j - german_i) / 100


gen tmp_abs = abs(tmp_j - tmp_i)
gen tmp_diff = tmp_j - tmp_i

gen wet_abs = abs(wet_j - wet_i)
gen wet_diff = wet_j - wet_i

gen pre_abs = abs(pre_j - pre_i)
gen pre_diff = pre_j - pre_i

gen frs_abs = abs(frs_j - frs_i)
gen frs_diff = frs_j - frs_i

gen vap_abs = abs(vap_j - vap_i)
gen vap_diff = vap_j - vap_i


*** region-specific logged variables and diffs

gen log_lit_i = log(lit_rate_total_i)
gen log_lit_j = log(lit_rate_total_j)
gen lit_abs = abs(lit_rate_total_j - lit_rate_total_i)
gen log_lit_abs = log(lit_abs)
replace log_lit_abs = 0 if lit_abs == 0

gen log_r_i = log(pop_rate_i)
gen log_r_j = log(pop_rate_j)
gen r_abs = abs(pop_rate_j - pop_rate_i)
gen log_r_abs = log(r_abs)
replace log_r_abs = 0 if r_abs == 0

gen log_urb_i = log(urbanization_i)
gen log_urb_j = log(urbanization_j)
gen urb_abs = abs(urbanization_j - urbanization_i)
gen log_urb_abs = log(urb_abs)
replace log_urb_abs = 0 if urb_abs == 0

gen log_den_i = log(density_total_i)
gen log_den_j = log(density_total_j)
gen den_abs = abs(density_total_j - density_total_i)
gen log_den_abs = log(den_abs)
replace log_den_abs = 0 if den_abs == 0

gen log_den_rur_i = log(density_rural_i)
gen log_den_rur_j = log(density_rural_j)
gen den_rur_abs = abs(density_rural_j - density_rural_i)
gen log_den_rur_abs = log(den_rur_abs)
replace log_den_rur_abs = 0 if den_rur_abs == 0

gen log_ind_i = log(industry_pc_i)
gen log_ind_j = log(industry_pc_j)
gen ind_abs = abs(industry_pc_j - industry_pc_i)
gen log_ind_abs = log(ind_abs)
replace log_ind_abs = 0 if ind_abs == 0

gen log_agr_i = log(agriculture_pc_i)
gen log_agr_j = log(agriculture_pc_j)
gen agr_abs = abs(agriculture_pc_j - agriculture_pc_i)
gen log_agr_abs = log(agr_abs)
replace log_agr_abs = 0 if agr_abs == 0

gen log_ind_share_i = log(industry_i)
gen log_ind_share_j = log(industry_j)
gen ind_share_abs = abs(industry_j - industry_i)
gen log_ind_share_abs = log(ind_share_abs)
replace log_ind_share_abs = 0 if ind_share_abs == 0

gen log_agr_share_i = log(agriculture_i)
gen log_agr_share_j = log(agriculture_j)
gen agr_share_abs = abs(agriculture_j - agriculture_i)
gen log_agr_share_abs = log(agr_share_abs)
replace log_agr_share_abs = 0 if agr_share_abs == 0

*** europe

gen log_serfs_i = log(sh_serfs1858_i)
replace log_serfs_i = 0 if sh_serfs1858_i == 0
gen log_serfs_j = log(sh_serfs1858_j)
replace log_serfs_j = 0 if sh_serfs1858_j == 0
gen serfs_abs = abs(sh_serfs1858_j - sh_serfs1858_i)
gen log_serfs_abs = log(serfs_abs)
replace log_serfs_abs = 0 if serfs_abs == 0

gen log_grain_prod_i = log(grain_prod_i)
gen log_grain_prod_j = log(grain_prod_j)
gen grain_prod_abs = abs(grain_prod_j - grain_prod_i)
gen log_grain_prod_abs = log(grain_prod_abs)
replace log_grain_prod_abs = 0 if grain_prod_abs == 0

gen log_peasant_inc_i = log(peasant_inc_i)
gen log_peasant_inc_j = log(peasant_inc_j)
gen peasant_inc_abs = abs(peasant_inc_i - peasant_inc_j)
gen log_peasant_inc_abs = log(grain_prod_abs)
replace log_peasant_inc_abs = 0 if peasant_inc_abs == 0
gen log_peasant_inc_diff = log_peasant_inc_j - log_peasant_inc_i

gen log_land_price_i = log(land_price_i)
gen log_land_price_j = log(land_price_j)
gen land_price_abs = abs(land_price_i - land_price_j)
gen log_land_price_abs = log(land_price_abs)
replace log_land_price_abs = 0 if land_price_abs == 0
gen log_land_price_diff = log_land_price_j - log_land_price_i

*** dummies

gen poland=0
replace poland = 1 if macroregion_i=="Poland" & macroregion_j=="Poland"

gen capital_i = 0
gen capital_j = 0
replace capital_i = 1 if name_i=="Московская губерния" | name_i=="Санкт-Петербургская губерния" | name_i=="Херсонская губерния" | name_i=="Варшавская губерния"
replace capital_j = 1 if name_j=="Московская губерния" | name_j=="Санкт-Петербургская губерния" | name_j=="Херсонская губерния" | name_j=="Варшавская губерния"

*** proper labels
label variable log_pop_i "population_i"
label variable log_pop_j "population_j"
label variable log_dist "distance"
label variable log_lit_i "literacy_i"
label variable log_lit_j "literacy_j"
label variable log_urb_i "urbanization_i"
label variable log_urb_j "urbanization_j"
label variable log_r_i "poprate_i"
label variable log_r_j "poprate_j"
label variable log_den_i "density_i"
label variable log_den_j "density_j"
label variable log_ind_share_i "industry_share_i"
label variable log_ind_share_j "industry_share_j"
label variable log_ind_i "industry_pc_i"
label variable log_ind_j "industry_pc_j"
label variable log_serfs_i "serfs_i"
label variable log_serfs_j "serfs_j"
label variable log_east_slavic_abs "eastslavic_abs_diff"
label variable log_polish_abs "polish_abs_diff"
label variable log_jewish_abs "jewish_abs_diff"
label variable log_german_abs "german_abs_diff"
label variable log_land_price_i "land_price_i"
label variable log_land_price_j "land_price_j"
label variable log_land_price_diff "land_price_diff"
label variable log_peasant_inc_i "peasant_inc_i"
label variable log_peasant_inc_j "peasant_inc_j"
label variable log_peasant_inc_diff "peasant_inc_diff"
label variable lnrail_i "railway_i"
label variable lnrail_j "railway_j"


*** save

save interactions, replace