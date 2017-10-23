//Cleaning ONLY Farmer First dataset for EPAR Request 340: Farmer Focus Gender Attitudes
//Started June 2016 by Mia Neidhardt
//Updated 9/26/16 by Audrey Lawrence
//Checked by Katie Harris (KPH) 9/8/16
//Cleaned by Daniel Lunchick-Seymour 10/16/17
********************************************************************************

clear
**set directories (neither dataset has genders fixed)
global oldinput "\\evansfiles\Files\Project\EPAR\Non-LSMS Datasets\Farmer First Dataset\Old versions of data\Jan 18 2011\Farmer 1st.dta"
global newinput "\\evansfiles\Files\Project\EPAR\Non-LSMS Datasets\Farmer First Dataset\Old versions of data\April 15 2011\Farmer 1st Mali Tanzania 04152011.dta"
global output "\\evansfiles\Files\Project\EPAR\Archive\340 - Farmer First Gender Attitudes\Analysis\9.22.16 FINAL Analysis\Cleaned do files (Daniel Oct 2017)\Cleaned Analysis Output"

use "$oldinput"

///////////////Demographic variables (Section 1)////////////////////////////////
gen country = .
replace country=0 if q2_1==1
replace country=1 if q2_1==2
la var country "Country q2_1"
la define countryl 0 "Mali" 1 "Tanzania"
la values country countryl

gen gender_fem =. 
replace gender_fem=1 if res_gender==2
replace gender_fem=0 if res_gender==1
la var gender_fem "Respondent gender"
la define gender_feml 0 "Male" 1 "Female"
la values gender_fem gender_feml

	**Correcting Tanzania genders
	replace gender_fem=0 if inlist(res_id, 1017, 1052, 1119, 1133, 1362, 1644, 1686, 1814, 1938, 1987, 2583, 2663, 2724, 2755, 2882, 4644)
	replace gender_fem=1 if inlist(res_id, 3019, 3047, 3255, 3267, 3881, 3933, 4018, 4294, 4799, 4906)

	**Correcting Mali genders
	replace gender_fem=0 if inlist(res_id, 5187, 5301, 5357, 5373, 5468, 5550, 5560, 6930, 6952, 7385, 7869)
	replace gender_fem=1 if inlist(res_id, 6892, 6904, 6905, 7264, 7344, 7345, 8217, 8224, 8899, 8942)

gen age = q1_3a
la var age "Respondent age"

gen ed_years = q1_6
replace ed_years=. if q1_6==99
la var ed_years "Years of education"

gen ed_type = q1_5
la var ed_type "Level of education achieved q1_5"
la define schools 1 "None" 2 "Primary School" 3 "Secondary School" 4 "Post-secondary college but not universi" 5 "University" 6 "Adult education" 7 "Madrassa"
la values ed_type schools

gen b_educationlevel=.
replace b_educationlevel=0 if q1_5==1
replace b_educationlevel=1 if q1_5==2 | q1_5==2 | q1_5==3 | q1_5==4 | q1_5==5 | q1_5==6 | q1_5==7
la define b_educationlevell 0 "No education" 1 "Some education"
la values b_educationlevel b_educationlevell
la var b_educationlevel "Binary education level: 0=No education 1=Some education"

gen religion = q1_9
replace religion=. if q1_9==99
replace religion=0 if religion==4 //redefining Muslims==0 for the purposes of regression analysis
la var religion "Respondent's religion"
la define relig 0 "Muslim" 1 "Catholic" 2 "Protestant" 5 "Hindu" 6 "Traditional African Faith" 7 "None" 8 "Other"
label values religion relig

gen farmer = q1_10
la var farmer "Is the resp a farmer? q1_10"

gen years_farming = q1_11
replace years_farming = . if q1_11==-9
la var years_farming "Years of farming experience q1_11"
 
gen years_managing_farm = q1_12
replace years_managing_farm = . if q1_12==-9
la var years_managing_farm "Years of managing own farm q1_12"

gen health = q1_16
la var health "Self-reported health 1=Very poor - 5=Very good"

*Children
gen num_daughters = 0
foreach x of numlist 1/12{
	replace num_daughters = num_daughters + 1 if q3_1a_`x' == 4
}
replace num_daughters = . if q3_1a_1==.

gen num_sons = 0
foreach x of numlist 1/12{
	replace num_sons = num_sons + 1 if q3_1a_`x' == 3
}
replace num_sons = . if q3_1a_1==.

gen num_children = num_sons + num_daughters

*Children under 15
gen num_daughters_u15 = 0
foreach x of numlist 1/12{
	replace num_daughters_u15 = num_daughters_u15 + 1 if q3_1a_`x' == 4 & q3_1b_`x' < 15
}
replace num_daughters_u15 = . if q3_1a_1==.

gen num_sons_u15 = 0
foreach x of numlist 1/12{
	replace num_sons_u15 = num_sons_u15 + 1 if q3_1a_`x' == 3 & q3_1b_`x' < 15
}
replace num_sons_u15 = . if q3_1a_1==.

gen num_children_u15 = num_sons_u15 + num_daughters_u15
	la var num_children_u15 "Number of children u15 in hh"

//Risk Variables (Section 1)
gen risk_policy = q1_20_1
	la var risk_policy "Risk: worry about ag policy q1_20_1"
gen risk_econ_situation = q1_20_2
	la var risk_econ_situation "Risk: worry about econ situation q1_20_2"
gen risk_conflict = q1_20_3
	la var risk_conflict "Risk: worry about conflict q1_20_3" 
gen risk_input_costs = q1_20_4
	la var risk_input_costs "Risk: worry about rising input cost q1_20_4"
gen risk_crop_prices = q1_20_5
	la var risk_crop_prices "Risk: worry about falling crop prices q1_20_5"
gen risk_food_prices = q1_20_6
	la var risk_food_prices "Risk: worry about rising food prices q1_20_6"
gen risk_debt = q1_20_7
	la var risk_debt "Risk: worry about debt situation q1_20_7"
gen risk_crop_yields = q1_20_8
	la var risk_crop_yields "Risk: worry about poor crop yield q1_20_8"
gen risk_interest_rates = q1_20_9
	la var risk_interest_rates "Risk: worry about rising interest rates q1_20_9"
gen risk_variable_climate = q1_20_10
	la var risk_variable_climate "Risk: worry about variable climate condition q1_20_10"
gen risk_frost = q1_20_11
	la var risk_frost "Risk: worry about frost q1_20_11"
gen risk_rain_excess = q1_20_12
	la var risk_rain_excess "Risk: worry about excessive rain q1_20_12"
gen risk_rain_insuff = q1_20_13
	la var risk_rain_insuff "Risk: worry about insufficient rain q1_20_13"
gen risk_crop_disease = q1_20_14
	la var risk_crop_disease "Risk: worry about crop diseases q1_20_14"
gen risk_pest = q1_20_15
	la var risk_pest "Risk: worry about pests q1_20_15"
gen risk_work_accident = q1_20_16
	la var risk_work_accident "Risk: worry about work accidents q1_20_16"
gen risk_health = q1_20_17
	la var risk_health "Risk: worry about health problems q1_20_17"
gen risk_family_relation = q1_20_18
	la var risk_family_relation "Risk: worry about family relationships q1_20_18"
gen risk_community_relation = q1_20_19
	la var risk_community_relation "Risk: worry about community relationships q1_20_19"
gen risk_land_prices = q1_20_20 
	la var risk_land_prices "Risk: worry about rising land prices q1_20_20"
gen risk_family_labor_insuff = q1_20_21
	la var risk_family_labor_insuff "Risk: worry about insufficient family labor q1_20_21"
gen risk_finding_labor = q1_20_22
	la var risk_finding_labor "Risk: worry about finding labor q1_20_22"
gen risk_lack_contract = q1_20_23
	la var risk_lack_contract "Risk: worry about lack of contract q1_20_23"
gen risk_tools_insuff = q1_20_24
	la var risk_tools_insuff "Risk: worry about insufficient machinery q1_20_24"
gen risk_theft = q1_20_25
	la var risk_theft "Risk: worry about theft q1_20_25"
gen risk_fire = q1_20_26
	la var risk_fire "Risk: worry about fire q1_20_26"
gen risk_flood = q1_20_27
	la var risk_flood "Risk: worry about floods q1_20_27"
gen risk_landslide = q1_20_28
	la var risk_landslide "Risk: worry about landslides q1_20_28"
gen risk_lack_farm_records = q1_20_29
	la var risk_lack_farm_records "Risk: worry about lack of farm records q1_20_29"
gen risk_temp_warmer = q1_20_30
	la var risk_temp_warmer "Risk: worry about warmer avg temperatures q1_20_30"
gen risk_change_rain_timing = q1_20_31
	la var risk_change_rain_timing "Risk: worry about changing rain timing q1_20_31"
gen risk_extreme_weather = q1_20_32
	la var risk_extreme_weather "Risk: worry about more extreme weather q1_20_32"
gen risk_security = q1_20_33
	la var risk_security "Risk: worry about security crime q1_20_33"
gen risk_work_injury = q1_20_34
	la var risk_work_injury "Risk: worry about injuries at work q1_20_34"
gen risk_scarcity_inputs = q1_20_35
	la var risk_scarcity_inputs "Risk: worry about scarce farm inputs q1_20_35"
gen risk_scarcity_land = q1_20_36
	la var risk_scarcity_land "Risk: worry about scarce farming land q1_20_36"
gen risk_lack_buyers = q1_20_37
	la var risk_lack_buyers "Risk: worry about lack of produce buyers q1_20_37"
gen risk_land_disputes = q1_20_38
	la var risk_land_disputes "Risk: worry about land disputes q1_20_38"

global risk risk_policy risk_econ_situation risk_conflict risk_input_costs risk_crop_prices ///
risk_food_prices risk_debt risk_crop_yields risk_interest_rates risk_variable_climate ///
risk_frost risk_rain_excess risk_rain_insuff risk_crop_disease risk_pest risk_work_accident ///
risk_health risk_family_relation risk_community_relation risk_land_prices risk_family_labor_insuff ///
risk_finding_labor risk_lack_contract risk_tools_insuff risk_theft risk_fire risk_flood ///
risk_landslide risk_lack_farm_records risk_temp_warmer risk_change_rain_timing ///
risk_extreme_weather risk_security risk_work_injury risk_scarcity_inputs risk_scarcity_land ///
risk_lack_buyers risk_land_disputes

foreach x in $risk {
	replace `x' =. if `x'==9
}

****************Make outcome variables binary for additional analysis******
	
	foreach x in $risk {
		generate b_`x'=.
		replace b_`x'=0 if `x'==1
		replace b_`x'=1 if `x'==2 | `x'==3
	}

	
***************Make outcome variables binary WITH DIFFERENT groupings for additional analysis *********************

	foreach x in $risk {
		generate b12_`x'=.
		replace b12_`x'=0 if `x'==1 | `x'==2
		replace b12_`x'=1 if `x'==3
	}

//Farm variables (Section 4)
gen all_plots_acres =.
replace all_plots_acres = q4_2a_1 if q4_2a_1>=0
global plots q4_2a_2 q4_2a_3 q4_2a_4 q4_2a_5 q4_2a_6
foreach x in $plots {
	replace all_plots_acres = all_plots_acres + `x' if `x'!=. & `x'>0
	}
	la var all_plots_acres "Household's acres (owned & rented)"

//Attitudes (Section 10)
gen att_child_not_farmer = q10_1_1
	la var att_child_not_farmer "Prefer children not be farmers q10_1_1"
gen att_no_hope_poor_farmers = q10_1_2
	la var att_no_hope_poor_farmers "No hope for poor farmers to improve q10_1_2"
gen att_choice_not_farmer = q10_1_3
	la var att_choice_not_farmer "Prefer not to be a farmer q10_1_3"
gen att_best_invest_farming = q10_1_4
	la var att_best_invest_farming "No better investment than farming q10_1_4"
gen att_destiny_farmer = q10_1_5
	la var att_destiny_farmer "It is destiny to be a farmer q10_1_5"
gen att_follow_father = q10_1_6
	la var att_follow_father "Adopted farming following father and grandfather q10_1_6"
gen att_proud_farmer = q10_1_7
	la var att_proud_farmer "Proud to be a farmer q10_1_7"
gen att_farmwork_chore = q10_1_8
	la var att_farmwork_chore "Farmwork is a chore without joy q10_1_8"
gen att_need_know_people = q10_1_9
	la var att_need_know_people "Cannot be good farmer unless know many people q10_1_9"
gen att_can_cope = q10_1_10
	la var att_can_cope "Self-Efficacy:No problem in farming I can't cope with 1=disagrees 5=agrees"
gen att_need_help_others = q10_1_11
	la var att_need_help_others "Cannot be good farmer without help from others q10_1_11"
gen att_no_advice_others = q10_1_12
	la var att_no_advice_others "Individualistic: Don't want others to tell me what to do on farm 1=disagrees completely-5=agrees completely"
gen att_possible_improve_farm = q10_1_13
	la var att_possible_improve_farm "Always possible to make improvements to farm q10_1_13"
gen att_few_lasting_improvements = q10_1_14
	la var att_few_lasting_improvements "Few areas in farming where we can make lasting improvements q10_1_14"
gen att_cant_avoid_misfortune = q10_1_15
	la var att_cant_avoid_misfortune "Fatalistic: Can't avoid misfortune if destined 1=disagrees completely-5=agrees completely"
gen att_ngo_responsible = q10_1_16
	la var att_ngo_responsible "Responsiblity of NGOs for my farm's success q10_1_16"
gen att_no_point_improve = q10_1_17
	la var att_no_point_improve "No point in making improvements to farm q10_1_17"
gen att_best_sit_back_wait = q10_1_18
	la var att_best_sit_back_wait "Best to sit back and wait during problems q10_1_18"
gen att_personal_sacrifice_farm = q10_1_19
	la var att_personal_sacrifice_farm "Should regularly make personal sacrifices for farm q10_1_19"
gen att_risk_new_crop = q10_1_20
	la var att_risk_new_crop "Big risk to try a new crop or animal q10_1_20"
gen att_past_failure = q10_1_21
	la var att_past_failure "Past failure put me off doing new things on farm q10_1_21"
gen att_no_opinion_others = q10_1_22
	la var att_no_opinion_others "Don't need other farmers' opinions for farm changes q10_1_22"
gen att_watch_others = q10_1_23
	la var att_watch_others "Always watching others for improvements to farm q10_1_23"
gen att_farm_business = q10_1_24
	la var att_farm_business "I view my farm as a business q10_1_24"
gen att_danger_first_implement = q10_1_25
	la var att_danger_first_implement "Dangerous to be first to implement new farm idea q10_1_25"
gen att_change_progress = q10_1_26
	la var att_change_progress "Need to change on farm in order to progress q10_1_26"
gen att_no_plan = q10_1_27
	la var att_no_plan "No point planning ahead in farming q10_1_27"
gen att_men_women_partners = q10_1_28
	la var att_men_women_partners "Men & women should be equal farm partners q10_1_28"
gen att_spouse_follow = q10_1_29
	la var att_spouse_follow "My spouse follows my suggestions on farm q10_1_29"
gen att_witchcraft = q10_1_30
	la var att_witchcraft "Need to account for witchcraft when deciding something q10_1_30"
gen att_search_info = q10_1_31
	la var att_search_info "Frequently seek out new info about farming q10_1_31"
gen att_discuss_farm = q10_1_32
	la var att_discuss_farm "Often discuss farming methods with people q10_1_32"
gen att_advice_successful = q10_1_33
	la var att_advice_successful "Only take advice from successful farmers q10_1_33"
gen att_family_advice = q10_1_34
	la var att_family_advice "Family & friends often ask my farming advice q10_1_34"
gen att_consider_carefully = q10_1_35
	la var att_consider_carefully "Look into new farm things carefully before deciding q10_1_35"
gen att_new_ideas_first = q10_1_36
	la var att_new_ideas_first "Love trying new farming ideas before others q10_1_36"
gen att_save_time = q10_1_37
	la var att_save_time "Any farm method that saves me time is worth it q10_1_37"
gen att_tell_others = q10_1_38
	la var att_tell_others "Social: Like to tell others about new methods 1=disagree - 5=agree"
gen att_farm_self_identity = q10_1_39
	la var att_farm_self_identity "What I do on my farm says something about who I am q10_1_39"
gen att_packs_posters = q10_1_40
	la var att_packs_posters "Often read pack and posters to learn about input brands q10_1_40"
gen att_like_info = q10_1_41
	la var att_like_info "Like getting info about new products or practices q10_1_41"
gen att_see_success = q10_1_42
	la var att_see_success "Like to see success on other farm before I try it out q10_1_42"
gen att_ask_advice = q10_1_43
	la var att_ask_advice "People often ask for my farming advice q10_1_43"


////////////////////////////////////////////////////////////////////////////
**************************Variables for Risk Model**************************
///////////////////////////////////////////////////////////////////////////
 
**Preserve missing value for all variables 
 
gen married=.
replace married = 0 if q1_4 == 3 | q1_4 == 4 | q1_4 == 5
replace married = 1 if q1_4 == 1 | q1_4 == 2
la var married "Marriage status"

gen married_monogamous=.
replace married_monogamous = 0 if q1_4 == 2
replace married_monogamous = 1 if q1_4 == 1
la var married_monogamous "Marriage: 0=polygamous 1=monogamous"
la define married_monogamousl 0 "Polygamous" 1 "Monogamous"
la values married_monogamous married_monogamousl
//1=monogamous, 0=polygamous

gen parents=.
replace parents = 0 if num_daughters==0 & num_sons==0
replace parents = 1 if num_daughters!=0 | num_sons!=0
la var parents "Parental status"

gen food_secure_cat=0
foreach x of numlist 1/10 {
	replace food_secure_cat = food_secure_cat + 1 if q7_2_`x'>=1 & q7_2_`x'<=12
	}
la var food_secure_cat "Food security for hh: number of hungry months"

//Recoding food security based on USAID & USDA/FANTA guidelines
gen food_secure_cat2=.
replace food_secure_cat2=0 if food_secure_cat==0
replace food_secure_cat2=1 if (food_secure_cat==1 | food _secure_cat==2 | food_secure_cat==3)
replace food_secure_cat2=2 if food_secure_cat>=4
	la var food_secure_cat2 "Food security categories: 0=least food insecure 1 = moderate 2= most food insecure"

gen income_secure=.
replace income_secure=0 if q7_1==1
replace income_secure=1 if q7_1==2 | q7_1==3
replace income_secure=. if q7_1==9
la var income_secure "Income adequate to meet hh needs 0=inadequate 1=adequate"

gen att_self_learn = q10_3_2
	la var att_self_learn "Self Efficacy: Confidence to learn new activities 1=not confident 3=v. confident"

gen optimism = .
replace optimism=0 if q10_6==1 | q10_6==2
replace optimism=1 if q10_6==3 | q10_6==4
la var optimism "Optimism 0=Pessimistic 1=Optimistic"
la define optimisml 0 "Pessimistic" 1 "Optimistic"
la values optimism optimisml

gen risk_seeking = .
replace risk_seeking=0 if q10_5==2 
replace risk_seeking=1 if q10_5==1
la var risk_seeking "Risk preference: 0=averse 1=seeking"
la define risk_seekingl 0 "Risk averse" 1 "Risk seeking"
la values risk_seeking risk_seekingl

//Generating household size
gen hh_size = 0
foreach x of numlist 1/12{
	replace hh_size = hh_size + 1 if q3_1a_`x' !=.
}
foreach x of numlist 1/12{
	gen headcount_`x'=1 if q3_1a_`x'!=.
}

	//Check to ensure hh_size is generated properly
	egen headcount_check = rowtotal(headcount_*)
	assert headcount_check == hh_size
	drop headcount_*
	
//Now mark households that have two respondents
sort Main
by Main: generate multi_hh_group = _n // numbered group
by Main: generate multi_hh = _N // total number in group

//Head of household's gender
gen hh_head_gender = .
foreach x of numlist 1/12{
	replace hh_head_gender = 0 if q3_1a_`x'==1 & q3_1c_`x'==1
	replace hh_head_gender = 1 if q3_1a_`x'==1 & q3_1c_`x'==2
}
la define hh_head_genderl 0 "Male" 1 "Female"
la values hh_head_gender hh_head_genderl
	
//Network strength variables
gen network_strength = att_discuss_farm
	la var network_strength "Network: often discusses farm issues with others 1=disagrees - 5=agrees"

gen net_strength_cell = 0
	la var net_strength_cell "Network: # of different info sources contacted using mobile"
	foreach x of numlist 1/5{
		replace net_strength_cell = net_strength_cell + 1 if (q12_3_`x'<=90)
	}

//Creating time poverty categorical & binary variable: q10_4_1, q10_4_2, q10_4_3
gen time_poverty = . //0==least time poor; 2 == most time poor
	la var time_poverty "Time poverty: 0=least time poor 1=status quo is fine 2=most time poor"
	replace time_poverty = 2 if q10_4_3==1 // (Work fewer hours daily but be able to maintain my current level of food and income)
	replace time_poverty = 0 if q10_4_2==1 // (Work a few more hours daily but have a lot more food and income)
	replace time_poverty = 1 if q10_4_1==1 // (Work the same number of hours daily but have a little more food and income)
	la define time_povertyl 0 "Least time poor" 1 "Status quo is fine" 2 "Most time poor"
	la values time_poverty time_povertyl
	
gen time_poverty_bin=.
replace time_poverty_bin=0 if (time_poverty==0 | time_poverty==1)
replace time_poverty_bin=1 if time_poverty==2
	la var time_poverty_bin "Time poverty 0=less time poor 1=more time poor"

//Rename "ladder of life" variable
gen ladder_rank=q6_5
	la var ladder_rank "Community standing ladder: 1=bottom 10=top"

// Generate large stock (cattle, donkeys, camels, pigs, sheep) vs. birds & hives variables
gen lgstock_num=0
	la var lgstock_num "Wealth: # of large livestock"
	foreach x of numlist 1/8{
		replace lgstock_num = lgstock_num + 1 if (q4_10_`x'>0 & q4_10_`x'<.)
		replace lgstock_num = lgstock_num + 1 if (q4_10_14>0 & q4_10_14<.)
		}

gen fowlbees_num=0
	la var fowlbees_num "Wealth: # of fowl & beehives"
foreach x of numlist 9/13{
	replace fowlbees_num = fowlbees_num + 1 if (q4_10_`x'>0 & q4_10_`x'<.)
	}

//Generate crop count = number of different crops reported grown for sale and/or consumption
gen crop_count=0
	la var crop_count "Risk Diversity: # of different crops sold/consumed"
foreach x of numlist 1/36{
	replace crop_count = crop_count + 1 if (q4_8_`x'>=1 & q4_8_`x'<=3)
	}

gen region=q2_2
	//REGION: combining region 24 (Kidal) with region 22 (Gao) in Mali, because region 24 has only 3 respondents
	replace region=22 if region==24

//Create the binary variables for the worldview grid att_no_advice_others (individualistic) & att_cant_avoid_misfortune
	gen b_att_no_advice_others=.
	replace b_att_no_advice_others=0 if att_no_advice_others==1 | att_no_advice_others==2
	replace b_att_no_advice_others=1 if att_no_advice_others==4 | att_no_advice_others==5
	la define b_att_noadvice_othersl 0 "Disagrees" 1 "Agrees"
	la values b_att_no_advice_others b_att_noadvice_othersl
	la var b_att_no_advice_others "Fatalistic: can't avoid misfortune if destined - BINARY"

	gen b_att_cant_avoid_misfortune=.
	replace b_att_cant_avoid_misfortune=0 if att_cant_avoid_misfortune==1 | att_cant_avoid_misfortune==2
	replace b_att_cant_avoid_misfortune=1 if att_cant_avoid_misfortune==4 | att_cant_avoid_misfortune==5
	la define b_att_cant_avoid_misfortunel 0 "Disagrees" 1 "Agrees"
	la values b_att_cant_avoid_misfortune b_att_cant_avoid_misfortunel
	la var b_att_cant_avoid_misfortune "Individualistic: dont want others to tell me what to do on farm BINARY"


***Saving .dta file with genders NOT corrected
save "$output\Farmer 1st_Jan2011_cleaned_gendersnotcorrected.dta", replace

**NOW saving .dta and SPSS file with genders corrected and same-sex households marked
**Correcting Tanzania genders
replace gender_fem=0 if inlist(res_id, 1017, 1052, 1119, 1133, 1362, 1644, 1686, 1814, 1938, 1987, 2583, 2663, 2724, 2755, 2882, 4644)
replace gender_fem=1 if inlist(res_id, 3019, 3047, 3255, 3267, 3881, 3933, 4018, 4294, 4799, 4906)

**Correcting Mali genders
replace gender_fem=0 if inlist(res_id, 5187, 5301, 5357, 5373, 5468, 5550, 5560, 6930, 6952, 7385, 7869)
replace gender_fem=1 if inlist(res_id, 6892, 6904, 6905, 7264, 7344, 7345, 8217, 8224, 8899, 8942)

gen samesex=.
replace samesex=1 if inlist(Main, 1353, 1375, 1409, 1456, 1462, 1467, 1541, 1551, 1614, 1728, 1792, 1887, 2001, 2004, 2024, 2086, 2111, 2184, 2195, 2259, 2325, 2332, 2339, 2346, 2350, 2351, 2385, 2432, 2439, 2505, 2725, 2761, 2785, 2949, 2958, 5026, 5035, 5045, 5083, 5179, 5200, 5368, 5461, 5541, 5579, 5614, 5626, 5707, 5733, 5799, 5817, 5827, 5965, 5978, 5988, 6009, 6011, 6028, 6166, 6232, 6263, 6759, 6762)

save "$output\Farmer 1st_Jan2011_cleaned_genderscorrected_samesexmarked.dta", replace


*************************************************************************************
*************************************
*  Reshape data from long to wide   *
*************************************

keep risk* att* res_id time_poverty time_poverty_bin b_att_no_advice_others b_att_cant_avoid_misfortune income_secure gender_fem multi_hh_group multi_hh country married married_monogamous hh_head_gender age Main region b_educationlevel samesex
reshape wide risk* res_id att* time_poverty income_secure age b_att_no_advice_others b_att_cant_avoid_misfortune time_poverty_bin married_monogamous married hh_head_gender gender_fem region country b_educationlevel samesex, i(Main) j(multi_hh_group)

//generating variable to identify if male/female respondent
gen malefeminhh = .
replace malefeminhh = 0 if (gender_fem1==0 & gender_fem2==0) | (gender_fem1==1 & gender_fem2==1)
replace malefeminhh = 1 if (gender_fem1==1 & gender_fem2==0) | (gender_fem1==0 & gender_fem2==1)
replace malefeminhh = 2 if (gender_fem1==. | gender_fem2==.)
la var malefeminhh "Male & female respondent in HH"
la define malefeminhhl 0 "Same sex pair" 1 "Male & female in HH" 2 "Single-headed household"

drop country2
rename country1 countryMali0

//Generate male/female vars for the following risk variables for male/female pairs (risk_work_injury risk_extreme_weather risk_community_relation risk_debt risk_lack_buyers risk_conflict)

*Creates Male/Female outcome vars for male/female households
gen married_monogamous_M = .
replace married_monogamous_M = married_monogamous1 if (gender_fem1==0 & malefeminhh==1)
replace married_monogamous_M = married_monogamous2 if (gender_fem2==0 & malefeminhh==1)
la var married_monogamous_M "Marriage status: male in male/fem HH"
la define married_monogamous_Ml 0 "polygamous" 1 "monogamous"
la values married_monogamous_M married_monogamous_Ml

gen married_monogamous_F = .
replace married_monogamous_F = married_monogamous1 if (gender_fem1==1 & malefeminhh==1)
replace married_monogamous_F = married_monogamous2 if (gender_fem2==1 & malefeminhh==1)
la var married_monogamous_F "Marriage status: female in male/fem HH"
la define married_monogamous_Fl 0 "polygamous" 1 "monogamous"
la values married_monogamous_F married_monogamous_Fl

**Creates male/male outcome vars for male/male households
gen married_monogamous_SSM1 = .
replace married_monogamous_SSM1 = married_monogamous1 if (gender_fem1==0 & malefeminhh==0)
la var married_monogamous_SSM1 "Marriage status: Same sex male 1"
la define married_monogamous_SSM1l 0 "polygamous" 1 "monogamous"
la values married_monogamous_SSM1 married_monogamous_SSM1l

gen married_monogamous_SSM2 = .
replace married_monogamous_SSM2 = married_monogamous2 if (gender_fem2==0 & malefeminhh==0)
la var married_monogamous_SSM2 "Marriage status: same sex male 2"
la define married_monogamous_SSM2l 0 "polygamous" 1 "monogamous"
la values married_monogamous_SSM2 married_monogamous_SSM2l

*Creates female/female outcome vars for female/female households
gen married_monogamous_SSF1 = .
replace married_monogamous_SSF1 = married_monogamous1 if (gender_fem1==1 & malefeminhh==0)
la var married_monogamous_SSF1 "Marriage status: same sex female 1"
la define married_monogamous_SSF1l 0 "polygamous" 1 "monogamous"
la values married_monogamous_SSF1 married_monogamous_SSF1l

gen married_monogamous_SSF2 = .
replace married_monogamous_SSF2 = married_monogamous2 if (gender_fem2==1 & malefeminhh==0)
la var married_monogamous_SSF2 "Marriage status: same sex female 2"
la define married_monogamous_SSF2l 0 "polygamous" 1 "monogamous"
la values married_monogamous_SSF2 married_monogamous_SSF2l

*Creates male or female outcome vars for single-headed (or single respondent) households
gen married_monogamous_singM1 = .
replace married_monogamous_singM1 = married_monogamous1 if (gender_fem1==0 & malefeminhh==2)
la var married_monogamous_singM1 "Marriage status: single respondent HH Male"
la define married_monogamous_singM1l 0 "polygamous" 1 "monogamous"
la values married_monogamous_singM1 married_monogamous_singM1l

gen married_monogamous_singF1 = .
replace married_monogamous_singF1 = married_monogamous1 if (gender_fem1==1 & malefeminhh==2)
la var married_monogamous_singF1 "Mariage status: single respondent HH Female"
la define married_monogamous_singF1l 0 "polygamous" 1 "monogamous"
la values married_monogamous_singF1 married_monogamous_singF1l

///

gen risk_work_injury_M = .
replace risk_work_injury_M = risk_work_injury1 if (gender_fem1==0 & malefeminhh==1)
replace risk_work_injury_M = risk_work_injury2 if (gender_fem2==0 & malefeminhh==1)
la var risk_work_injury_M "Risk work injury: male in male/fem HH"
la define risk_work_injury_Ml 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_work_injury_M risk_work_injury_Ml

gen risk_work_injury_F = .
replace risk_work_injury_F = risk_work_injury1 if (gender_fem1==1 & malefeminhh==1)
replace risk_work_injury_F = risk_work_injury2 if (gender_fem2==1 & malefeminhh==1)
la var risk_work_injury_F "Risk work injury: female in male/fem HH"
la define risk_work_injury_Fl 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_work_injury_F risk_work_injury_Fl

gen risk_work_injury_SSM1 = .
replace risk_work_injury_SSM1 = risk_work_injury1 if (gender_fem1==0 & malefeminhh==0)
la var risk_work_injury_SSM1 "Risk work injury: Same sex male 1"
la define risk_work_injury_SSM1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_work_injury_SSM1 risk_work_injury_SSM1l

gen risk_work_injury_SSM2 = .
replace risk_work_injury_SSM2 = risk_work_injury2 if (gender_fem2==0 & malefeminhh==0)
la var risk_work_injury_SSM2 "Risk work injury: same sex male 2"
la define risk_work_injury_SSM2l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_work_injury_SSM2 risk_work_injury_SSM2l

gen risk_work_injury_SSF1 = .
replace risk_work_injury_SSF1 = risk_work_injury1 if (gender_fem1==1 & malefeminhh==0)
la var risk_work_injury_SSF1 "Risk work injury: same sex female 1"
la define risk_work_injury_SSF1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_work_injury_SSF1 risk_work_injury_SSF1l

gen risk_work_injury_SSF2 = .
replace risk_work_injury_SSF2 = risk_work_injury2 if (gender_fem2==1 & malefeminhh==0)
la var risk_work_injury_SSF2 "Risk work injury: same sex female 2"
la define risk_work_injury_SSF2l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_work_injury_SSF2 risk_work_injury_SSF2l

gen risk_work_injury_singM1 = .
replace risk_work_injury_singM1 = risk_work_injury1 if (gender_fem1==0 & malefeminhh==2)
la var risk_work_injury_singM1 "Risk work injury: single respondent HH male"
la define risk_work_injury_singMl 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_work_injury_singM risk_work_injury_singMl

gen risk_work_injury_singF1 = .
replace risk_work_injury_singF1 = risk_work_injury1 if (gender_fem1==1 & malefeminhh==2)
la var risk_work_injury_singF1 "Risk work injury: single respondent HH female"
la define risk_work_injury_singFl 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_work_injury_singF risk_work_injury_singFl

///

gen risk_extreme_weather_M = .
replace risk_extreme_weather_M = risk_extreme_weather1 if (gender_fem1==0 & malefeminhh==1)
replace risk_extreme_weather_M = risk_extreme_weather2 if (gender_fem2==0 & malefeminhh==1)
la var risk_extreme_weather_M "Risk extreme weather: male in male/fem HH"
la define risk_extreme_weather_Ml 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_extreme_weather_M risk_extreme_weather_Ml

gen risk_extreme_weather_F = .
replace risk_extreme_weather_F = risk_extreme_weather1 if (gender_fem1==1 & malefeminhh==1)
replace risk_extreme_weather_F = risk_extreme_weather2 if (gender_fem2==1 & malefeminhh==1)
la var risk_extreme_weather_F "Risk extreme weather: female in male/fem HH"
la define risk_extreme_weather_Fl 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_extreme_weather_F risk_extreme_weather_Fl

gen risk_extreme_weather_SSM1 = .
replace risk_extreme_weather_SSM1 = risk_extreme_weather1 if (gender_fem1==0 & malefeminhh==0)
la var risk_extreme_weather_SSM1 "Risk extreme weather: same sex male 1"
la define risk_extreme_weather_SSM1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_extreme_weather_SSM1 risk_extreme_weather_SSM1l

gen risk_extreme_weather_SSM2 = .
replace risk_extreme_weather_SSM2 = risk_extreme_weather2 if (gender_fem2==0 & malefeminhh==0)
la var risk_extreme_weather_SSM2 "Risk extreme weather: same sex male 2"
la define risk_extreme_weather_SSM2l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_extreme_weather_SSM2 risk_extreme_weather_SSM2l

gen risk_extreme_weather_SSF1 = .
replace risk_extreme_weather_SSF1 = risk_extreme_weather1 if (gender_fem1==1 & malefeminhh==0)
la var risk_extreme_weather_SSF1 "Risk extreme weather: same sex female 1"
la define risk_extreme_weather_SSF1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_extreme_weather_SSF1 risk_extreme_weather_SSF1l

gen risk_extreme_weather_SSF2 = .
replace risk_extreme_weather_SSF2 = risk_extreme_weather2 if (gender_fem2==1 & malefeminhh==0)
la var risk_extreme_weather_SSF2 "Risk extreme weather: same sex female 2"
la define risk_extreme_weather_SSF2l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_extreme_weather_SSF2 risk_extreme_weather_SSF2l

gen risk_extreme_weather_singM1 = .
replace risk_extreme_weather_singM1 = risk_extreme_weather1 if (gender_fem1==0 & malefeminhh==2)
la var risk_extreme_weather_singM1 "Risk extreme weather: single respondent HH male"
la define risk_extreme_weather_singM1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_extreme_weather_singM1 risk_extreme_weather_singM1l

gen risk_extreme_weather_singF1 = .
replace risk_extreme_weather_singF1 = risk_extreme_weather1 if (gender_fem1==1 & malefeminhh==2)
la var risk_extreme_weather_singF1 "Risk extreme weather: single respondent HH female"
la define risk_extreme_weather_singF1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_extreme_weather_singF1 risk_extreme_weather_singF1l

///

gen risk_community_relation_M = .
replace risk_community_relation_M = risk_community_relation1 if (gender_fem1==0 & malefeminhh==1)
replace risk_community_relation_M = risk_community_relation2 if (gender_fem2==0 & malefeminhh==1)
la var risk_community_relation_M "Risk community relation: male in male/fem HH"
la define risk_community_relation_Ml 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_community_relation_M risk_community_relation_Ml

gen risk_community_relation_F = .
replace risk_community_relation_F = risk_community_relation1 if (gender_fem1==1 & malefeminhh==1)
replace risk_community_relation_F = risk_community_relation2 if (gender_fem2==1 & malefeminhh==1)
la var risk_community_relation_F "Risk community relation: female in male/fem HH"
la define risk_community_relation_Fl 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_community_relation_F risk_community_relation_Fl

gen risk_community_relation_SSM1 = .
replace risk_community_relation_SSM1 = risk_community_relation1 if (gender_fem1==0 & malefeminhh==0)
la var risk_community_relation_SSM1 "Risk community relation: same sex male 1"
la define risk_community_relation_SSM1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_community_relation_SSM1 risk_community_relation_SSM1l

gen risk_community_relation_SSM2 = .
replace risk_community_relation_SSM2 = risk_community_relation2 if (gender_fem2==0 & malefeminhh==0)
la var risk_community_relation_SSM2 "Risk community relation: same sex male 2"
la define risk_community_relation_SSM2l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_community_relation_SSM2 risk_community_relation_SSM2l

gen risk_community_relation_SSF1 = .
replace risk_community_relation_SSF1 = risk_community_relation1 if (gender_fem1==1 & malefeminhh==0)
la var risk_community_relation_SSF1 "Risk community relation: same sex female 1"
la define risk_community_relation_SSF1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_community_relation_SSF1 risk_community_relation_SSF1l

gen risk_community_relation_SSF2 = .
replace risk_community_relation_SSF2 = risk_community_relation2 if (gender_fem2==1 & malefeminhh==0)
la var risk_community_relation_SSF2 "Risk community relation: same sex female 2"
la define risk_community_relation_SSF2l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_community_relation_SSF2 risk_community_relation_SSF2l

gen risk_community_relation_singM1 = .
replace risk_community_relation_singM1 = risk_community_relation1 if (gender_fem1==0 & malefeminhh==2)
la var risk_community_relation_singM1 "Risk community relation: single respondent HH male"
la define risk_community_relation_singM1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_community_relation_singM1 risk_community_relation_singM1l

gen risk_community_relation_singF1 = .
replace risk_community_relation_singF1 = risk_community_relation1 if (gender_fem1==1 & malefeminhh==2)
la var risk_community_relation_singF1 "Risk community relation: single respondent HH female"
la define risk_community_relation_singF1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_community_relation_singF1 risk_community_relation_singF1l

///

gen risk_debt_M = .
replace risk_debt_M = risk_debt1 if (gender_fem1==0 & malefeminhh==1)
replace risk_debt_M = risk_debt2 if (gender_fem2==0 & malefeminhh==1)
la var risk_debt_M "Risk debt: male in male/fem HH"
la define risk_debt_Ml 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_debt_M risk_debt_Ml

gen risk_debt_F = .
replace risk_debt_F = risk_debt1 if (gender_fem1==1 & malefeminhh==1)
replace risk_debt_F = risk_debt2 if (gender_fem2==1 & malefeminhh==1)
la var risk_debt_F "Risk debt: female in male/fem HH"
la define risk_debt_Fl 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_debt_F risk_debt_Fl

gen risk_debt_SSM1 = .
replace risk_debt_SSM1 = risk_debt1 if (gender_fem1==0 & malefeminhh==0)
la var risk_debt_SSM1 "Risk debt: same sex male 1"
la define risk_debt_SSM1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_debt_SSM1 risk_debt_SSM1l

gen risk_debt_SSM2 = .
replace risk_debt_SSM2 = risk_debt2 if (gender_fem2==0 & malefeminhh==0)
la var risk_debt_SSM2 "Risk debt: same sex male 2"
la define risk_debt_SSM2l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_debt_SSM2 risk_debt_SSM2l

gen risk_debt_SSF1 = .
replace risk_debt_SSF1 = risk_debt1 if (gender_fem1==1 & malefeminhh==0)
la var risk_debt_SSF1 "Risk debt: same sex female 1"
la define risk_debt_SSF1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_debt_SSF1 risk_debt_SSF1l

gen risk_debt_SSF2 = .
replace risk_debt_SSF2 = risk_debt2 if (gender_fem2==1 & malefeminhh==0)
la var risk_debt_SSF2 "Risk debt: same sex female 2"
la define risk_debt_SSF2l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_debt_SSF2 risk_debt_SSF2l

gen risk_debt_singM1 = .
replace risk_debt_singM1 = risk_debt1 if (gender_fem1==0 & malefeminhh==2)
la var risk_debt_singM1 "Risk debt: single respondent HH male"
la define risk_debt_singM1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_debt_singM1 risk_debt_singM1l

gen risk_debt_singF1 = .
replace risk_debt_singF1 = risk_debt1 if (gender_fem1==1 & malefeminhh==2)
la var risk_debt_singF1 "Risk debt: single respondent HH female"
la define risk_debt_singF1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_debt_singF1 risk_debt_singF1l

///

gen risk_lack_buyers_M = .
replace risk_lack_buyers_M = risk_lack_buyers1 if (gender_fem1==0 & malefeminhh==1)
replace risk_lack_buyers_M = risk_lack_buyers2 if (gender_fem2==0 & malefeminhh==1)
la var risk_lack_buyers_M "Risk lack buyers: male in male/fem HH"
la define risk_lack_buyers_Ml 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_lack_buyers_M risk_lack_buyers_Ml

gen risk_lack_buyers_F = .
replace risk_lack_buyers_F = risk_lack_buyers1 if (gender_fem1==1 & malefeminhh==1)
replace risk_lack_buyers_F = risk_lack_buyers2 if (gender_fem2==1 & malefeminhh==1)
la var risk_lack_buyers_F "Risk lack buyers: female in male/fem HH"
la define risk_lack_buyers_Fl 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_lack_buyers_F risk_lack_buyers_Fl

gen risk_lack_buyers_SSM1 = .
replace risk_lack_buyers_SSM1 = risk_lack_buyers1 if (gender_fem1==0 & malefeminhh==0)
la var risk_lack_buyers_SSM1 "Risk lack buyers: same sex male 1"
la define risk_lack_buyers_SSM1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_lack_buyers_SSM1 risk_lack_buyers_SSM1l

gen risk_lack_buyers_SSM2 = .
replace risk_lack_buyers_SSM2 = risk_lack_buyers2 if (gender_fem2==0 & malefeminhh==0)
la var risk_lack_buyers_SSM2 "Risk lack buyers: same sex male 2"
la define risk_lack_buyers_SSM2l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_lack_buyers_SSM2 risk_lack_buyers_SSM2l

gen risk_lack_buyers_SSF1 = .
replace risk_lack_buyers_SSF1 = risk_lack_buyers1 if (gender_fem1==1 & malefeminhh==0)
la var risk_lack_buyers_SSF1 "Risk lack buyers: same sex female 1"
la define risk_lack_buyers_SSF1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_lack_buyers_SSF1 risk_lack_buyers_SSF1l

gen risk_lack_buyers_SSF2 = .
replace risk_lack_buyers_SSF2 = risk_lack_buyers2 if (gender_fem2==1 & malefeminhh==0)
la var risk_lack_buyers_SSF2 "Risk lack buyers: same sex female 2"
la define risk_lack_buyers_SSF2l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_lack_buyers_SSF2 risk_lack_buyers_SSF2l

gen risk_lack_buyers_singM1 = .
replace risk_lack_buyers_singM1 = risk_lack_buyers1 if (gender_fem1==0 & malefeminhh==2)
la var risk_lack_buyers_singM1 "Risk lack buyers: single respondent HH male"
la define risk_lack_buyers_singM1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_lack_buyers_singM1 risk_lack_buyers_singM1l

gen risk_lack_buyers_singF1 = .
replace risk_lack_buyers_singF1 = risk_lack_buyers1 if (gender_fem1==1 & malefeminhh==2)
la var risk_lack_buyers_singF1 "Risk lack buyers: single respondent HH female"
la define risk_lack_buyers_singF1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_lack_buyers_singF1 risk_lack_buyers_singF1l

///

gen risk_conflict_M = .
replace risk_conflict_M = risk_conflict1 if (gender_fem1==0 & malefeminhh==1)
replace risk_conflict_M = risk_conflict2 if (gender_fem2==0 & malefeminhh==1)
la var risk_conflict_M "Risk conflict: male in male/fem HH"
la define risk_conflict_Ml 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_conflict_M risk_conflict_Ml

gen risk_conflict_F = .
replace risk_conflict_F = risk_conflict1 if (gender_fem1==1 & malefeminhh==1)
replace risk_conflict_F = risk_conflict2 if (gender_fem2==1 & malefeminhh==1)
la var risk_conflict_F "Risk conflict: female in male/fem HH"
la define risk_conflict_Fl 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_conflict_F risk_conflict_Fl

gen risk_conflict_SSM1 = .
replace risk_conflict_SSM1 = risk_conflict1 if (gender_fem1==0 & malefeminhh==0)
la var risk_conflict_SSM1 "Risk conflict: same sex male 1"
la define risk_conflict_SSM1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_conflict_SSM1 risk_conflict_SSM1l

gen risk_conflict_SSM2 = .
replace risk_conflict_SSM2 = risk_conflict2 if (gender_fem2==0 & malefeminhh==0)
la var risk_conflict_SSM2 "Risk conflict: same sex male 2"
la define risk_conflict_SSM2l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_conflict_SSM2 risk_conflict_SSM2l

gen risk_conflict_SSF1 = .
replace risk_conflict_SSF1 = risk_conflict1 if (gender_fem1==1 & malefeminhh==0)
la var risk_conflict_SSF1 "Risk conflict: same sex female 1"
la define risk_conflict_SSF1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_conflict_SSF1 risk_conflict_SSF1l

gen risk_conflict_SSF2 = .
replace risk_conflict_SSF2 = risk_conflict2 if (gender_fem2==1 & malefeminhh==0)
la var risk_conflict_SSF2 "Risk conflict: same sex female 2"
la define risk_conflict_SSF2l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_conflict_SSF2 risk_conflict_SSF2l

gen risk_conflict_singM1 = .
replace risk_conflict_singM1 = risk_conflict1 if (gender_fem1==0 & malefeminhh==2)
la var risk_conflict_singM1 "Risk conflict: single respondent HH male"
la define risk_conflict_singM1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_conflict_singM1 risk_conflict_singM1l

gen risk_conflict_singF1 = .
replace risk_conflict_singF1 = risk_conflict1 if (gender_fem1==1 & malefeminhh==2)
la var risk_conflict_singF1 "Risk conflict: single respondent HH female"
la define risk_conflict_singF1l 1 "Not at all" 2 "Sometimes" 3 "All the time"
la values risk_conflict_singF1 risk_conflict_singF1l

///

gen time_poverty_M = .
replace time_poverty_M = time_poverty1 if (gender_fem1==0 & malefeminhh==1)
replace time_poverty_M = time_poverty2 if (gender_fem2==0 & malefeminhh==1)
la var time_poverty_M "Time poverty categorical: male in male/fem HH"
la define time_poverty_Ml 0 "least time poor" 1 "status quo is fine" 2 "most time poor"
la values time_poverty_M time_poverty_Ml

gen time_poverty_F = .
replace time_poverty_F = time_poverty1 if (gender_fem1==1 & malefeminhh==1)
replace time_poverty_F = time_poverty2 if (gender_fem2==1 & malefeminhh==1)
la var time_poverty_F "Time poverty categorical: female in male/fem HH"
la define time_poverty_Fl 0 "least time poor" 1 "status quo is fine" 2 "most time poor"
la values time_poverty_F time_poverty_Fl

gen time_poverty_SSM1 = .
replace time_poverty_SSM1 = time_poverty1 if (gender_fem1==0 & malefeminhh==0)
la var time_poverty_SSM1 "Time poverty categorical: same sex male 1"
la define time_poverty_SSM1l 0 "least time poor" 1 "status quo is fine" 2 "most time poor"
la values time_poverty_SSM1 time_poverty_SSM1l

gen time_poverty_SSM2 = .
replace time_poverty_SSM2 = time_poverty2 if (gender_fem2==0 & malefeminhh==0)
la var time_poverty_SSM2 "Time poverty categorical: same sex male 2"
la define time_poverty_SSM2l 0 "least time poor" 1 "status quo is fine" 2 "most time poor"
la values time_poverty_SSM2 time_poverty_SSM2l

gen time_poverty_SSF1 = .
replace time_poverty_SSF1 = time_poverty1 if (gender_fem1==1 & malefeminhh==0)
la var time_poverty_SSF1 "Time poverty categorical: same sex female 1"
la define time_poverty_SSF1l 0 "least time poor" 1 "status quo is fine" 2 "most time poor"
la values time_poverty_SSF1 time_poverty_SSF1l

gen time_poverty_SSF2 = .
replace time_poverty_SSF2 = time_poverty2 if (gender_fem2==1 & malefeminhh==0)
la var time_poverty_SSF2 "Time poverty categorical: same sex female 1"
la define time_poverty_SSF2l 0 "least time poor" 1 "status quo is fine" 2 "most time poor"
la values time_poverty_SSF2 time_poverty_SSF2l

gen time_poverty_singM1 = .
replace time_poverty_singM1 = time_poverty1 if (gender_fem1==0 & malefeminhh==2)
la var time_poverty_singM1 "Time poverty categorical: single respondent HH male"
la define time_poverty_singM1l 0 "least time poor" 1 "status quo is fine" 2 "most time poor"
la values time_poverty_singM1 time_poverty_singM1l

gen time_poverty_singF1 = .
replace time_poverty_singF1 = time_poverty1 if (gender_fem1==1 & malefeminhh==2)
la var time_poverty_singF1 "Time poverty categorical: single respondent HH female"
la define time_poverty_singF1l 0 "least time poor" 1 "status quo is fine" 2 "most time poor"
la values time_poverty_singF1 time_poverty_singF1l

///

gen time_poverty_bin_M = .
replace time_poverty_bin_M = time_poverty_bin1 if (gender_fem1==0 & malefeminhh==1)
replace time_poverty_bin_M = time_poverty_bin2 if (gender_fem2==0 & malefeminhh==1)
la var time_poverty_bin_M "Time poverty binary: male in male/fem HH"
la define time_poverty_bin_Ml 0 "less time poor" 1 "more time poor"
la values time_poverty_bin_M time_poverty_bin_Ml

gen time_poverty_bin_F = .
replace time_poverty_bin_F = time_poverty_bin1 if (gender_fem1==1 & malefeminhh==1)
replace time_poverty_bin_F = time_poverty_bin2 if (gender_fem2==1 & malefeminhh==1)
la var time_poverty_bin_F "Time poverty binary: female in male/fem HH"
la define time_poverty_bin_Fl 0 "less time poor" 1 "more time poor"
la values time_poverty_bin_F time_poverty_bin_Fl

gen time_poverty_bin_SSM1 = .
replace time_poverty_bin_SSM1 = time_poverty_bin1 if (gender_fem1==0 & malefeminhh==0)
la var time_poverty_bin_SSM1 "Time poverty binary: same sex male 1"
la define time_poverty_bin_SSM1l 0 "less time poor" 1 "more time poor"
la values time_poverty_bin_SSM1 time_poverty_bin_SSM1l

gen time_poverty_bin_SSM2 = .
replace time_poverty_bin_SSM2 = time_poverty_bin2 if (gender_fem2==0 & malefeminhh==0)
la var time_poverty_bin_SSM2 "Time poverty binary: same sex male 2"
la define time_poverty_bin_SSM2l 0 "less time poor" 1 "more time poor"
la values time_poverty_bin_SSM2 time_poverty_bin_SSM2l

gen time_poverty_bin_SSF1 = .
replace time_poverty_bin_SSF1 = time_poverty_bin1 if (gender_fem1==1 & malefeminhh==0)
la var time_poverty_bin_SSF1 "Time poverty binary: same sex female 1"
la define time_poverty_bin_SSF1l 0 "less time poor" 1 "more time poor"
la values time_poverty_bin_SSF1 time_poverty_bin_SSF1l

gen time_poverty_bin_SSF2 = .
replace time_poverty_bin_SSF2 = time_poverty_bin2 if (gender_fem2==1 & malefeminhh==0)
la var time_poverty_bin_SSF2 "Time poverty binary: same sex female 2"
la define time_poverty_bin_SSF2l 0 "less time poor" 1 "more time poor"
la values time_poverty_bin_SSF2 time_poverty_bin_SSF2l

gen time_poverty_bin_singM1 = .
replace time_poverty_bin_singM1 = time_poverty_bin1 if (gender_fem1==0 & malefeminhh==2)
la var time_poverty_bin_singM1 "Time poverty binary: single respondent HH male"
la define time_poverty_bin_singM1l 0 "less time poor" 1 "more time poor"
la values time_poverty_bin_singM1 time_poverty_bin_singM1l

gen time_poverty_bin_singF1 = .
replace time_poverty_bin_singF1 = time_poverty_bin1 if (gender_fem1==1 & malefeminhh==2)
la var time_poverty_bin_singF1 "Time poverty binary: single respondent HH female"
la define time_poverty_bin_singF1l 0 "less time poor" 1 "more time poor"
la values time_poverty_bin_singF1 time_poverty_bin_singF1l

///

gen income_secure_M = .
replace income_secure_M = income_secure1 if (gender_fem1==0 & malefeminhh==1)
replace income_secure_M = income_secure2 if (gender_fem2==0 & malefeminhh==1)
la var income_secure_M "Income secure: male in male/fem HH"
la define income_secure_Ml 0 "inadequate income" 1 "adequate income" 
la values income_secure_M income_secure_Ml

gen income_secure_F = .
replace income_secure_F = income_secure1 if (gender_fem1==1 & malefeminhh==1)
replace income_secure_F = income_secure2 if (gender_fem2==1 & malefeminhh==1)
la var income_secure_F "Income secure: female in male/fem HH"
la define income_secure_Fl 0 "inadequate income" 1 "adequate income" 
la values income_secure_F income_secure_Fl

gen income_secure_SSM1 = .
replace income_secure_SSM1 = income_secure1 if (gender_fem1==0 & malefeminhh==0)
la var income_secure_SSM1 "Income secure: same sex male 1"
la define income_secure_SSM1l 0 "inadequate income" 1 "adequate income" 
la values income_secure_SSM1 income_secure_SSM1l

gen income_secure_SSM2 = .
replace income_secure_SSM2 = income_secure2 if (gender_fem2==0 & malefeminhh==0)
la var income_secure_SSM2 "Income secure: same sex male 2"
la define income_secure_SSM2l 0 "inadequate income" 1 "adequate income" 
la values income_secure_SSM2 income_secure_SSM2l

gen income_secure_SSF1 = .
replace income_secure_SSF1 = income_secure1 if (gender_fem1==1 & malefeminhh==0)
la var income_secure_SSF1 "Income secure: same sex female 1"
la define income_secure_SSF1l 0 "inadequate income" 1 "adequate income" 
la values income_secure_SSF1 income_secure_SSF1l

gen income_secure_SSF2 = .
replace income_secure_SSF2 = income_secure2 if (gender_fem2==1 & malefeminhh==0)
la var income_secure_SSF2 "Income secure: same sex female 2"
la define income_secure_SSF2l 0 "inadequate income" 1 "adequate income" 
la values income_secure_SSF2 income_secure_SSF2l

gen income_secure_singM1 = .
replace income_secure_singM1 = income_secure1 if (gender_fem1==0 & malefeminhh==2)
replace income_secure_singM1 = income_secure2 if (gender_fem2==0 & malefeminhh==2)
la var income_secure_singM1 "Income secure: single respondent HH male"
la define income_secure_singM1l 0 "inadequate income" 1 "adequate income" 
la values income_secure_singM1 income_secure_singM1l

gen income_secure_singF1 = .
replace income_secure_singF1 = income_secure1 if (gender_fem1==1 & malefeminhh==2) 
replace income_secure_singF1 = income_secure2 if (gender_fem2==1 & malefeminhh==2)
la var income_secure_singF1 "Income secure: single respondent HH female"
la define income_secure_singF1l 0 "inadequate income" 1 "adequate income" 
la values income_secure_singF1 income_secure_singF1l


**new file pathways - genders corrected, same sex households marked. Preserves same sex and single-respondent households by adding new variables
save "$output\Farmer 1st_Jan2011_cleaned_genderscorrected_samesexmarked_WIDE.dta", replace 

