sample <- factor(SL_SUR_All_Beaches$sample)
means <- ddply(SL_SUR_All_Beaches, c("sample"), summarise,
               mean=mean(total_plastic_m3))
means.barplot <- ggplot(data=means, mapping=aes(x=sample, y=mean))+
  geom_bar(position=position_dodge(), stat="identity")
means.barplot


SUR_DEP_ALL <- TNL_SUR_DEP %>% 
  group_by(Depth) %>% # Group the data by manufacturer
  dplyr::summarise(mean_plastic=mean(total_plastic_m3), # Create variable with mean of cty per group
                   sd_plastic=sd(total_plastic_m3), # Create variable with sd of cty per group
                   N_plastic=n(), # Create new variable N of cty per group
                   se=sd_plastic/sqrt(N_plastic), # Create variable with se of cty per group
                   upper_limit=mean_plastic+se, # Upper limit
                   lower_limit=mean_plastic-se # Lower limit
  ) 


#barplot of SL means all beaches
ggplot(SL_means_se, aes(x=factor(sample), y=mean_plastic)) + geom_bar(stat="identity") + 
  geom_errorbar(aes(ymin=lower_limit, ymax=upper_limit), 
                width = 0.3,
                size = 0.4) +
  labs(y="Thousand particles m^-3", x = "Beach Number") +
  theme_minimal()


