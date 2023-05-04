#Read the population file:
population = read.csv("population.csv")

#Read the region area file:
regionarea = read.csv("regionarea.csv")

#Using the population.csv and regionarea.csv files, 
#calculate the population density (persons per square km) 
#of all barangays in the Philippines.

#b) However, since only areas for regions are provided 
#(in square kilometers), assume that the barangays in a 
#particular region will have equal land area. 
#(E.g. Area of Barangay in Region 1 = Area of Region 1/
#Number of Barangays in Region 1)

#Aggregate
r2 = aggregate(Barangay~Region, population, FUN = unique )
r2$Barangay[[1]]
length(r2$Barangay[[1]])
#Forced to use for loop
for (x in 1:18)
{
  r2$numbrgy[x] = length(r2$Barangay[[x]])
}
#Error: recursive indexing failed at level 2
#i = 1:18; r2$numbrgy = (length(r2$Barangay[[i]]))
#sum(r2$numbrgy)

#Area of Each Barangay
r2$brgyarea = regionarea$Area/r2$numbrgy

#Merge to find pop density. This is for conforming lengths
pop_region = merge(x = population, y = r2, by=c("Region"), all.x = TRUE)
pop_region

#Pop. density of each barangay
pop_region$popdensity = pop_region$Population/pop_region$brgyarea

#Sort by pop. density, descending
sorted_pop_region = pop_region[order(pop_region$popdensity, decreasing = TRUE), ]

#Only show columns needed
trunc_pop_region = subset(sorted_pop_region, select = c("Barangay.x","popdensity" ))

#Rename column
names(trunc_pop_region)[names(trunc_pop_region) == 'Barangay.x'] <- 'Barangay'

#Print CSV
top5_brgy = head(trunc_pop_region, 5)
write.csv(top5_brgy, file = './Top5_Brgy_Density.csv')
