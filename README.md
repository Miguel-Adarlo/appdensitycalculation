# appdensitycalculation
Data Science Toolbox Discussion Exercise

## Computing Barangay Density
**1. Find the number of barangays per region**\
Done by aggregation in R. Result was the number of barangays per region.

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

**2. Divide the area of the region by the number of barangays per region**\
Done by division in R. Result was the area of each barangay.

```
{
#Area of Each Barangay
r2$brgyarea = regionarea$Area/r2$numbrgy
}
```

**3. Divide the population of each barangay by its area**\
Done by division in R after a merging of dataframes. Result was the population density.

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
Done with R. Result was a CSV file detailing the top 5 most densely populated barangays.

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

## Computing City Density
**1. Find the number of cities per region**\
Done by aggregation in R. Result was the number of cities per region.

```
{
#Aggregation:
regionlist = aggregate(x = population$CityProvince,           # Specify data column
                       by = list(population$Region),          # Specify group indicator
                       FUN = function(x) length(unique(x)))   #Desired function

colnames(regionlist)[1] = 'Region'     #change column names          
colnames(regionlist)[2] = 'CityCount'               
sum(regionlist$CityCount) #verify number of cities}
```

**2. Divide the area of the region by the number of cities**\
Done by division in R. Result was the area of each city.

```
{
df_region = merge(x = regionlist, y = regionarea, by = 'Region', all.x = TRUE) #Left join, get the area per region from region area
df_region$CityArea = df_region$Area/df_region$CityCount #divide region area to num of cities
}
```

**3. Find the population sum for each city**\
Done by aggregation in R. Result was the population per city.

```
{
populationsum = aggregate(data = population,                       # Specify data column
                          Population ~ Region + CityProvince,      # Specify group indicator
                          FUN = sum)                               #Desired function

colnames(populationsum)[1] = 'Region'  
colnames(populationsum)[2] = 'CityProvince'    
}
```

**4. Divide the population of each city by its area**\
Done by division in R after a merging of dataframes. Result was the population density per city.

```
{
#Merge tables with city area and population
df = merge(x = populationsum, y = df_region, by = 'Region')

#Solve for City Density
df$CityDensity = df$Population / df$CityArea
}
```

**5. Sort and save the Top 5 City Population Density**\
Done with R. Result was a CSV file detailing the top 5 most densely populated cities.

```
{
#Sort in decreasing order to get top 5
df2 = df[order(df$CityDensity, decreasing = TRUE),]

#Print CSV
CityDF = subset(df2, select = c('CityProvince', 'CityDensity'))
top5_city = head(CityDF, 5)
write.csv(top5_city, file = './Top5_City_Density.csv')
}
```

