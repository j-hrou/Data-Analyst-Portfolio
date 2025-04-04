#descriptive stats
sapply(TNL_SUR_All_Beaches, mean, na.rm=TRUE)

#histogram of TNL Depth all beaches
ggplot(TNL_DEP_All_Beaches, aes(x=total_plastic_m3)) + 
  geom_histogram(binwidth = 10)

TNL_DEP_means_se <- TNL_DEP_All_Beaches %>% 
  group_by(sample) %>% # Group the data by sample
  dplyr::summarise(mean_plastic=mean(total_plastic_m3), # Create variable with mean of cty per group
                   sd_plastic=sd(total_plastic_m3), # Create variable with sd of cty per group
                   N_plastic=n(), # Create new variable N of cty per group
                   se=sd_plastic/sqrt(N_plastic), # Create variable with se of cty per group
                   upper_limit=mean_plastic+se, # Upper limit
                   lower_limit=mean_plastic-se) # Lower limit

wilcox.test(TNL_DEP_means_se$mean_plastic, TNL_means_se$mean_plastic, paired = TRUE, alternative = "two.sided")

#differences of TNL SUR and TNL DEP raw data and means
SUR_DEP_mean <- TNL_means_se$mean_plastic - TNL_DEP_means_se$mean_plastic
SUR_DEP <- TNL_SUR_All_Beaches$total_plastic_m3 - TNL_DEP_All_Beaches$total_plastic_m3

#histogram of difference SUR vs DEP
hist(SUR_DEP, breaks = 15)

#density plot of differences SUR vs DEP
den <- density(SUR_DEP) # returns the density data
plot(den) # plots the results

#boxplot of SUR vs DEP raw
boxplot(TNL_SUR_All_Beaches$total_plastic_m3, TNL_DEP_All_Beaches$total_plastic_m3)

#boxplot of SUR vs DEP means
boxplot (TNL_means_se$mean_plastic, TNL_DEP_means_se$mean_plastic)

library("PairedData")

#mean plot of SUR vs DEP means

total <- merge(TNL_means_se, TNL_DEP_means_se,by="sample")

SUR_DEP_ALL_weight <- TNL_SUR_DEP %>% 
  group_by(Depth) %>% # Group the data by manufacturer
  dplyr::summarise(mean_weight=mean(weight_m3), # Create variable with mean of cty per group
                   sd_plastic=sd(weight_m3), # Create variable with sd of cty per group
                   N_plastic=n(), # Create new variable N of cty per group
                   se=sd_plastic/sqrt(N_plastic), # Create variable with se of cty per group
                   upper_limit=mean_weight+se, # Upper limit
                   lower_limit=mean_weight-se # Lower limit
)

SUR_DEP_each <- TNL_SUR_DEP %>% 
  group_by(sample, Depth) %>% # Group the data by manufacturer
  dplyr::summarise(mean_plastic=mean(total_plastic_m3), # Create variable with mean of cty per group
                   sd_plastic=sd(total_plastic_m3), # Create variable with sd of cty per group
                   N_plastic=n(), # Create new variable N of cty per group
                   se=sd_plastic/sqrt(N_plastic), # Create variable with se of cty per group
                   upper_limit=mean_plastic+se, # Upper limit
                   lower_limit=mean_plastic-se # Lower limit
  )

   
#Mean plot of different DEPTHS at TNL TOTAL           
ggplot(SUR_DEP_ALL_weight, aes(y=reorder(Depth, mean_weight), x=mean_weight, group=1)) + 
  geom_errorbar(aes(xmin=mean_weight-se, xmax=mean_weight+se), width=.1) +
  geom_line() +
  geom_point(colour = "dimgray", size = 3) +
  xlab("Microplastic Abundance (g m^-3)")+
  ylab("Depth (cm)")+
  scale_x_continuous(position = 'top', limits = c(0,250))+
  scale_y_discrete()+
  theme_minimal()

#Mean plot of different DEPTHS at TNL each beach (not working)           
ggplot(SUR_DEP_each, aes(x=Depth, y=mean_plastic)) + 
  geom_errorbar(aes(ymin=mean_plastic-se, ymax=mean_plastic+se), width=.1) +
  geom_line() +
  geom_point() +
  ylab("Thousand Particles m^-3")+
  xlab("Depth (cm)")+
  theme_minimal()

#shapiro wilk test for normaliy mean difference
shapiro.test(SUR_DEP_mean)

#shapiro wilk test for nomrality raw difference
shapiro.test(SUR_DEP)

install.packages("ggpubr")

#histograph facet wrap of all beaches TNL
ggplot(TNL_SUR_All_Beaches, aes(x=total_plastic_m3))+
  geom_histogram(aes(y=..density..), bins = 15)+
  geom_density(alpha = 0.2)+
  facet_wrap(.~sample, scales = "free_y")

library("ggpubr")
#boxplot of TNL depth plastics across all beaches
ggboxplot(TNL_SUR_All_Beaches, x = "sample" , y = "total_plastic_m3")

#mean plot of TNL depth plastics across all beaches
ggline(TNL_SUR_All_Beaches, x = "sample", y = "total_plastic_m3", 
       add = c("mean_se", "jitter"))

#Kruskal wallis test for TNL depth samples
kruskal.test(total_plastic_m3 ~ Region, data = TNL_SUR_All_Beaches)

#Multiple pairwise-comparison between groups to see where the significant differences are
pairwise.wilcox.test(TNL_SUR_All_Beaches$total_plastic_m3, TNL_SUR_All_Beaches$Orientation,
                     p.adjust.method = "BH")

#wilcoxon test for significant difference between surface and depth TNL
wilcox.test(TNL_SUR_All_Beaches$total_plastic_m3, TNL_DEP_All_Beaches$total_plastic_m3, paired = TRUE, exact = TRUE)
