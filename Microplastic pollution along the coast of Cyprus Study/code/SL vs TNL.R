#descriptive stats
sapply(TNL_means_se_weight, range, na.rm=TRUE)

#standard error 
sd(TNL_SUR_All_Beaches$weight_m3, na.rm=TRUE) /  
  sqrt(length(TNL_SUR_All_Beaches$weight_m3[!is.na(TNL_SUR_All_Beaches$weight_m3)])) 


#histogram of TNL Surface all beaches
ggplot(TNL_SUR_All_Beaches, aes(x=total_plastic_m3)) + 
  geom_histogram(binwidth = 30)



wilcox.test(TNL_means_se_weight$mean_weight, SL_means_se_weight$mean_weight, paired = TRUE, alternative = "two.sided")

#differences of SL and TNL raw data and means
SL_TNL_mean <- TNL_means_se$mean_plastic - SL_means_se$mean_plastic
SL_TNL <- TNL_SUR_All_Beaches$total_plastic_m3 - SL_SUR_All_Beaches$total_plastic_m3

#histogram of difference SL vs TNL
hist(SL_TNL, breaks = 15)

#density plot of differences SL vs TNL
d <- density(SL_TNL) # returns the density data
plot(d) # plots the results

#boxplot of TNL vs SL raw
boxplot(TNL_SUR_All_Beaches$total_plastic_m3, SL_SUR_All_Beaches$total_plastic_m3)

#boxplot of TNL vs SL means
boxplot (TNL_means_se$mean_plastic, SL_means_se$mean_plastic) +


library("PairedData")


ggpaired()  theme_bw()

#shapiro wilk test for normaliy mean difference
shapiro.test(SL_TNL_mean)

#shapiro wilk test for nomrality raw difference
shapiro.test(SL_TNL)

install.packages("ggpubr")

#histograph facet wrap of all beaches TNL
ggplot(TNL_SUR_All_Beaches, aes(x=total_plastic_m3))+
  geom_histogram(aes(y=..density..), bins = 15)+
  geom_density(alpha = 0.2)+
  facet_wrap(.~sample, scales = "free_y")

library("ggpubr")
#boxplot of TNL surface plastics across all beaches
ggboxplot(TNL_SUR_All_Beaches, x = "sample" , y = "total_plastic_m3")

#mean plot of TNL surface plastics across all beaches
ggline(TNL_SUR_All_Beaches, x = "sample", y = "total_plastic_m3", 
       add = c("mean_se", "jitter"))

#Kruskal wallis test for TNL surface samples
kruskal.test(weight_m3 ~ Orientation, data = TNL_SUR_All_Beaches)

#Multiple pairwise-comparison between groups to see where the significant differences are
pairwise.wilcox.test(TNL_SUR_All_Beaches$weight_m3, TNL_SUR_All_Beaches$Orientation,
                     p.adjust.method = "BH")





