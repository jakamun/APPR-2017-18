# 3. faza: Vizualizacija podatkov

#najprej poženem uvoz, da dobim tabele shranjene v spremenljivke

# Uvozimo zemljevid

evropa <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                          "ne_50m_admin_0_countries", 
                          encoding = "UTF-8") %>%
  pretvori.zemljevid() %>% 
  filter(CONTINENT == "Europe" | SOVEREIGNT %in% c("Turkey", "Cyprus") & SOVEREIGNT != "Russia",long > -30)

#Grafi za stevilo avtomobilov na 1000 prebivalcev

zemljevid <- ggplot() + geom_polygon(data = left_join(evropa, 
                                                       st_na_1000_prebivalcev %>% filter(Leto == 2012),
                                                       by = c("SOVEREIGNT" = "Drzava")),
                                      aes(x = long, y = lat, group = group, fill = Stevilo)) +
  coord_map(xlim = c(-25, 40), ylim = c(32, 72)) + scale_fill_continuous(na.value = "white") +
  labs(title="Število avtomobilov \n na 1000 prebivalcev leta 2012",x="",y="") +
  theme(plot.title = element_text(hjust = 0.5))

gostota <- ggplot(data = st_na_1000_prebivalcev,
                  aes(x = Leto, y=Stevilo, color = Drzava)) + geom_line() + 
  labs(title = "Število avtomobilov \n na 1000 prebivalcev", x = "Leto", y = "Število" ) +
  theme(plot.title = element_text(hjust = 0.5))

#emisije

zemljevid_emisije <- ggplot() + geom_polygon(data = left_join(evropa, emisije %>% filter(Leto == 2016),
                                                      by = c("SOVEREIGNT" = "Drzava")),
                                     aes(x = long, y = lat, group = group, fill = Gram_CO2_na_km)) +
  coord_map(xlim = c(-25, 40), ylim = c(32, 72)) + scale_fill_continuous(na.value = "white") +
  labs(title="Emisije CO2 leta 2016",x="",y="") + theme(plot.title = element_text(hjust = 0.5)) 

emis <- ggplot(data = emisije, aes(x = Leto,y = Gram_CO2_na_km, color = Drzava)) + geom_line()

emisije_slovenija <- ggplot(data = emisije %>% filter(Drzava == "Slovenia"), aes(x=Leto, y=Gram_CO2_na_km)) + 
  geom_point() + geom_path() +
  labs(title = "Emisije CO2 v Sloveniji") + theme(plot.title = element_text(hjust = 0.5))

#Avtomobilske znamke

drage_znamke <- ggplot(data = znamke %>% filter(Leto >= 2000, 
                                                Znamka == c("Aston Martin", "Audi", "BMW", "Jaguar", "Mercedes Benz")),
                      aes(x=Leto, y = St_prodanih, color = Znamka)) + geom_point() + geom_line() + 
  labs(title = "Najbol prodajane drage znamke", y = "Stevilo prodanih avtomobilov", x = "Leto") + 
  theme(plot.title = element_text(hjust = 0.5))

ne_tako_drage_znamke <- ggplot(data = znamke %>% filter(Leto >= 2000, 
                                                        Znamka == c("Opel", "Fiat", "Ford",
                                                                    "Kia", "Citroen", "Volkswagen", "Renault")),
                       aes(x=Leto, y = St_prodanih, color = Znamka)) + geom_point() + geom_line() + 
  labs(title = "Najbol prodajane cenejše znamke", y = "Stevilo prodanih avtomobilov", x = "Leto") + 
  theme(plot.title = element_text(hjust = 0.5))


znamke1 <- znamke
znamke1$`Delez_na_trgu(%)` <- NULL

graf_primerjava <- ggplot(data = znamke1 %>% filter(Leto >= 2000, 
                                                   Znamka == c("Mercedes Benz", "Volkswagen", "Ford","Peugeot","Audi")),
                          aes(x=Znamka, y = St_prodanih)) + geom_boxplot() + 
  labs(title = "Najbol prodajane avtomobilske znamke", y = "Število prodanih avtomobilov", x = "Avtomobilska znamka") + 
  theme(plot.title = element_text(hjust = 0.5))



















