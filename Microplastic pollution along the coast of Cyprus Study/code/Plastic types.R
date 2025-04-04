PLASTIC_TYPES$sample <- factor(PLASTIC_TYPES$sample)


#point plot of plastic types with means (particles) 
ggplot(plastic_type_means_bybeach)+ 
  geom_point(mapping = aes(y=mean_plastic, x=plastic_type), colour = "dimgray", size = 2.5) +
  geom_point(plastic_type_means, mapping = aes(x=plastic_type, y = mean_plastic), shape = "_", colour = "black", size = 14) +
  ylab("Thousand Particles m^-3")+
  xlab("Microplastic Category")+
  ylim(0,40)+
  theme_minimal()

#point plot of plastic types with means (weight) 
ggplot(plastic_weight_means_bybeach)+ 
  geom_point(mapping = aes(y=mean_plastic, x=plastic_type), colour = "dimgray", size = 2.5) +
  geom_point(plastic_weight_means, mapping = aes(x=plastic_type, y = mean_plastic), shape = "_", colour = "black", size = 14) +
  ylab("Microplastic Abundance (g m^-3)")+
  xlab("Microplastic Category")+
  theme_minimal()



#means of each plastic type total
plastic_type_means <- PLASTIC_TYPES %>% 
  group_by(plastic_type) %>% # Group the data by manufacturer
  dplyr::summarise(mean_plastic=mean(plastic_number), # Create variable with mean of cty per group
                   sd_plastic=sd(plastic_number), # Create variable with sd of cty per group
                   N_plastic=n(), # Create new variable N of cty per group
                   se=sd_plastic/sqrt(N_plastic), # Create variable with se of cty per group
                   upper_limit=mean_plastic+se, # Upper limit
                   lower_limit=mean_plastic-se # Lower limit
  )

#means of each plastic type sorted by beach
plastic_type_means_bybeach <- PLASTIC_TYPES %>% 
  group_by(sample, plastic_type) %>% # Group the data by manufacturer
  dplyr::summarise(mean_plastic=mean(plastic_number), # Create variable with mean of cty per group
                   sd_plastic=sd(plastic_number), # Create variable with sd of cty per group
                   N_plastic=n(), # Create new variable N of cty per group
                   se=sd_plastic/sqrt(N_plastic), # Create variable with se of cty per group
                   upper_limit=mean_plastic+se, # Upper limit
                   lower_limit=mean_plastic-se # Lower limit
  )

plastic_weight_means <- PLASTIC_TYPES %>% 
  group_by(plastic_type) %>% # Group the data by manufacturer
  dplyr::summarise(mean_plastic=mean(weight), # Create variable with mean of cty per group
                   sd_plastic=sd(weight), # Create variable with sd of cty per group
                   N_plastic=n(), # Create new variable N of cty per group
                   se=sd_plastic/sqrt(N_plastic), # Create variable with se of cty per group
                   upper_limit=mean_plastic+se, # Upper limit
                   lower_limit=mean_plastic-se # Lower limit
  )

plastic_weight_means_bybeach <- PLASTIC_TYPES %>% 
  group_by(sample, plastic_type) %>% # Group the data by manufacturer
  dplyr::summarise(mean_plastic=mean(weight), # Create variable with mean of cty per group
                   sd_plastic=sd(weight), # Create variable with sd of cty per group
                   N_plastic=n(), # Create new variable N of cty per group
                   se=sd_plastic/sqrt(N_plastic), # Create variable with se of cty per group
                   upper_limit=mean_plastic+se, # Upper limit
                   lower_limit=mean_plastic-se) # Lower limit


#Kruskal wallis test for TNL depth samples
kruskal.test(weight ~ plastic_type, data = PLASTIC_TYPES)
