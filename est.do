clear
cd "C:\PythonDocuments\empire-migrations-coursework"
sysdir set PLUS C:\Documents\stata
import delimited "data\interactions.csv", encoding(UTF-8)

gen log_mig_t = log(mig_total+1)
gen log_pop_i = log(pop_total_i)
gen log_pop_j = log(pop_total_j)
gen log_dist = log(distance_capitals)

reg log_mig_t log_pop_i log_pop_j log_dist
poisson mig_total log_pop_i log_pop_j log_dist
ppml mig_total log_pop_i log_pop_j log_dist


gen log_lit_abs = log(abs(lit_rate_total_j - lit_rate_total_i))
gen log_urb_abs = log(abs(urbanization_j - urbanization_i))
gen log_r_abs = log(abs(pop_rate_j - pop_rate_i))
gen log_den_abs = log(abs(density_total_j - density_total_i))
gen log_ind_abs = log(abs(industry_pc_j - industry_pc_i))
gen log_agr_abs = log(abs(agriculture_pc_j - agriculture_pc_i))
gen log_ind_share_abs = log(abs(industry_j - industry_i))
gen log_agr_share_abs = log(abs(agriculture_j - agriculture_i))

gen log_rus_abs = log(abs(russian_j - russian_i))
gen log_ukr_abs = log(abs(ukrainian_j - ukrainian_i))
gen log_bel_abs = log(abs(belorus_j - belorus_i))
gen log_pol_abs = log(abs(polish_j - polish_i))
gen log_jew_abs = log(abs(jewish_j - jewish_i))
gen log_ger_abs = log(abs(german_j - german_i))

gen lit_abs = abs(lit_rate_total_j - lit_rate_total_i)
gen urb_abs = abs(urbanization_j - urbanization_i)
gen r_abs = abs(pop_rate_j - pop_rate_i)
gen den_abs = abs(density_total_j - density_total_i)
gen ind_abs = abs(industry_pc_j - industry_pc_i)
gen agr_abs = abs(agriculture_pc_j - agriculture_pc_i)
gen ind_share_abs = abs(industry_j - industry_i)
gen agr_share_abs = abs(agriculture_j - agriculture_i)

gen russian_abs = abs(russian_i - russian_j) / 100
gen ukrainian_abs = abs(ukrainian_i - ukrainian_j) / 100
gen polish_abs = abs(polish_i - polish_j) / 100
gen jewish_abs = abs(jewish_i - jewish_j) / 100
gen belorus_abs = abs(belorus_j - belorus_i) / 100
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

gen poland=0
replace poland = 1 if macroregion_i=="Poland" & macroregion_j=="Poland"

gen capital_i = 0
gen capital_j = 0
replace capital_i = 1 if name_i=="Московская губерния" | name_i=="Санкт-Петербургская губерния"
replace capital_j = 1 if name_j=="Московская губерния" | name_j=="Санкт-Петербургская губерния"


ppml mig_total log_pop_i log_pop_j log_dist log_lit_abs log_urb_abs log_r_abs den_abs log_ind_abs log_agr_abs

gen log_lit_i = log(lit_rate_total_i)
gen log_lit_j = log(lit_rate_total_j)
gen log_r_i = log(pop_rate_i)
gen log_r_j = log(pop_rate_j)
gen log_urb_i = log(urbanization_i)
gen log_urb_j = log(urbanization_j)
gen log_den_i = log(density_total_i)
gen log_den_j = log(density_total_j)
gen log_ind_i = log(industry_pc_i)
gen log_ind_j = log(industry_pc_j)
gen log_agr_i = log(agriculture_pc_i)
gen log_agr_j = log(agriculture_pc_j)
gen log_ind_share_i = log(industry_i)
gen log_ind_share_j = log(industry_j)
gen log_agr_share_i = log(agriculture_i)
gen log_agr_share_j = log(agriculture_j)


ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j log_r_i log_r_j log_urb_i log_urb_j log_den_i log_den_j log_ind_i log_ind_j log_agr_i log_agr_j
ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j log_r_i log_r_j log_urb_i log_urb_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_agr_share_i log_agr_share_j

encode name_i, gen(region_i)
encode name_j, gen(region_j)
encode macroregion_i, gen(macro_i)
encode macroregion_j, gen(macro_j)

ppmlhdfe mig_total log_dist log_lit_abs log_urb_abs log_r_abs den_abs log_ind_abs log_agr_abs, a(region_i region_j)
ppmlhdfe mig_total log_dist log_lit_abs log_urb_abs log_r_abs den_abs log_rus_abs log_pol_abs log_jew_abs log_ind_share_abs log_agr_share_abs, a(region_i region_j)


ppmlhdfe mig_total log_dist log_pop_i log_pop_j log_lit_i log_lit_j log_lit_abs log_urb_i log_urb_j log_urb_abs log_r_i log_r_j log_r_abs log_den_i log_den_j log_den_abs log_ind_share_i log_ind_share_j log_ind_share_abs log_agr_share_i log_agr_share_j log_agr_share_abs, a(macro_i macro_j)

ppml mig_total log_dist log_pop_i log_pop_j log_lit_i log_lit_j log_lit_abs log_urb_i log_urb_j log_urb_abs log_r_i log_r_j log_r_abs log_den_i log_den_j log_den_abs log_ind_share_i log_ind_share_j log_ind_share_abs log_agr_share_i log_agr_share_j log_agr_share_abs


ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j lit_abs log_urb_i log_urb_j urb_abs log_r_i log_r_j r_abs log_ind_i log_ind_j ind_abs log_urb_i log_urb_j urb_abs log_den_i log_den_j den_abs russian_abs polish_abs jewish_abs capital_i capital_j

ppml mig_rural log_pop_i log_pop_j log_dist log_lit_i log_lit_j lit_abs log_urb_i log_urb_j urb_abs log_r_i log_r_j r_abs log_ind_i log_ind_j ind_abs log_urb_i log_urb_j urb_abs log_den_i log_den_j den_abs russian_abs polish_abs jewish_abs capital_i capital_j

ppml mig_urban log_pop_i log_pop_j log_dist log_lit_i log_lit_j lit_abs log_urb_i log_urb_j urb_abs log_r_i log_r_j r_abs log_ind_i log_ind_j ind_abs log_urb_i log_urb_j urb_abs log_den_i log_den_j den_abs russian_abs polish_abs jewish_abs capital_i capital_j

ppml mig_urban log_pop_i log_pop_j log_dist log_lit_i log_lit_j lit_abs log_urb_i log_urb_j urb_abs log_r_i log_r_j r_abs log_urb_i log_urb_j urb_abs log_den_i log_den_j den_abs log_ind_share_i log_ind_share_j ind_share_abs log_agr_share_i log_agr_share_j agr_share_abs russian_abs polish_abs jewish_abs capital_i capital_j

ppmlhdfe mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j lit_abs log_urb_i log_urb_j urb_abs log_r_i log_r_j r_abs log_urb_i log_urb_j urb_abs log_den_i log_den_j den_abs log_ind_share_i log_ind_share_j ind_share_abs log_agr_share_i log_agr_share_j agr_share_abs russian_abs polish_abs jewish_abs capital_i capital_j, a(region_i region_j)


quietly ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j lit_abs log_urb_i log_urb_j urb_abs log_r_i log_r_j r_abs log_den_i log_den_j den_abs log_ind_share_i log_ind_share_j ind_share_abs log_agr_share_i log_agr_share_j agr_share_abs russian_abs polish_abs jewish_abs ukrainian_abs belorus_abs capital_i capital_j sea_i sea_j tmp_diff wet_diff pre_diff frs_diff vap_diff borders, cluster(log_dist)
predict XB, xb
gen XB2 = XB^2
gen XB3 = XB^3
quietly ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j lit_abs log_urb_i log_urb_j urb_abs log_r_i log_r_j r_abs log_den_i log_den_j den_abs log_ind_share_i log_ind_share_j ind_share_abs log_agr_share_i log_agr_share_j agr_share_abs russian_abs polish_abs jewish_abs ukrainian_abs belorus_abs capital_i capital_j sea_i sea_j tmp_diff wet_diff pre_diff frs_diff vap_diff borders XB2 XB3, cluster(log_dist)
test XB2 = 0
test XB3 = 0

*****

ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j lit_abs log_urb_i log_urb_j urb_abs log_r_i log_r_j r_abs log_den_i log_den_j den_abs log_ind_share_i log_ind_share_j ind_share_abs log_agr_share_i log_agr_share_j agr_share_abs russian_abs polish_abs jewish_abs ukrainian_abs belorus_abs german_abs capital_i capital_j sea_i sea_j tmp_diff wet_diff pre_diff borders, cluster(log_dist)

est store reg_all

ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j lit_abs log_urb_i log_urb_j urb_abs log_r_i log_r_j r_abs log_den_i log_den_j den_abs log_ind_share_i log_ind_share_j ind_share_abs log_agr_share_i log_agr_share_j agr_share_abs russian_abs polish_abs jewish_abs ukrainian_abs belorus_abs german_abs, cluster(log_dist)

est store nogeo

ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j log_urb_i log_urb_j log_r_i log_r_j log_den_i log_den_j log_ind_share_i log_ind_share_j log_agr_share_i log_agr_share_j russian_abs polish_abs jewish_abs ukrainian_abs belorus_abs german_abs capital_i capital_j sea_i sea_j tmp_diff wet_diff pre_diff borders, cluster(log_dist)

est store reg_noabs

ppmlhdfe mig_total log_dist lit_abs urb_abs r_abs den_abs ind_share_abs agr_share_abs russian_abs polish_abs jewish_abs ukrainian_abs belorus_abs german_abs tmp_diff wet_diff pre_diff borders, cluster(log_dist) a(region_i region_j)

est store fe

ppml mig_total log_pop_i log_pop_j log_dist log_lit_i log_lit_j lit_abs log_urb_i log_urb_j urb_abs log_r_i log_r_j r_abs log_den_i log_den_j den_abs log_ind_i log_ind_j ind_abs log_agr_i log_agr_j agr_abs russian_abs polish_abs jewish_abs ukrainian_abs belorus_abs german_abs capital_i capital_j sea_i sea_j tmp_diff wet_diff pre_diff borders, cluster(log_dist)

est store outputs

ppml mig_total log_pop_i log_pop_j log_dist, cluster(log_dist)

est store reg0

esttab reg0 reg_noabs nogeo reg_all outputs fe