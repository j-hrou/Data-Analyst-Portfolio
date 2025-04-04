#descriptive stats
sapply(SL_SUR_All_Beaches, range, na.rm=TRUE)

#standard error 
sd(SL_SUR_All_Beaches$weight_m3, na.rm=TRUE) /  
  sqrt(length(SL_SUR_All_Beaches$weight_m3[!is.na(SL_SUR_All_Beaches$weight_m3)])) 


library(plyr)

#barplot of TNL surface means of all beaches
sample <- factor(TNL_SUR_All_Beaches$sample)
means <- ddply(TNL_SUR_All_Beaches, c("sample"), summarise,
               mean=mean(total_plastic_m3))
means.barplot <- ggplot(data=means, mapping=aes(x=sample, y=mean))+
geom_bar(position=position_dodge(), stat="identity")
means.barplot

#mean dataset by sample
TNL_DEP_means_se_weight <- TNL_DEP_All_Beaches %>% 
  group_by(sample) %>% # Group the data by manufacturer
  dplyr::summarise(mean_weight=mean(weight_m3),# Create variable with mean of cty per group
            sd_plastic=sd(weight_m3), # Create variable with sd of cty per group
            N_plastic=n(), # Create new variable N of cty per group
            se=sd_plastic/sqrt(N_plastic), # Create variable with se of cty per group
            upper_limit=mean_weight+se, # Upper limit
            lower_limit=mean_weight-se) # Lower limit

#mean dataset by region
TNL_means_se_region_weight <- TNL_SUR_All_Beaches %>% 
  group_by(Region) %>% # Group the data by manufacturer
  dplyr::summarise(mean_weight=mean(weight_m3), # Create variable with mean of cty per group
                   sd_plastic=sd(weight_m3), # Create variable with sd of cty per group
                   N_plastic=n(), # Create new variable N of cty per group
                   se=sd_plastic/sqrt(N_plastic), # Create variable with se of cty per group
                   upper_limit=mean_weight+se, # Upper limit
                   lower_limit=mean_weight-se) # Lower limit
            
#mean dataset by Orientation
TNL_means_se_orientation_weight <- TNL_SUR_All_Beaches %>% 
  group_by(Orientation) %>% # Group the data by manufacturer
  dplyr::summarise(mean_weight=mean(weight_m3), # Create variable with mean of cty per group
                   sd_plastic=sd(weight_m3), # Create variable with sd of cty per group
                   N_plastic=n(), # Create new variable N of cty per group
                   se=sd_plastic/sqrt(N_plastic), # Create variable with se of cty per group
                   upper_limit=mean_weight+se, # Upper limit
                   lower_limit=mean_weight-se) # Lower limit

TNL_means_se
TNL_means_se_region
TNL_means_se_orientation

#Baroplot of means of TNL SUR all beaches with standard error bars
ggplot(TNL_means_se_weight, aes(x=factor(sample), y=mean_weight, fill = Region)) + 
  scale_fill_manual(values = c("W" = 'white', "S" = "grey","E" = "dimgrey")) +
  geom_bar(stat="identity", colour = "black") + 
  geom_errorbar(aes(ymin=lower_limit, ymax=upper_limit), 
                width = 0.3,
                size = 0.4) +
  labs(y="Microplastic Abundance (g m^-3)", x = "Beach Number") +
  theme_minimal()

#Baroplot of means of TNL SUR all beaches with standard error bars by region
ggplot(TNL_means_se_region_weight, aes(x=factor(Region), y=mean_weight, fill = Region)) + 
  scale_fill_manual(values = c("W" ='white', "S" = "grey", "E" = "dimgrey")) +
  geom_bar(stat="identity", colour = "black", width = 0.5, aes(x = reorder(Region, desc(Region)))) +
  geom_errorbar(aes(ymin=lower_limit, ymax=upper_limit), colour = "black", 
                width = 0.3,
                size = 0.4) +
  labs(y="Microplastic Abundance (g m^-3)", x = "Region") +
  theme_minimal()

#Baroplot of means of TNL SUR all beaches with standard error bars by Orientation
ggplot(TNL_means_se_orientation_weight, aes(x=reorder(Orientation, -mean_weight), y=mean_weight)) + 
  geom_bar(stat="identity", colour = "black", width = 0.5) +
  geom_errorbar(aes(ymin=lower_limit, ymax=upper_limit), colour = "black", 
                width = 0.3,
                size = 0.4) +
  labs(y="Microplastic Abundance (g m^-3)", x = "Orientation") +
  theme_minimal()

  