# 2. faza: Uvoz podatkov

preciscena_teza <- function() {
  stolpci <- c("Leto", "Drzava", "Teza", "Enota", "St_avtomobilov", "Fla")
  teza <- read_csv("podatki/teza.csv", locale=locale(encoding="cp1250"),
                   col_names = stolpci, skip=1, na=c(":", ""," ", "-"))
  teza$Fla <- NULL
  teza$Enota <- NULL
  teza <- teza[c(2,1,3,4)]
  teza <- teza %>% filter(St_avtomobilov != "NA", Leto >= "2000")
  teza$Teza <- gsub("Less than 1 000 kg", "Lazji od 1000 kg", 
                    gsub("From 1 000 to 1 249 kg", "1000-1249 kg",
                         gsub("From 1 250 to 1 499 kg", "1250-1499 kg",
                              gsub("1 500 kg or over", "Tezji od 1500 kg", teza$Teza))))
  return(teza)
}
teza <- preciscena_teza()

preciscena_starost <- function() {
  starost <- read_csv("podatki/starost.csv", locale = locale(encoding="cp1250"), na=c("", " ", "-", ":"))
  starost <- starost %>% select(Drzava = GEO,Leto = TIME,Starost = AGE,St_avtomobilov = Value) %>%
    filter(St_avtomobilov != "NA", Leto >= "2000")
  starost$Drzava <- gsub("^Germany.*", "Germany", starost$Drzava)
  starost$Drzava <- gsub("Former Yugoslav Republic of Macedonia, the", "Macedonia", starost$Drzava)
  starost$Starost <- gsub("Less than 2 years", "Mlajsi od 2 let",
                          gsub("From 2 to 5 years", "2-5 let",
                               gsub("From 5 to 10 years", "5-10 let",
                                    gsub("Over 10 years", "Starejsi od 10 let", starost$Starost))))
  return(starost)
}
starost <- preciscena_starost()

preciscene_emisije <- function() {
  emisije <- read_csv2("podatki/emisije_CO2.csv", locale = locale(encoding = "cp1250"),
                       na=c(""," ",":","-"), skip = 2, n_max=33)
  emisije <- gather(emisije, "2000", "2001", "2002", "2003", "2004", "2005", "2006","2007", "2008",
                    "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", key = "Leto", value = "Gram_CO2_na_km")
  emisije <- emisije %>% select(Drzava = "geo\\time", Leto, Gram_CO2_na_km) %>% filter(Gram_CO2_na_km != "NA")
  emisije$Leto <- as.integer(emisije$Leto)
  return(emisije)
}
emisije <- preciscene_emisije()

st_na_1000_prebivalcev <- function() {
  st_na_1000_prebivalcev <- read_csv("podatki/st_na_1000_prebivalcev.csv", locale = locale(encoding = "cp1250"),
                                     na=c(""," ","-",":"))
  st_na_1000_prebivalcev <- st_na_1000_prebivalcev %>% select(Drzava = GEO, Leto = TIME, Stevilo = Value) %>% 
    filter(Stevilo != "NA", Leto >= "2000")
  st_na_1000_prebivalcev$Drzava <- gsub("Former Yugoslav Republic of Macedonia, the", "Macedonia", st_na_1000_prebivalcev$Drzava)
  st_na_1000_prebivalcev$Drzava <- gsub("^Germany.*", "Germany", st_na_1000_prebivalcev$Drzava)
  return(st_na_1000_prebivalcev)
}
st_na_1000_prebivalcev <- st_na_1000_prebivalcev()

goriva <- function() {
  dizel_bencin <- read_csv("podatki/dizel_in_bencin.csv", locale = locale(encoding = "cp1250"),
                           na=c(""," ","-",":"))
  ostala_goriva <- read_csv("podatki/ostala_goriva.csv", locale = locale(encoding = "cp1250"),
                            na=c(""," ","-",":"))
  dizel_bencin <- dizel_bencin %>% select(Leto = TIME, Drzava = GEO, Vrsta_goriva = PROD_NRG, St_avtomobilov=Value) %>%
    filter(St_avtomobilov != "NA", Leto >= 2000)
  ostala_goriva <- ostala_goriva %>% select(Leto = TIME, Drzava = GEO, Vrsta_goriva = PROD_NRG, St_avtomobilov = Value) %>%
    filter(Leto >= 2000, St_avtomobilov != "NA")
  ostala_goriva$St_avtomobilov <- ostala_goriva$St_avtomobilov * 1000
  zdruzena <- rbind(ostala_goriva, dizel_bencin)
  zdruzena$Drzava <- gsub("^Germany.*", "Germany",
                          gsub("Former Yugoslav Republic of Macedonia, the", "Macedonia", zdruzena$Drzava))
  return(zdruzena)
}
goriva <- goriva()

velikost_motorja <- function() {
  tabela <- read_csv("podatki/velikost_motorja.csv", locale = locale(encoding = "cp1250"), 
                     na=c(""," ",":","-"))
  tabela <- tabela %>% select(Drzava = GEO, Leto =TIME, Vrsta_goriva = PROD_NRG, Motor = ENGINE, Vrednost = Value) %>%
    filter(Leto >= 2000, Vrednost != "NA") 
  tabela$Vrsta_goriva <- gsub("All Petroleum Products", "Bencin", tabela$Vrsta_goriva)
  tabela$Vrsta_goriva <- gsub("Diesel", "Dizel", tabela$Vrsta_goriva)
  tabela$Motor <- gsub("Less than 1 400 cmł", "Manj kot 1400", 
                       gsub("From 1 400 to 1 999 cmł", "1400-1999",
                            gsub("2 000 cmł or over", "2000 in vec", tabela$Motor)))
  return(tabela)
}
vrsta_motorja <- velikost_motorja()

#znamke <- c(aston_martin <- "http://carsalesbase.com/european-car-sales-data/aston-martin/",
 #           audi <- "http://carsalesbase.com/european-car-sales-data/audi/",
#            bentley <- "http://carsalesbase.com/european-car-sales-data/bentley/",
 #           bmw <- "http://carsalesbase.com/european-car-sales-data/bmw/",
  #          cadillac <- "http://carsalesbase.com/european-car-sales-data/cadillac/",
   #         chrysler <- "http://carsalesbase.com/european-car-sales-data/chrysler/",
  #          citroen <- "http://carsalesbase.com/european-car-sales-data/citroen/",
#            dacia <- "http://carsalesbase.com/european-car-sales-data/dacia/",
#            dodge <- "http://carsalesbase.com/european-car-sales-data/dodge/",
 #           ferrari <- "http://carsalesbase.com/european-car-sales-data/ferrari/",
  #          fiat <- "http://carsalesbase.com/european-car-sales-data/fiat/",
   #         ford <- "http://carsalesbase.com/european-car-sales-data/ford/",
    #        honda <- "http://carsalesbase.com/european-car-sales-data/honda/",
     #       hyundai <- "http://carsalesbase.com/european-car-sales-data/hyundai/",
      #      jaguar <- "http://carsalesbase.com/european-car-sales-data/jaguar/",
       #     jeep <- "http://carsalesbase.com/european-car-sales-data/jeep/",
        #    kia <- "http://carsalesbase.com/european-car-sales-data/kia/",
         #   lancia <- "http://carsalesbase.com/european-car-sales-data/lancia/",
          #  land_rover <- "http://carsalesbase.com/european-car-sales-data/land-rover/",
           # lexus <- "http://carsalesbase.com/european-car-sales-data/lexus/",
  #          maserati <- "http://carsalesbase.com/european-car-sales-data/maserati/",
   #         mercedes <- "http://carsalesbase.com/european-car-sales-data/mercedes-benz/",
    #        mini <- "http://carsalesbase.com/european-car-sales-data/mini/",
     #       mitsubishi <- "http://carsalesbase.com/european-car-sales-data/mitsubishi/",
      #      nissan <- "http://carsalesbase.com/european-car-sales-data/nissan/",
       #     opel <- "http://carsalesbase.com/european-car-sales-data/opel-vauxhall/",
        #    peugeot <- "http://carsalesbase.com/european-car-sales-data/peugeot/",
         #   porsche <- "http://carsalesbase.com/european-car-sales-data/porsche/",
          #  renault <- "http://carsalesbase.com/european-car-sales-data/renault/",
           # saab <- "http://carsalesbase.com/european-car-sales-data/saab/",
            #seat <- "http://carsalesbase.com/european-car-sales-data/seat/",
  #          skoda <- "http://carsalesbase.com/european-car-sales-data/skoda/",
   #         smart <- "http://carsalesbase.com/european-car-sales-data/smart/",
    #        subaru <- "http://carsalesbase.com/european-car-sales-data/subaru/",
     #       suzuki <- "http://carsalesbase.com/european-car-sales-data/suzuki/",
      #      toyota <- "http://carsalesbase.com/european-car-sales-data/toyota/",
       #     volkswagen <- "http://carsalesbase.com/european-car-sales-data/volkswagen/",
        #    volvo <- "http://carsalesbase.com/european-car-sales-data/volvo/")

#znamke2 <- c("Aston Martin", "Audi", "Bentley", "BMW", "Cadillac", "Chrysler", "Citroen",
 #            "Dacia", "Dodge", "Ferrari", "Fiat", "Ford", "Honda", "Hyundai", "Jaguar", "Jeep", "Kia",
  #           "Lancia", "Land Rover", "Lexus", "Maserati", "Mercedes Benz", "Mini", "Mitsubishi", "Nissan",
   #          "Opel", "Peugeot", "Porsche", "Renault", "Saab", "Seat", "Skoda", "Smart", "Subaru", "Suzuki", 
    #         "Toyota", "Volkswagen", "Volvo")


#zdruzena <- data.frame(Znamka = character(), Leto = integer(), St_prodanih = integer(),"Delez_na_trgu(%)" = integer())
#sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")

#for(znamka in 1:length(znamke)) {
#  link <- znamke[znamka]
#  stran <- html_session(link) %>% read_html()
 # tabela1 <- stran %>% html_nodes(xpath="//table[@class='model-table']") %>%
  #  .[[2]] %>% html_table(dec = ",")
  #colnames(tabela1) <- c("Leto", "St_prodanih", "Delez_na_trgu(%)")
  #tabela1 <- tabela1[-c(1),]
#  tabela1$Znamka <- rep(znamke2[znamka],length(tabela1$Leto))
 # tabela1 <- tabela1[order(tabela1$Leto),]
  #tabela1 <- tabela1[c(4,1,2,3)]
  #for (col in c("Leto", "St_prodanih","Delez_na_trgu(%)")) {
   # tabela1[[col]] <- parse_number(tabela1[[col]], na = "-", locale = sl)
  #}
  #zdruzena <- rbind(zdruzena, tabela1)
#}

#View(zdruzena)
#write_csv(zdruzena, "podatki/znamke.csv")

# z interneta sem pobral tabele in jih vse združil
#v eno tabelo in to tabelo shranil v mapo podatki pod imenom znamke.csv

znamke <- read_csv("podatki/znamke.csv", locale = locale(encoding = "cp1250"))








