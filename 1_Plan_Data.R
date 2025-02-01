#########################################################################
## Read in enrollment data for january of each year
#########################################################################

library(tidyverse)
library(dplyr)


## Basic contract/plan information
contract.info <- read_csv("C:/Users/mirac/Documents/GitHub/econ470_ma/hw1/data/CPSC_Contract_Info_2015_12.csv",
                          skip=1,
                          col_names = c("contractid","planid","org_type","plan_type",
                                        "partd","snp","eghp","org_name","org_marketing_name",
                                        "plan_name","parent_org","contract_date"),
                          col_types = cols(
                            contractid = col_character(),
                            planid = col_double(),
                            org_type = col_character(),
                            plan_type = col_character(),
                            partd = col_character(),
                            snp = col_character(),
                            eghp = col_character(),
                            org_name = col_character(),
                            org_marketing_name = col_character(),
                            plan_name = col_character(),
                            parent_org = col_character(),
                            contract_date = col_character()
                          ))

#only picking id count equal to one so were not including duplicate plans
contract.info <- contract.info %>%
  group_by(contractid, planid) %>%
  mutate(id_count=row_number()) %>%
  filter(id_count==1) %>%
  select(-id_count)


## Enrollments per plan
enroll.info <- read_csv("C:/Users/mirac/Documents/GitHub/econ470_ma/hw1/data/CPSC_Enrollment_Info_2015_12.csv",
                        skip=1,
                        col_names = c("contractid","planid","ssa","fips","state","county","enrollment"),
                        col_types = cols(
                          contractid = col_character(),
                          planid = col_double(),
                          ssa = col_double(),
                          fips = col_double(),
                          state = col_character(),
                          county = col_character(),
                          enrollment = col_double()
                        ),na="*")    

## Merge contract info with enrollment info
plan.data <- contract.info %>%
  left_join(enroll.info, by=c("contractid", "planid")) %>%
  mutate(year=2015) %>%
  group_by(state, county) %>%
  fill(fips) %>%
  group_by(contractid, planid) %>%
  fill(plan_type, partd, snp, eghp, plan_name) %>%
  group_by(contractid) %>%
  fill(org_type,org_name,org_marketing_name,parent_org)

write_rds(plan.data,"C:/Users/mirac/Documents/GitHub/econ470_ma/hw1/data/ma_data_2015.rds")

