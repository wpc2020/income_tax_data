/* author: WPC date:2020/07/02
--------------- 說明 ---------------
1. 整理88-107各鄉鎮市區所得收入。
2. 以107年度的行政區名稱為準。
3. 2004台南市中區、西區合併為中西區。
4. 2008年1月1日，高雄縣三民鄉改名為那瑪夏鄉。
5. 88年度沒有鄉鎮市區中位數、標準差統計量。  
*/

// using log
//local d_mark : di %tcNNDDHHMM clock("$S_DATE $S_TIME", "DMYhms")
//log using "D:\wpc\log\air_`d_mark'_iv"

// 基本設定
macro drop _all
clear all
set more off
set pagesize 999
set matsize 8000
gl PATH "/home/wpc/桌面/tax_data"
gl DATA "/home/wpc/桌面/tax_data/income_tax"
gl today: di %tcNNDD clock("$S_DATE $S_TIME", "DMYhms")
gl TEMP "/home/wpc/桌面/tax_data/temp"
gl CLEAN "/home/wpc/桌面/tax_data/clean_data"

// -------------------- 處理107與鄉鎮市區模板 --------------------
clear
import delimited $DATA/income_tax_107.csv, encoding(UTF-8) 

// rename variable
rename 鄉鎮市區	town
rename 縣市	county 
rename 村里	village
rename 納稅單位	HH_num	
rename 綜合所得總額 incm_sum 
rename 平均數	incm_mean
rename 中位數	incm_med
rename 第一分位數 incm_1st
rename 第三分位數 incm_3rd
rename 標準差	incm_std
rename 變異係數	incm_cv

la var town	鄉鎮市區
la var county	縣市
la var village	村里
la var HH_num	納稅單位
la var incm_sum	綜合所得總額
la var incm_mean 綜所平均數
la var incm_med 綜所中位數
la var incm_1st 綜所第一分位數
la var incm_3rd 綜所第三分位數
la var incm_std 綜所標準差
la var incm_cv	綜所變異係數

keep if village =="合計"
drop if town == "其他"

gen len=ustrlen(town)
gen key = usubstr(county,1,2) + usubstr(town, 1, len-1)
drop len
gen year = 2018
gen county107 = county
gen town107 = town
la var county107	"2018縣市"
la var town107		"2018鄉鎮市區"
compress
save $TEMP/tax_107.dta, replace

// 製作鄉鎮市區模板
keep key county107 town107
save $TEMP/template.dta, replace

// 98-106 之間沒有行政區變動
forv i=98/106{
display "------------------------- 處理`i' -------------------------"
clear
import delimited $DATA/income_tax_`i'.csv, encoding(UTF-8)
// rename variable
rename 鄉鎮市區	town
rename 縣市	county 
rename 村里	village
rename 納稅單位	HH_num	
rename 綜合所得總額 incm_sum 
rename 平均數	incm_mean
rename 中位數	incm_med
rename 第一分位數 incm_1st
rename 第三分位數 incm_3rd
rename 標準差	incm_std
rename 變異係數	incm_cv

la var town	鄉鎮市區
la var county	縣市
la var village	村里
la var HH_num	納稅單位
la var incm_sum	綜合所得總額
la var incm_mean 綜所平均數
la var incm_med 綜所中位數
la var incm_1st 綜所第一分位數
la var incm_3rd 綜所第三分位數
la var incm_std 綜所標準差
la var incm_cv	綜所變異係數

keep if village =="合計"
drop if town == "其他"
gen len=ustrlen(town)
gen key = usubstr(county,1,2) + usubstr(town, 1, len-1)
drop len
gen year = `i' + 1911
merge 1:1 key using $TEMP/template.dta
drop _merge
compress
save $TEMP/tax_`i'.dta, replace
}

// 95-97行政區一致
forv i=95/97{
display "------------------------- 處理`i' -------------------------"
clear
import delimited $DATA/income_tax_`i'.csv, encoding(UTF-8)
// rename variable
rename 鄉鎮市區	town
rename 縣市	county 
rename 村里	village
rename 納稅單位	HH_num	
rename 綜合所得總額 incm_sum 
rename 平均數	incm_mean
rename 中位數	incm_med
rename 第一分位數 incm_1st
rename 第三分位數 incm_3rd
rename 標準差	incm_std
rename 變異係數	incm_cv

la var town	鄉鎮市區
la var county	縣市
la var village	村里
la var HH_num	納稅單位
la var incm_sum	綜合所得總額
la var incm_mean 綜所平均數
la var incm_med 綜所中位數
la var incm_1st 綜所第一分位數
la var incm_3rd 綜所第三分位數
la var incm_std 綜所標準差
la var incm_cv	綜所變異係數

keep if village =="合計"
drop if town == "其他"
gen len=ustrlen(town)
gen key = usubstr(county,1,2) + usubstr(town, 1, len-1)
replace key = "高雄那瑪夏" if county=="高雄縣" & town=="三民鄉"
replace key = "屏東霧臺" if key == "屏東霚台"
drop len
gen year = `i' + 1911
merge 1:1 key using $TEMP/template.dta
drop _merge
compress
save $TEMP/tax_`i'.dta, replace
}
// 89-94 之間沒有行政區變動(台南中區、西區尚未合併)
forv i=89/94{
display "------------------------- 處理`i' -------------------------"
clear
import delimited $DATA/income_tax_`i'.csv, encoding(UTF-8)
// rename variable
rename 鄉鎮市區	town
rename 縣市	county 
rename 村里	village
rename 納稅單位	HH_num	
rename 綜合所得總額 incm_sum 
rename 平均數	incm_mean
rename 中位數	incm_med
rename 第一分位數 incm_1st
rename 第三分位數 incm_3rd
rename 標準差	incm_std
rename 變異係數	incm_cv

la var town	鄉鎮市區
la var county	縣市
la var village	村里
la var HH_num	納稅單位
la var incm_sum	綜合所得總額
la var incm_mean 綜所平均數
la var incm_med 綜所中位數
la var incm_1st 綜所第一分位數
la var incm_3rd 綜所第三分位數
la var incm_std 綜所標準差
la var incm_cv	綜所變異係數
replace town = "枋山鄉" if town =="'枋山鄉'T"
replace town = "三地門鄉" if town =="T26"
replace town = "霚台鄉" if town=="T27"
keep if village =="合計"
drop if town == "其他"
gen len=ustrlen(town)
gen key = usubstr(county,1,2) + usubstr(town, 1, len-1)
replace key = "高雄那瑪夏" if county=="高雄縣" & town=="三民鄉"
replace key = "屏東霧臺" if key == "屏東霚台"
save $TEMP/temp.dta, replace

// 合併台南市中西區，將兩區戶數加總、、收入總額加總
keep if key == "臺南西" | key == "臺南中"
egen all_hh = sum(HH_num)
egen all_incm = sum(incm_sum)
keep all_hh all_incm
keep if _n == 1 
rename all_hh HH_num
rename all_incm incm_sum
gen town = "中西區"
gen county = "臺南市"
gen incm_mean = incm_sum/HH_num
gen key = "臺南中西"
save $TEMP/temp2.dta, replace

// 把台南中西區資料合併回去
use $TEMP/temp.dta, clear
append using $TEMP/temp2.dta
drop len
gen year = `i' + 1911
merge 1:1 key using $TEMP/template.dta
drop _merge
compress
save $TEMP/tax_`i'.dta, replace
}
// 88年度財政部只有提供各村里，沒有提供鄉鎮市區合計值
// ------------------------- 處理88 -------------------------
clear
import delimited $DATA/income_tax_88.csv, encoding(UTF-8)
// rename variable
rename 鄉鎮市區	town
rename 縣市	county 
rename 村里	village
rename 納稅單位	HH_num	
rename 綜合所得總額 incm_sum 
rename 平均數	incm_mean
rename 中位數	incm_med
rename 第一分位數 incm_1st
rename 第三分位數 incm_3rd
rename 標準差	incm_std
rename 變異係數	incm_cv

la var town	鄉鎮市區
la var county	縣市
la var village	村里
la var HH_num	納稅單位
la var incm_sum	綜合所得總額
la var incm_mean 綜所平均數
la var incm_med 綜所中位數
la var incm_1st 綜所第一分位數
la var incm_3rd 綜所第三分位數
la var incm_std 綜所標準差
la var incm_cv	綜所變異係數
replace town = "枋山鄉" if town =="'枋山鄉'T" | town =="'枋山鄉 'T"
replace town = "三地門鄉" if town =="T26"
replace town = "霚台鄉" if town=="T27"
bysort county town: egen all_hh = sum(HH_num)
bysort county town: egen all_incm = sum(incm_sum)
bysort county town: keep if _n == 1
drop HH_num incm_sum incm_mean
rename all_hh HH_num
rename all_incm incm_sum
gen incm_mean = incm_sum/HH_num
foreach var in incm_med incm_1st incm_3rd incm_std incm_cv{
replace `var' = .
}
replace village = "合計"
la var HH_num	納稅單位
la var incm_sum	綜合所得總額
la var incm_mean 綜所平均數
drop if town == "其他"
// 當初爬資料時88年度沒有改成新北市
replace county = "新北市" if county == "臺北縣"
gen len=ustrlen(town)
gen key = usubstr(county,1,2) + usubstr(town, 1, len-1)
replace key = "高雄那瑪夏" if county=="高雄縣" & town=="三民鄉"
replace key = "屏東霧臺" if key == "屏東霚台"
save $TEMP/temp.dta, replace

// 合併台南市中西區，將兩區戶數加總、、收入總額加總
keep if key == "臺南西" | key == "臺南中"
egen all_hh = sum(HH_num)
egen all_incm = sum(incm_sum)
keep all_hh all_incm
keep if _n == 1 
rename all_hh HH_num
rename all_incm incm_sum
gen town = "中西區"
gen county = "臺南市"
gen incm_mean = incm_sum/HH_num
gen key = "臺南中西"
save $TEMP/temp2.dta, replace

// 把台南中西區資料合併回去
use $TEMP/temp.dta, clear
append using $TEMP/temp2.dta
drop len
gen year = 1999
merge 1:1 key using $TEMP/template.dta
drop _merge
compress
save $TEMP/tax_88.dta, replace

// ------------------------- 合併88-107年資料 -------------------------
clear
forv i = 88/107{
append using $TEMP/tax_`i'.dta
}
drop village
la var year "年度"
gen county_town = county107 + town107
compress
order year county_town HH_num incm_sum incm_mean
save $CLEAN/income_tax_88_107.dta, replace
