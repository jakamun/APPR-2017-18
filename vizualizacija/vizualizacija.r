# 3. faza: Vizualizacija podatkov

#najprej poženem uvoz, da dobim tabele shranjene v spremenljivke

# Uvozimo zemljevid

evropa <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                          "ne_50m_admin_0_countries", 
                          encoding = "UTF-8") %>%
  pretvori.zemljevid() %>% 
  filter(CONTINENT == "Europe" | SOVEREIGNT %in% c("Turkey", "Cyprus") & SOVEREIGNT != "Russia",long > -30)



#Grafi za stevilo avtomobilov na 1000 prebivalcev

ggplot() + geom_polygon(data = evropa, aes(x = long, y = lat,
                                           group = group, fill = id)) +
  guides(fill = FALSE)





#Grafi za starost avtomobilov

g <- ggplot(data = starost %>% filter(Starost == "Mlajsi od 2 let", Drzava == c("Estonia", "Slovenia", "Finland")),
            aes(x = Leto, y=St_avtomobilov, color = Drzava)) + geom_line() +
  labs(title = "Avtomobili mlajši od dveh let", x = "Leto", y = "Stevilo avtomobilov" ) +
  theme(plot.title = element_text(hjust = 0.5))

starost_baltik <- ggplot(data = starost %>% filter(Drzava == c("Estonia", "Latvia", "Lithuania")), 
            aes(x=Leto,y=St_avtomobilov, color = Drzava)) + geom_line() + facet_wrap(~Starost) + 
  labs(title = "Starost avtomobilov v baltskih drzavah", x = "Leto", y = "Stevilo avtomobilov") +
  theme(plot.title = element_text(hjust = 0.5))
print(g)
print(starost_baltik)

#grafi za tezo

sosednje_drzave <- ggplot(data = teza %>% filter(Drzava == c("Hungary", "Croatia", "Austria")),
                          aes(x=Leto, y=St_avtomobilov, color = Drzava)) +
  geom_point() + geom_line() + facet_wrap(~Teza) +
  labs(title = "Teza avtomobilov \n v sosednjih drzavah", x = "Leto", y = "Stevilo avtomobilov") +
  theme(plot.title = element_text(hjust = 0.5))

spanija <- ggplot(data = teza %>% filter(Drzava == "Spain"), aes(x = Leto, y = St_avtomobilov, col = Teza)) +
  geom_line() +
  labs(title = "Teza avtomobilov v Spaniji", x = "Leto", y = "Stevilo avtomobilov") +
  theme(plot.title = element_text(hjust = 0.5))

#emisije

emisije_graf <- ggplot(data = emisije %>% filter(Drzava == c("Spain", "France", "Portugal", "Italy")),
                 aes(x = Drzava, y = Gram_CO2_na_km)) + geom_boxplot() +
  labs(title = "Emisije CO2") + theme(plot.title = element_text(hjust = 0.5))

emisije_slovenija <- ggplot(data = emisije %>% filter(Drzava == "Slovenia"), aes(x=Leto, y=Gram_CO2_na_km)) + 
  geom_point() + geom_path() +
  labs(title = "Emisije CO2 v Sloveniji") + theme(plot.title = element_text(hjust = 0.5))

#Vrste motorja

motor_nemcija <- ggplot(data = vrsta_motorja %>% filter(Drzava == "Germany (until 1990 former territory of the FRG)"),
                        aes(x=Leto, y=Vrednost, color=Vrsta_goriva)) + 
  geom_point() + geom_path() + facet_wrap(~Motor) +
  labs(title = "Velikosti motorjev v Nemciji", y="Stevilo avtomobilov") + 
  theme(plot.title = element_text(hjust = 0.5))
print(motor_nemcija)
# vrste goriva

goriva_sever <- ggplot(data = goriva %>% filter(Drzava ==
                                                      c("Ireland", "United Kingdom", "Sweden", 
                                                        "Finland", "Norway", "Iceland")), 
                           aes(x=Leto, y=St_avtomobilov, color=Drzava)) + geom_line() + facet_wrap(~Vrsta_goriva) +
  labs(title = "Vrste goriv \n v severnih državah Evrope", x = "Leto", y = "Stevilo avtomobilov") + 
  theme(plot.title = element_text(hjust = 0.5))

goriva_islandija <- ggplot(data = goriva %>% filter(Drzava == "Iceland"),
                           aes(x = Vrsta_goriva, y = St_avtomobilov)) +
  geom_boxplot() + 
  labs(title = "Vrste goriv na Islandiji", x = "Vrsta goriva", y = "Stevilo avtomobilov") + 
  theme(plot.title = element_text(hjust = 0.5))

goriva_slovenija <- ggplot(data = goriva %>% filter(Drzava == "Slovenia"),
                           aes(x = Vrsta_goriva, y = St_avtomobilov)) +
  geom_boxplot() + 
  labs(title = "Vrste goriv v Sloveniji", x = "Vrsta goriva", y = "Stevilo avtomobilov") + 
  theme(plot.title = element_text(hjust = 0.5))






















