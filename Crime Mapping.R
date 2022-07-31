#####################################################

# This code uses the ukpolice package to download the latest months reported crime and ASB data for Northern Ireland from www.police.uk
# It then projects this info to an interactive map

#####################################################

# load required packages
pacman::p_load(mapview, ukpolice, sf)

# www.police.uk will only allow downloads of a certain size (up to 10,000 records), 
# so we do a download for a northern region, and one for a southern region.
# Belfast is the most concentrated area, so we ruin the dividing line through there to split that cluster in half. 
# Each region carries some of that load.

# Northern region poly-coordinate data frame
df1 <- data.frame(
  lat = c(55.4, 54.58, 54.58, 55.4),
  lng = c(-8.2, -8.2, -5.45, -5.45)
)

# Southern region poly-coordinate data frame
df2 <- data.frame(
  lat = c(54.58, 54.0, 54.0, 54.58),
  lng = c(-8.2, -8.2, -5.45, -5.45)
)

#download the data frames for each region
crimes_n <- ukc_crime_poly(df1)
crimes_s <- ukc_crime_poly(df2)

#combine the two dataframes
crimes_all <- rbind(crimes_n, crimes_s)

#convert lat and long to numeric
crimes_all$latitude <- as.numeric(crimes_all$latitude)
crimes_all$longitude <- as.numeric(crimes_all$longitude)

#convert dataframe to st object, and apply projection info
crimes_all <- st_as_sf(x = crimes_all, 
                        coords = c("longitude", "latitude"),
                        crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

#produce map
mapview(crimes_all, xcol = "longitude", ycol = "latitude", zcol = "category", burst = TRUE, legend = FALSE)
