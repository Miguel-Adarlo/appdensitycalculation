#Read CSV
population = read.csv('population.csv')
regionarea = read.csv('regionarea.csv')

#Get number of cities per region
regionlist = aggregate(x = population$CityProvince,          # Specify data column
                       by = list(population$Region),      # Specify group indicator
                       FUN = function(x) length(unique(x))) #Desired function

colnames(regionlist)[1] = 'Region'               
colnames(regionlist)[2] = 'CityCount'               
sum(regionlist$CityCount)

#Solve for area of city = area / num of city
df_region = merge(x = regionlist, y = regionarea, by = 'Region', all.x = TRUE)
df_region$CityArea = df_region$Area/df_region$CityCount

#Identify population per city
populationsum = aggregate(data = population,          # Specify data column
                          Population ~ Region + CityProvince,      # Specify group indicator
                          FUN = sum) #Desired function

colnames(populationsum)[1] = 'Region'  
colnames(populationsum)[2] = 'CityProvince'               

#Merge tables with city area and population
df = merge(x = populationsum, y = df_region, by = 'Region')

#Solve for City Density
df$CityDensity = df$Population / df$CityArea

#Sort in decreasing order to get top 5
df2 = df[order(df$CityDensity, decreasing = TRUE),]

#Print CSV
CityDF = subset(df2, select = c('CityProvince', 'CityDensity'))
top5_city = head(CityDF, 5)
write.csv(top5_city, file = './Top5_City_Density.csv')
