//Regression Selection Farmer First dataset for EPAR Request 340: Farmer Focus Gender Attitudes
//Author: Audrey Lawrence
//Updates: Melissa Greenaway (MLG)
//Cleaned: Daniel Lunchick-Seymour 10/16/17

********************************************************************************
clear
**set directories
global input "R:\Project\EPAR\Archive\340 - Farmer First Gender Attitudes\Analysis\9.22.16 FINAL Analysis\Cleaned do files (Daniel Oct 2017)\Cleaned Analysis Output\Farmer 1st_Jan2011_cleaned_genderscorrected_samesexmarked.dta"
global output "R:\Project\EPAR\Archive\340 - Farmer First Gender Attitudes\Analysis\9.22.16 FINAL Analysis\Cleaned do files (Daniel Oct 2017)\Cleaned Regression Output"

****Run Categorical OLS Regressions****

use "$input

**Drop 63 same-sex households in both Tanzania & Mali
drop if inlist(Main, 1353, 1375, 1409, 1456, 1462, 1467, 1541, 1551, 1614, 1728, 1792, 1887, 2001, 2004, 2024, 2086, 2111, 2184, 2195, 2259, 2325, 2332, 2339, 2346, 2350, 2351, 2385, 2432, 2439, 2505, 2725, 2761, 2785, 2949, 2958, 5026, 5035, 5045, 5083, 5179, 5200, 5368, 5461, 5541, 5579, 5614, 5626, 5707, 5733, 5799, 5817, 5827, 5965, 5978, 5988, 6009, 6011, 6028, 6166, 6232, 6263, 6759, 6762)


**Relabel vars for regression
	la var age "Age (years)"
	la var num_children_u15 "Children under 15"
	la var all_plots_acres "Household's acres (owned & rented)"
	la var lgstock_num "# large livestock"
	la var fowlbees_num "# fowl & beehives"
	la var crop_count "# of different crops sold/consumed"
	la var risk_work_injury "Risk: work injury"
	la var risk_extreme_weather "Risk: extreme weather"
	la var risk_community_relation "Risk: community relations"
	la var risk_debt "Risk: debt"
	la var risk_lack_buyers "Risk: lack of buyers"
	la var risk_conflict "Risk: conflict"
	la var gender_fem "Sex (Male=0; Female=1)"
	la var income_secure "Income secure (0=inadequate income; 1=adequate income)"
	la var time_poverty_bin "Time poverty (0=less time poor; 1=more time poor)"
	la var q1_5 "Level of Education achieved (1=none to 7=Madrassa)"
	la var health "Self-health assessment (1=Very poor to 5=Very good)"
	la var att_tell_others "Social: Like to tell others about new farm methods (1=disagree to 5=agree)"
	la var att_cant_avoid_misfortune "Fatalistic: Can't avoid misfortune (1=disagrees completely-5=agrees completely)"
	la var att_no_advice_others "Individualistic: Doesn't want farm advice fr others (1=disagrees completely-5 agrees completely)"
	la var optimism "Optimism (0=pessimistic; 1=optimistic)"
	la var ladder_rank "Community standing ladder (1=bottom 10=top)"
	la var risk_seeking "Risk preference (0=averse 1=seeking)"
	la var att_self_learn "Self-efficacy: Confidence to learn new activities (1=not confident to 3=very confident)"
	la var network_strength "Social: often discusses farm issues with others (1=disagrees completely to 5=agrees completely)"
	la var net_strength_cell "Network: # of different info sources contacted using mobile"
	
*Generating time poverty relative variable
replace q10_4_3=. if q10_4_3==9
replace q10_4_2=. if q10_4_2==9
replace q10_4_1=. if q10_4_1==9 // recoding a random 9

gen timepoverty_rel=.
replace timepoverty_rel = 1 if (q10_4_3 < q10_4_2) // ranked time poor (q10_4_3) more than income poor (q10_4_2) (1<3)
replace timepoverty_rel = 0 if (q10_4_2 < q10_4_3) // ranked income poor (q10_4_2) more than time poor (q10_4_3) (1<3)
	la var timepoverty_rel "Time poverty variable, relative ranking of time vs. income poverty"
	la define timepovertyrel 0 "Prefers income to time" 1 "Prefers time to income"
	la values timepoverty_rel timepovertyrel
	
*Binary network strength variable
gen b_cell_network=.
replace b_cell_network=1 if net_strength_cell > 0
replace b_cell_network=0 if net_strength_cell == 0
	la var b_cell_network "Cell Network Binary, 0=No Sources 1=1 or More Sources"
	la define b_cell_network1 0 "No Sources" 1 "1 or More Sources"
	la values b_cell_network b_cell_network1
	
//Adding labels to region variable
label define region1 1 "Dar es Salaam" 2 "Dodoma" 3 "Morogoro" 4 "Singida" 5 "Tabora" 6 "Pwani" 7 "Tanga" 8 "Kagera" 9 "Mara" 10 "Mwanza" 11 "Arusha" 12 "Kilimanjaro" 13 "Manyara" ///
	14 "Shinyanga" 15 "Iringa" 16 "Lindi" 17 "Mbeya" 18 "Ruvuma" 19 "Mtwara" 20 "Kigoma" 21 "Rukwa" 22 "Gao" 23 "Kayes" 24 "Kidal" 25 "Koulikoro" 26 "Mopti" 27 "Segou" 28 "Sikasso" ///
	29 "Tomboctou" 30 "Bamako"
	la values region region1

*Drop mislabeled observations (Mali with Tanzanian region), relabel Kidal as Gao (only 3 respondents in Kidal)
drop if country==0 & region==2
replace region=22 if region==24 & country==0

*Drop Tanzania observations to save as Mali dataset
drop if country==1

//Regression Series 1: with relative time poverty variable 
eststo work_injury3: xi: regress risk_work_injury gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0
eststo extreme_weather3: xi: regress risk_extreme_weather gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0
eststo community_relation3: xi: regress risk_community_relation gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0
eststo debt3: xi: regress risk_debt gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0
eststo lack_buyers3: xi: regress risk_lack_buyers gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0
eststo conflict3: xi: regress risk_conflict gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0
	
	esttab work_injury3 extreme_weather3 community_relation3 debt3 lack_buyers3 conflict3 using Regression_timepovertyrel.rtf, replace ///
	label mtitles("Work injury" "Extreme weather" "Community relation" "Debt" "Lack of buyers" "Conflict") ///
	se(%12.3f) b(%12.3f) ar2 onecell star(* 0.1 ** 0.01 *** 0.001)
	
*Running same regressions without Gao
eststo work_injury_nogao: xi: regress risk_work_injury gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if (country==0 & region != 22)
eststo extreme_weather_nogao: xi: regress risk_extreme_weather gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if (country==0 & region != 22)
eststo community_relation_nogao: xi: regress risk_community_relation gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if (country==0 & region != 22)
eststo debt_nogao: xi: regress risk_debt gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if (country==0 & region != 22)
eststo lack_buyers_nogao: xi: regress risk_lack_buyers gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if (country==0 & region != 22)
eststo conflict_nogao: xi: regress risk_conflict gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if (country==0 & region != 22)

	esttab work_injury_nogao extreme_weather_nogao community_relation_nogao debt_nogao lack_buyers_nogao conflict_nogao using Regression_timepovertyrel_nogao.rtf, replace ///
	label mtitles("Work injury" "Extreme weather" "Community relation" "Debt" "Lack of buyers" "Conflict") ///
	se(%12.3f) b(%12.3f) ar2 onecell star(* 0.1 ** 0.01 *** 0.001)
	
//Regression Series 2: with regions added
	*Running regressions with and without Gao, using Segou as the reference region

*WITH GAO
eststo work_injury4: xi: regress risk_work_injury gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count ib27.region if country==0
eststo extreme_weather4: xi: regress risk_extreme_weather gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count ib27.region if country==0
eststo community_relation4: xi: regress risk_community_relation gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count ib27.region if country==0
eststo debt4: xi: regress risk_debt gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count ib27.region if country==0
eststo lack_buyers4: xi: regress risk_lack_buyers gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count ib27.region if country==0
eststo conflict4: xi: regress risk_conflict gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count ib27.region if country==0

	esttab work_injury4 extreme_weather4 community_relation4 debt4 lack_buyers4 conflict4 using Regression_timepovertyrel_region.rtf, replace ///
	label mtitles("Work injury" "Extreme weather" "Community relation" "Debt" "Lack of buyers" "Conflict") ///
	se(%12.3f) b(%12.3f) ar2 onecell star(* 0.1 ** 0.01 *** 0.001)

*WITHOUT GAO
eststo work_injury5: xi: regress risk_work_injury gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count ib27.region if (country==0 & region != 22)
eststo extreme_weather5: xi: regress risk_extreme_weather gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count ib27.region if (country==0 & region != 22)
eststo community_relation5: xi: regress risk_community_relation gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count ib27.region if (country==0 & region != 22)
eststo debt5: xi: regress risk_debt gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count ib27.region if (country==0 & region != 22)
eststo lack_buyers5: xi: regress risk_lack_buyers gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count ib27.region if (country==0 & region != 22)
eststo conflict5: xi: regress risk_conflict gender_fem age num_children_u15 income_secure timepoverty_rel b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count ib27.region if (country==0 & region != 22)

	esttab work_injury5 extreme_weather5 community_relation5 debt5 lack_buyers5 conflict5 using Regression_timepovertyrel_region_nogao.rtf, replace ///
	label mtitles("Work injury" "Extreme weather" "Community relation" "Debt" "Lack of buyers" "Conflict") ///
	se(%12.3f) b(%12.3f) ar2 onecell star(* 0.1 ** 0.01 *** 0.001)
	
//Regression Series 3: with genders corrected, same-sex households DROPPED, and NO community ladder rank variable
	*Risk Model regressions for output - categorical WITH Worldview
eststo work_injury: xi: regress risk_work_injury gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength  net_strength_cell lgstock_num fowlbees_num crop_count if country==0
eststo extreme_weather: xi: regress risk_extreme_weather gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0
eststo community_relation: xi: regress risk_community_relation gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0
eststo debt: xi: regress risk_debt gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0
eststo lack_buyers: xi: regress risk_lack_buyers gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0
eststo conflict: xi: regress risk_conflict gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0
	
	esttab work_injury extreme_weather community_relation debt lack_buyers conflict using Regression4_OLDdata_.rtf, replace ///
	label mtitles("Work injury" "Extreme weather" "Community relation" "Debt" "Lack of buyers" "Conflict") ///
	se(%12.3f) b(%12.3f) ar2 onecell star(* 0.1 ** 0.01 *** 0.001)

	esttab work_injury extreme_weather community_relation debt lack_buyers conflict using Regression4_OLDdata_newsig.rtf, replace ///
	label mtitles("Work injury" "Extreme weather" "Community relation" "Debt" "Lack of buyers" "Conflict") ///
	star(* 0.10 ** 0.01 *** 0.001) se(4) b(3) ar2 onecell

//Regression Series 4: same as series 3, adding in polygamy/monogamy variable
	*Risk Model regressions for output - categorical WITH Worldview
eststo work_injury2: xi: regress risk_work_injury gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength  net_strength_cell lgstock_num fowlbees_num crop_count married_monogamous if country==0
eststo extreme_weather2: xi: regress risk_extreme_weather gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count married_monogamous if country==0
eststo community_relation2: xi: regress risk_community_relation gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count married_monogamous if country==0
eststo debt2: xi: regress risk_debt gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count married_monogamous if country==0
eststo lack_buyers2: xi: regress risk_lack_buyers gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count married_monogamous if country==0
eststo conflict2: xi: regress risk_conflict gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count married_monogamous if country==0
	
	esttab work_injury2 extreme_weather2 community_relation2 debt2 lack_buyers2 conflict2 using Regression4_marriagestatus_OLDdata_.rtf, replace ///
	label mtitles("Work injury" "Extreme weather" "Community relation" "Debt" "Lack of buyers" "Conflict") ///
	se(%12.3f) b(%12.3f) ar2 onecell star(* 0.1 ** 0.01 *** 0.001)
	
//Regression Series 5: with interaction terms:
	*1. Gender and Network
	*2. Gender and ChildrenU15

*Gender and Network
eststo work_injury_gnet: xi: regress risk_work_injury gender_fem##c.net_strength_cell age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength lgstock_num fowlbees_num crop_count if country==0
eststo extreme_weather_gnet: xi: regress risk_extreme_weather gender_fem##c.net_strength_cell age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength lgstock_num fowlbees_num crop_count if country==0
eststo community_relation_gnet: xi: regress risk_community_relation gender_fem##c.net_strength_cell age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength lgstock_num fowlbees_num crop_count if country==0
eststo debt_gnet: xi: regress risk_debt gender_fem##c.net_strength_cell age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength lgstock_num fowlbees_num crop_count if country==0
eststo lack_buyers_gnet: xi: regress risk_lack_buyers gender_fem##c.net_strength_cell age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength lgstock_num fowlbees_num crop_count if country==0
eststo conflict_gnet: xi: regress risk_conflict gender_fem##c.net_strength_cell age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength lgstock_num fowlbees_num crop_count if country==0

	esttab work_injury_gnet extreme_weather_gnet community_relation_gnet debt_gnet lack_buyers_gnet conflict_gnet using Regression4_OLDdata_gendernet.rtf, replace ///
	label mtitles("Work injury" "Extreme weather" "Community relation" "Debt" "Lack of buyers" "Conflict") ///
	star(* 0.10 ** 0.01 *** 0.001) se(4) b(3) ar2 onecell
	
*Gender and ChildrenU15
eststo work_injury_gchild: xi: regress risk_work_injury gender_fem##c.num_children_u15 age net_strength_cell income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength lgstock_num fowlbees_num crop_count if country==0
eststo extreme_weather_gchild: xi: regress risk_extreme_weather gender_fem##c.num_children_u15 age net_strength_cell income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength lgstock_num fowlbees_num crop_count if country==0
eststo community_relation_gchild: xi: regress risk_community_relation gender_fem##c.num_children_u15 age net_strength_cell income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength lgstock_num fowlbees_num crop_count if country==0
eststo debt_gchild: xi: regress risk_debt gender_fem##c.num_children_u15 age net_strength_cell income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength lgstock_num fowlbees_num crop_count if country==0
eststo lack_buyers_gchild: xi: regress risk_lack_buyers gender_fem##c.num_children_u15 age net_strength_cell income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength lgstock_num fowlbees_num crop_count if country==0
eststo conflict_gchild: xi: regress risk_conflict gender_fem##c.num_children_u15 age net_strength_cell income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength lgstock_num fowlbees_num crop_count if country==0

	esttab work_injury_gchild extreme_weather_gchild community_relation_gchild debt_gchild lack_buyers_gchild conflict_gchild using Regression4_OLDdata_genderchildren.rtf, replace ///
	label mtitles("Work injury" "Extreme weather" "Community relation" "Debt" "Lack of buyers" "Conflict") ///
	star(* 0.10 ** 0.01 *** 0.001) se(4) b(3) ar2 onecell	
	
//Regression Series 6: Binary OLS - without ladder rank
	*Risk Model regressions for output - categorical WITH Worldview (0=doesn't worry; 1=sometimes worries or worries all the time)
eststo work_injury: xi: regress b_risk_work_injury gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength  net_strength_cell lgstock_num fowlbees_num crop_count if country==0
eststo extreme_weather: xi: regress b_risk_extreme_weather gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0
eststo community_relation: xi: regress b_risk_community_relation gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0
eststo debt: xi: regress b_risk_debt gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0
eststo lack_buyers: xi: regress b_risk_lack_buyers gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0
eststo conflict: xi: regress b_risk_conflict gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0
	
	esttab work_injury extreme_weather community_relation debt lack_buyers conflict using BinaryOLS_OLDdata_NOladderrank.rtf, replace ///
	label mtitles("Work injury" "Extreme weather" "Community relation" "Debt" "Lack of buyers" "Conflict") ///
	se(4) b(4) ar2 onecell
	
//Logit Regression Series
	*Risk Model regressions for output - binary WITH Worldview - no ladder rank
eststo work_injury: logit b_risk_work_injury gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength  net_strength_cell lgstock_num fowlbees_num crop_count if country==0, or
eststo extreme_weather: logit b_risk_extreme_weather gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0, or
eststo community_relation: logit b_risk_community_relation gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0, or
eststo debt: logit b_risk_debt gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0, or
eststo lack_buyers: logit b_risk_lack_buyers gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0, or
eststo conflict: logit b_risk_conflict gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0, or
	
	esttab work_injury extreme_weather community_relation debt lack_buyers conflict using LOGIT_OLDdata_NOladderrank_marginaleffects.rtf, replace ///
	label nonumbers mtitles("Work injury" "Extreme weather" "Community relation" "Debt" "Lack of buyers" "Conflict") ///
	eform se(4) pr2 onecell
	pr2 ar2 onecell
	
*Regression sample summary statistics for crops grown, ethnicity, income type
*using the regression for "Community Relations" because it has the largest number of observations (out of the six risk domains)
*must run regression first to get e(sample) to work

eststo community_relation: xi: regress risk_community_relation gender_fem age num_children_u15 income_secure time_poverty_bin b_educationlevel health ///
	att_tell_others att_cant_avoid_misfortune att_no_advice_others optimism risk_seeking att_self_learn network_strength net_strength_cell lgstock_num fowlbees_num crop_count if country==0

tab crop_count if e(sample)==1 // number of crops grown
tab1 q4_7a_1-q4_7a_20 if e(sample)==1 // types of crops grown
tab q1_7 if e(sample)==1
tab1 q5_2_1-q5_2_8 if e(sample)==1 // for each source of income, how many people ranked it as their first, second, or third source
	
************************************Descriptives for Mali set***********************

tab gender_fem if country==0 
sum age if country==0 
	sum age if country==0 & gender_fem==0 
	sum age if country==0 & gender_fem==1 
sum num_children_u15 if country==0 & samesex!=1
	sum num_children_u15 if country==0 & gender_fem==0 
	sum num_children_u15 if country==0 & gender_fem==1 
tab income_secure if country==0
	tab income_secure if country==0 & gender_fem==0
	tab income_secure if country==0 & gender_fem==1
tab timepoverty_rel if country==0 
	tab timepoverty_rel if country==0 & gender_fem==0 
	tab timepoverty_rel if country==0 & gender_fem==1 
tab b_educationlevel if country==0 
	tab b_educationlevel if country==0 & gender_fem==0 
	tab b_educationlevel if country==0 & gender_fem==1 
tab health if country==0 
	tab health if country==0 & gender_fem==0 
	tab health if country==0 & gender_fem==1 
tab att_tell_others if country==0 
	tab att_tell_others if country==0 & gender_fem==0 
	tab att_tell_others if country==0 & gender_fem==1 
tab att_cant_avoid_misfortune if country==0
	tab att_cant_avoid_misfortune if country==0 & gender_fem==0
	tab att_cant_avoid_misfortune if country==0 & gender_fem==1
tab att_no_advice_others if country==0
	tab att_no_advice_others if country==0 & gender_fem==0
	tab att_no_advice_others if country==0 & gender_fem==1
tab optimism if country==0
	tab optimism if country==0 & gender_fem==0
	tab optimism if country==0 & gender_fem==1
tab risk_seeking if country==0 
	tab risk_seeking if country==0 & gender_fem==0
	tab risk_seeking if country==0 & gender_fem==1
tab att_self_learn if country==0 
	tab att_self_learn if country==0 & gender_fem==0
	tab att_self_learn if country==0 & gender_fem==1
tab network_strength if country==0
	tab network_strength if country==0 & gender_fem==0
	tab network_strength if country==0 & gender_fem==1
tab net_strength_cell if country==0 
	tab net_strength_cell if country==0 & gender_fem==0
	tab net_strength_cell if country==0 & gender_fem==1
sum lgstock_num if country==0
	sum lgstock_num if country==0 & gender_fem==0
	sum lgstock_num if country==0 & gender_fem==1
sum fowlbees_num if country==0 
	sum fowlbees_num if country==0 & gender_fem==0
	sum fowlbees_num if country==0 & gender_fem==1
sum crop_count if country==0
	sum crop_count if country==0 & gender_fem==0
	sum crop_count if country==0 & gender_fem==1

tab risk_work_injury if country==0
	tab risk_work_injury if country==0 & gender_fem==0
	tab risk_work_injury if country==0 & gender_fem==1
tab risk_extreme_weather if country==0
	tab risk_extreme_weather if country==0 & gender_fem==0
	tab risk_extreme_weather if country==0 & gender_fem==1
tab risk_community_relation if country==0
	tab risk_community_relation if country==0 & gender_fem==0
	tab risk_community_relation if country==0 & gender_fem==1
tab risk_debt if country==0
	tab risk_debt if country==0 & gender_fem==0
	tab risk_debt if country==0 & gender_fem==1
tab risk_lack_buyers if country==0
	tab risk_lack_buyers if country==0 & gender_fem==0
	tab risk_lack_buyers if country==0 & gender_fem==1
tab risk_conflict if country==0
	tab risk_conflict if country==0 & gender_fem==0
	tab risk_conflict if country==0 & gender_fem==1

*Summary Statistics Excluding Gao - drop region 22
drop if region==22
tab gender_fem if country==0 
sum age if country==0 
	sum age if country==0 & gender_fem==0 
	sum age if country==0 & gender_fem==1 
sum num_children_u15 if country==0 & samesex!=1
	sum num_children_u15 if country==0 & gender_fem==0 
	sum num_children_u15 if country==0 & gender_fem==1 
tab income_secure if country==0
	tab income_secure if country==0 & gender_fem==0
	tab income_secure if country==0 & gender_fem==1
tab timepoverty_rel if country==0 
	tab timepoverty_rel if country==0 & gender_fem==0 
	tab timepoverty_rel if country==0 & gender_fem==1 
tab b_educationlevel if country==0 
	tab b_educationlevel if country==0 & gender_fem==0 
	tab b_educationlevel if country==0 & gender_fem==1 
tab health if country==0 
	tab health if country==0 & gender_fem==0 
	tab health if country==0 & gender_fem==1 
tab att_tell_others if country==0 
	tab att_tell_others if country==0 & gender_fem==0 
	tab att_tell_others if country==0 & gender_fem==1 
tab att_cant_avoid_misfortune if country==0
	tab att_cant_avoid_misfortune if country==0 & gender_fem==0
	tab att_cant_avoid_misfortune if country==0 & gender_fem==1
tab att_no_advice_others if country==0
	tab att_no_advice_others if country==0 & gender_fem==0
	tab att_no_advice_others if country==0 & gender_fem==1
tab optimism if country==0
	tab optimism if country==0 & gender_fem==0
	tab optimism if country==0 & gender_fem==1
tab risk_seeking if country==0 
	tab risk_seeking if country==0 & gender_fem==0
	tab risk_seeking if country==0 & gender_fem==1
tab att_self_learn if country==0 
	tab att_self_learn if country==0 & gender_fem==0
	tab att_self_learn if country==0 & gender_fem==1
tab network_strength if country==0
	tab network_strength if country==0 & gender_fem==0
	tab network_strength if country==0 & gender_fem==1
tab net_strength_cell if country==0 
	tab net_strength_cell if country==0 & gender_fem==0
	tab net_strength_cell if country==0 & gender_fem==1
sum lgstock_num if country==0
	sum lgstock_num if country==0 & gender_fem==0
	sum lgstock_num if country==0 & gender_fem==1
sum fowlbees_num if country==0 
	sum fowlbees_num if country==0 & gender_fem==0
	sum fowlbees_num if country==0 & gender_fem==1
sum crop_count if country==0
	sum crop_count if country==0 & gender_fem==0
	sum crop_count if country==0 & gender_fem==1

tab risk_work_injury if country==0
	tab risk_work_injury if country==0 & gender_fem==0
	tab risk_work_injury if country==0 & gender_fem==1
tab risk_extreme_weather if country==0
	tab risk_extreme_weather if country==0 & gender_fem==0
	tab risk_extreme_weather if country==0 & gender_fem==1
tab risk_community_relation if country==0
	tab risk_community_relation if country==0 & gender_fem==0
	tab risk_community_relation if country==0 & gender_fem==1
tab risk_debt if country==0
	tab risk_debt if country==0 & gender_fem==0
	tab risk_debt if country==0 & gender_fem==1
tab risk_lack_buyers if country==0
	tab risk_lack_buyers if country==0 & gender_fem==0
	tab risk_lack_buyers if country==0 & gender_fem==1
tab risk_conflict if country==0
	tab risk_conflict if country==0 & gender_fem==0
	tab risk_conflict if country==0 & gender_fem==1
	
***Additional outcome answers by gender excluding samesex***
tab risk_work_injury gender_fem if country==0 & samesex!=1, col
tab risk_extreme_weather gender_fem if country==0 & samesex!=1, col
tab risk_community_relation gender_fem if country==0 & samesex!=1, col
tab risk_debt gender_fem if country==0 & samesex!=1, col
tab risk_lack_buyers gender_fem if country==0 & samesex!=1, col
tab risk_conflict gender_fem if country==0 & samesex!=1, col

***Average responses by gender to selected risk outcomes
sum risk_work_injury if country==0 & gender_fem==0
sum risk_work_injury if country==0 & gender_fem==1

sum risk_extreme_weather if country==0 & gender_fem==0
sum risk_extreme_weather if country==0 & gender_fem==1

sum risk_community_relation if country==0 & gender_fem==0
sum risk_community_relation if country==0 & gender_fem==1

sum risk_debt if country==0 & gender_fem==0
sum risk_debt if country==0 & gender_fem==1

sum risk_lack_buyers if country==0 & gender_fem==0
sum risk_lack_buyers if country==0 & gender_fem==1

sum risk_conflict if country==0 & gender_fem==0
sum risk_conflict if country==0 & gender_fem==1 

	
