library(rgdal)
library(maptools)

ogrListLayers("WVL_Scheepvaartongevallen.gdb")
sch_niet_sig<- readOGR("WVL_Scheepvaartongevallen.gdb",layer="Scheepsvoorvallen_niet_significant")
sch_sig<- readOGR("WVL_Scheepvaartongevallen.gdb",layer="Scheepsvoorvallen_significant")

sluizen<- readShapePoints("WVL_Scheepvaartongevallen.gdb",)
sluizen<- readOGR("WVL_Scheepvaartongevallen.gdb",layer="Sluizen")
bruggen<- readOGR("WVL_Scheepvaartongevallen.gdb",layer="Bruggen")

##to wgs
rd<- "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.999908 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +no_defs"
wgs<- "+proj=longlat +ellps=WGS84 +datum=WGS84"
proj4string(sch_niet_sig)<- rd #definieer de projectie van shapefile
sch_niet_sig<- spTransform(sch_niet_sig,wgs) #transformeer naar wgs84
proj4string(sch_sig)<- rd #definieer de projectie van shapefile
sch_sig<- spTransform(sch_sig,wgs) #transformeer naar wgs84

save(sch_niet_sig,file="sch_niet_sig.RData")
save(sch_sig,file="sch_sig.RData")

plot(sch_sig)

library(leaflet)
leaflet() %>% addTiles() %>% addCircles(data=sch_niet_sig)

###explore
load("sch_niet_sig.RData")
load("sch_sig.RData")

library(ggplot2)
df<- as.data.frame(sch_niet_sig)
ggplot(df,aes(x=WEEKDAG_VOORVAL))+geom_histogram(stat="count")
ggplot(df,aes(x=WINDKRACHT_OMSCHRIJVING))+geom_histogram(stat="count")
ggplot(df,aes(x=BEVAARBAARHEIDSKLASSE_OMS))+geom_histogram(stat="count")
ggplot(df,aes(x=X_COORDINAAT,y=Y_COORDINAAT))+geom_point()


mymonths <- c("Jan","Feb","Mar",
              "Apr","Mei","Jun",
              "Jul","Aug","Sep",
              "Okt","Nov","Dec")

Gewonden_per_jaar_sign<- aggregate(cbind(AANTAL_GEWONDEN_LICHT,AANTAL_GEWONDEN_ZWAAR,AANTAL_GEWONDEN_OVERIG,AANTAL_VERMISTEN,AANTAL_DODEN) ~ MAAND_VOORVAL + JAAR_VOORVAL,data=sch_sig,FUN="sum")
colnames(Gewonden_per_jaar_sign)<- c("Maand","Jaar","Licht gewond","Zwaar gewond","Gewond Overig","Vermist","Dood")
Gewonden_per_jaar_sign$Maand <- mymonths[ Gewonden_per_jaar_sign$Maand ]
save(Gewonden_per_jaar_sign,file="gewonden_per_jaar_sign.RData")

Gewonden_per_jaar_niet_sign<- aggregate(cbind(AANTAL_GEWONDEN_LICHT,AANTAL_GEWONDEN_ZWAAR,AANTAL_GEWONDEN_OVERIG,AANTAL_VERMISTEN,AANTAL_DODEN) ~ MAAND_VOORVAL + JAAR_VOORVAL,
                                        data=sch_niet_sig,FUN="sum")
colnames(Gewonden_per_jaar_niet_sign)<- c("Maand","Jaar","Licht gewond","Zwaar gewond","Gewond Overig","Vermist","Dood")
Gewonden_per_jaar_niet_sign$Maand <- mymonths[ Gewonden_per_jaar_niet_sign$Maand ]
save(Gewonden_per_jaar_niet_sign,file="gewonden_per_jaar_niet_sign.RData")
