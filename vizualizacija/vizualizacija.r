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
  labs(title="Stevilo avtomobilov \n na 1000 prebivalcev leta 2012",x="",y="") +
  theme(plot.title = element_text(hjust = 0.5))

#Grafi za starost avtomobilov

g <- ggplot(data = starost %>% filter(Starost == "Mlajsi od 2 let", Drzava == c("Estonia", "Slovenia", "Finland")),
            aes(x = Leto, y=St_avtomobilov, color = Drzava)) + geom_line() +
  labs(title = "Avtomobili mlajši od dveh let", x = "Leto", y = "Stevilo avtomobilov" ) +
  theme(plot.title = element_text(hjust = 0.5))

starost_baltik <- ggplot(data = starost %>% filter(Drzava == c("Estonia", "Latvia", "Lithuania")), 
            aes(x=Leto,y=St_avtomobilov, color = Drzava)) + geom_line() + facet_wrap(~Starost) + 
  labs(title = "Starost avtomobilov v baltskih drzavah", x = "Leto", y = "Stevilo avtomobilov") +
  theme(plot.title = element_text(hjust = 0.5))

starost1 <- starost %>% filter(Drzava == c("United Kingdom", "Italy", "France",
                                           "Germany"))

graf_starost <- ggplot(data = starost1, aes(x=Leto,y=St_avtomobilov, color = Drzava)) + geom_line() + 
  facet_wrap(~Starost) + 
  labs(title = "Starost avtomobilov", x = "Leto", y = "Stevilo avtomobilov") +
  theme(plot.title = element_text(hjust = 0.5))

starost_nemcija <- ggplot(data = starost %>% filter(Drzava == "Germany"),
                                                    aes(x=Leto, y=St_avtomobilov, color = Starost)) + geom_path() +
  labs(title = "Starost avtomobilov v Nemčiji", x = "Leto", y = "Stevilo avtomobilov") +
  theme(plot.title = element_text(hjust = 0.5))

#grafi za tezo

sosednje_drzave <- ggplot(data = teza %>% filter(Drzava == c("Hungary", "Croatia", "Austria")),
                          aes(x=Leto, y=St_avtomobilov, color = Drzava)) +
  geom_point() + geom_line() + facet_wrap(~Teza) +
  labs(title = "Teza avtomobilov \n v sosednjih drzavah", x = "Leto", y = "Stevilo avtomobilov") +
  theme(plot.title = element_text(hjust = 0.5))

teza_francija <- ggplot(data = teza %>% filter(Drzava == "France"), aes(x = Leto, y = St_avtomobilov, col = Teza)) +
  geom_line() +
  labs(title = "Teza avtomobilov v Spaniji", x = "Leto", y = "Stevilo avtomobilov") +
  theme(plot.title = element_text(hjust = 0.5))

#emisije

zemljevid_emisije <- ggplot() + geom_polygon(data = left_join(evropa, emisije %>% filter(Leto == 2016),
                                                      by = c("SOVEREIGNT" = "Drzava")),
                                     aes(x = long, y = lat, group = group, fill = Gram_CO2_na_km)) +
  coord_map(xlim = c(-25, 40), ylim = c(32, 72)) + scale_fill_continuous(na.value = "white") +
  labs(title="Emisije CO2 leta 2016",x="",y="") + theme(plot.title = element_text(hjust = 0.5)) 

emisije_graf <- ggplot(data = emisije %>% filter(Drzava == c("Spain", "France", "Portugal", "Italy")),
                 aes(x = Drzava, y = Gram_CO2_na_km)) + geom_boxplot() +
  labs(title = "Emisije CO2") + theme(plot.title = element_text(hjust = 0.5))

emisije_slovenija <- ggplot(data = emisije %>% filter(Drzava == "Slovenia"), aes(x=Leto, y=Gram_CO2_na_km)) + 
  geom_point() + geom_path() +
  labs(title = "Emisije CO2 v Sloveniji") + theme(plot.title = element_text(hjust = 0.5))

#Vrste motorja

motor_nemcija <- ggplot(data = vrsta_motorja %>% filter(Drzava == "Germany"),
                        aes(x=Leto, y=Vrednost, color=Vrsta_goriva)) + 
  geom_point() + geom_path() + facet_wrap(~Motor) +
  labs(title = "Velikosti motorjev v Nemciji", y="Stevilo avtomobilov") + 
  theme(plot.title = element_text(hjust = 0.5))

# vrste goriva

goriva_sever <- ggplot(data = goriva %>% filter(Drzava ==
                                                      c("Ireland", "United Kingdom", "Sweden", 
                                                        "Finland", "Norway")), 
                           aes(x=Leto, y=St_avtomobilov, color=Drzava)) + geom_point() + facet_wrap(~Vrsta_goriva) +
  labs(title = "Vrste goriv \n v severnih državah Evrope", x = "Leto", y = "Stevilo avtomobilov") + 
  theme(plot.title = element_text(hjust = 0.5))

goriva1 <- goriva %>% filter(Vrsta_goriva == c("Electrical Energy", "LPG", "Natural Gas", "Other products"),
                             Drzava == c("Netherlands", "Sweden", "Denmark", "Belgium"))

alternativna_goriva <- ggplot(data = goriva1, aes(x=Leto, y=St_avtomobilov, color=Drzava)) + 
  geom_point() + facet_wrap(~Vrsta_goriva) + 
  labs(title = "Vrste goriv", x = "Leto", y = "Stevilo avtomobilov") + 
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
  labs(title = "Najbol prodajane avtomobilske znamke", y = "Stevilo prodanih avtomobilov", x = "Avtomobilska znamka") + 
  theme(plot.title = element_text(hjust = 0.5))



















