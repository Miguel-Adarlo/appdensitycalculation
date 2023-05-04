# appdensitycalculation
Data Science Toolbox Discussion Exercise

## Computing Barangay Density
**1. Find the number of barangays per region**\
Done by aggregation in R.

```
{
#Aggregation:
r2 = aggregate(Barangay~Region, population, FUN = unique )
r2$Barangay[[1]] #Prints the Barangays attached to the Region
length(r2$Barangay[[1]]) #Counts the number of barangays. Result is 2081.

#Forced to use for loop
for (x in 1:18)
{
  r2$numbrgy[x] = length(r2$Barangay[[x]]) #Attaches the number of barangays to the region
}
#Error: recursive indexing failed at level 2
#i = 1:18; r2$numbrgy = (length(r2$Barangay[[i]]))

}
```

**2. Divide the area of the region by the number of barangays**\
Done by division in R

```
{
#Area of Each Barangay
r2$brgyarea = regionarea$Area/r2$numbrgy
}
```

**3. Divide the population of each barangay by its area**\
Done by division in R after a merging of dataframes.

```
{
#Merge to find pop density. This is for conforming lengths
pop_region = merge(x = population, y = r2, by=c("Region"), all.x = TRUE) #Left merge.
pop_region

#Pop. density of each barangay
pop_region$popdensity = pop_region$Population/pop_region$brgyarea
}
```

**4. Sort and save the Top 5 Barangay Population Density**\
Done with R.

```
{
#Sort by pop. density, descending
sorted_pop_region = pop_region[order(pop_region$popdensity, decreasing = TRUE), ]

#Only show columns needed
trunc_pop_region = subset(sorted_pop_region, select = c("Barangay.x","popdensity" ))

#Rename column
names(trunc_pop_region)[names(trunc_pop_region) == 'Barangay.x'] <- 'Barangay'

#Print CSV
top5_brgy = head(trunc_pop_region, 5)
write.csv(top5_brgy, file = './Top5_Brgy_Density.csv')
}
```

