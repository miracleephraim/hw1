
full.ma.data <- readRDS("homework1/data/ma_data_2015.rds")
contract.service.area <- readRDS("homework1/data/3_Service_Areas - Copy.R")

plan.type.table <- full.ma.data %>%
    group_by(plan_type) %>% 
    count() %>%
    arrange(-n)

tot.obs <- as.numeric(count(full.ma.data %>% ungroup()))
plan.type.year1 <- full.ma.data %>% 
group_by(plan_type) %>% 
arrange(-n) %>% 
filter(plan_type!="NA")

final.plans <- full.ma.data %>%
filter(snp== "No" & eghp == "No" &
(planid < 800 | planid >= 900))
plan.type.year2 <- final.plans %>%
group_by(plan_type) %>% 
count() %>%
arrange(-n)

plan.type.enroll <- final.plans %>%
group_by(plan_type) %>%
summarize(n=n(), enrollment=mean(enrollment, na.rm=TRUE)) %>% a

final.data <- final.plans %>%
inner_join(contract.service.area %>%
    select(contractid, fips, year)) %>%
    by=c("contractid", "fips", "year") %>%
    filter(!is.na(enrollment))

#dropping super large datasets and just keeping the tables we produced
rm(list=c("full.ma.data", "contract.service.area", "final.data"))
save.image("homework1/submission1/hw1_workspace.Rdata")