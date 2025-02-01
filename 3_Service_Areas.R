##############################################################################
## Read in service area data */
##############################################################################


## Read in monthly files, append to yearly file, fill in missing info, and collapse down to yearly file
service.area <- read_csv("C:/Users/mirac/Documents/GitHub/econ470_ma/hw1/data/MA_Cnty_SA_2015_12.csv",skip=1,
                         col_names=c("contractid","org_name","org_type","plan_type","partial","eghp",
                                     "ssa","fips","county","state","notes"),
                         col_types = cols(
                           contractid = col_character(),
                           org_name = col_character(),
                           org_type = col_character(),
                           plan_type = col_character(),
                           partial = col_logical(),
                           eghp = col_character(),
                           ssa = col_double(),
                           fips = col_double(),
                           county = col_character(),
                           notes = col_character()
                         ), na='*')
tlmgr install koma-script

service.year <- service.area %>%
  mutate(year=2015) %>%
  group_by(state, county) %>%
  fill(fips) %>%
  group_by(contractid) %>%
  fill(plan_type, partial, eghp, org_type, org_name)

service.year <- service.year %>%
  group_by(contractid, fips) %>%
  mutate(id_count=row_number()) %>%
  filter(id_count==1) %>%
  select(-c(id_count))

write_rds(service.area,"C:/Users/mirac/Documents/GitHub/econ470_ma/hw1/data/contract_service_area.rds")