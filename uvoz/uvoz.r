# 2. faza: Uvoz podatkov

preciscena_teza <- function() {
  stolpci <- c("Leto", "Drzava", "Teza", "Enota", "Vrednost", "Fla")
  teza <- read_csv("podatki/teza.csv", locale=locale(encoding="cp1250"),
                   col_names = stolpci, skip=1, na=c(":", ""," ", "-"))
  teza$Fla <- NULL
  teza$Enota <- NULL
  teza <- teza[c(2,1,3,4)]
  teza <- teza %>% filter(Vrednost != "NA", Leto >= "2000")
  #teza <- teza %>% drop_na()
  #anglesko <- c("Less than 1 000 kg", "From 1 000 to 1 249 kg", "From 1 250 to 1 499 kg", "1 500 kg or over")
  #slovensko <- c("Manj kot 1000 kg", "1000-1249 kg", "1250-1499 kg", "1500 kg in več")
  #tab1 <- data.frame(ang=anglesko, Enote=slovensko)
  #tab1$Enote <- as.character(tab1$Enote)
  #tab1$ang <- as.character(tab1$ang)
  #zdruzena <- teza %>% inner_join(tab1, c("Teza"="Enote"))
}
teza <- preciscena_teza()

preciscena_starost <- function() {
  starost <- read_csv("podatki/starost.csv", locale = locale(encoding="cp1250"), na=c("", " ", "-", ":"))
  starost <- starost %>% select(Drzava = GEO,Leto = TIME,Starost = AGE,Vrednost = Value) %>%
    filter(Vrednost != "NA", Leto >= "2000")
  
}
starost <- preciscena_starost()

preciscene_emisije <- function() {
  emisije <- read_csv2("podatki/emisije_CO2.csv", locale = locale(encoding = "cp1250"),
                       na=c(""," ",":","-"), skip = 2, n_max=33)
  emisije <- gather(emisije, "2000", "2001", "2002", "2003", "2004", "2005", "2006","2007", "2008",
                    "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", key = "Leto", value = "Gram_CO2_na_km")
  emisije <- emisije %>% select(Drzava = "geo\\time", Leto, Gram_CO2_na_km) %>% filter(Gram_CO2_na_km != "NA")
  emisije$Leto <- as.integer(emisije$Leto)
}
emisije <- preciscene_emisije()

st_na_1000_prebivalcev <- function() {
  st_na_1000_prebivalcev <- read_csv("podatki/st_na_1000_prebivalcev.csv", locale = locale(encoding = "cp1250"),
                                     na=c(""," ","-",":"))
  st_na_1000_prebivalcev <- st_na_1000_prebivalcev %>% select(Drzava = GEO, Leto = TIME, Stevilo = Value) %>%
    filter(Stevilo != "NA", Leto >= "2000")
}
st_avtomobilov_na_1000_prebivalcev <- st_na_1000_prebivalcev()

nove_registracije <- function() {
  registracije <- read_csv("podatki/nove_registracije_glede_na_tezo.csv", locale = locale(encoding = "cp1250"),
                           na = c(""," ",":","-"))
  registracije <- registracije %>% select(Drzava = GEO, Leto = TIME, Teza = WEIGHT, Vrednost = Value) %>%
    filter(Vrednost != "NA", Leto >= 2000, Teza != "Total")
}
registracije <- nove_registracije()

goriva <- function() {
  dizel_bencin <- read_csv("podatki/dizel_in_bencin.csv", locale = locale(encoding = "cp1250"),
                           na=c(""," ","-",":"))
  ostala_goriva <- read_csv("podatki/ostala_goriva.csv", locale = locale(encoding = "cp1250"),
                            na=c(""," ","-",":"))
  dizel_bencin <- dizel_bencin %>% select(Leto = TIME, Drzava = GEO, Vrsta_goriva = PROD_NRG, Stevilo=Value) %>%
    filter(Stevilo != "NA", Leto >= 2000)
  d
  ostala_goriva <- ostala_goriva %>% select(Leto = TIME, Drzava = GEO, Vrsta_goriva = PROD_NRG, Stevilo = Value) %>%
    filter(Leto >= 2000, Stevilo != "NA")
  ostala_goriva$Stevilo <- ostala_goriva$Stevilo * 1000
  zdruzena <- rbind(ostala_goriva, dizel_bencin)
}
goriva <- goriva()

velikost_motorja <- function() {
  tabela <- read_csv("podatki/velikost_motorja.csv", locale = locale(encoding = "cp1250"), 
                     na=c(""," ",":","-"))
  tabela <- tabela %>% select(Drzava = GEO, Leto =TIME, Vrsta_goriva = PROD_NRG, Motor = ENGINE, Vrednost = Value) %>%
    filter(Leto >= 2000, Vrednost != "NA") 
  tabela$Vrsta_goriva <- gsub("All Petroleum Products", "Bencin", tabela$Vrsta_goriva)
  tabela$Vrsta_goriva <- gsub("Diesel", "Dizel", tabela$Vrsta_goriva)
}

uvozi_alfa <- function() {
  link <- "http://carsalesbase.com/european-car-sales-data/alfa-romeo/"
  stran <- html_session(link) %>% read_html()
  tabela1 <- stran %>% html_nodes(xpath="//table[@class='model-table']") %>%
    .[[2]] %>% html_table(dec = ",")
  colnames(tabela1) <- c("Leto", "St.prodanih","Delez.na.trgu(%)")
  tabela1 <- tabela1[-c(1),]
  tabela1$Znamka <- rep(c("Alfa Romeo"),length(tabela1$Leto))
  tabela1 <- tabela1[order(tabela1$Leto),]
  tabela1 <- tabela1[c(4,1,2,3)]
  sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")
  for (col in c("Leto", "St.prodanih","Delez.na.trgu(%)")) {
    tabela1[[col]] <- parse_number(tabela1[[col]], na = "-", locale = sl)
  }
  return(tabela1)
}
znamke <- c(alfa_romeo <- "http://carsalesbase.com/european-car-sales-data/alfa-romeo/",
            aston_martin <- "http://carsalesbase.com/european-car-sales-data/aston-martin/",
            audi <- "http://carsalesbase.com/european-car-sales-data/audi/",
            bentley <- "http://carsalesbase.com/european-car-sales-data/bentley/",
            bmw <- "http://carsalesbase.com/european-car-sales-data/bmw/",
            bugatti <- "http://carsalesbase.com/european-car-sales-data/bugatti/",
            cadillac <- "http://carsalesbase.com/european-car-sales-data/cadillac/",
            chrysler <- "http://carsalesbase.com/european-car-sales-data/chrysler/",
            citroen <- "http://carsalesbase.com/european-car-sales-data/citroen/",
            dacia <- "http://carsalesbase.com/european-car-sales-data/dacia/",
            dodge <- "http://carsalesbase.com/european-car-sales-data/dodge/",
            ferrari <- "http://carsalesbase.com/european-car-sales-data/ferrari/",
            fiat <- "http://carsalesbase.com/european-car-sales-data/fiat/",
            ford <- "http://carsalesbase.com/european-car-sales-data/ford/",
            honda <- "http://carsalesbase.com/european-car-sales-data/honda/",
            hyundai <- "http://carsalesbase.com/european-car-sales-data/hyundai/",
            infiniti <- "http://carsalesbase.com/european-car-sales-data/infiniti/",
            jaguar <- "http://carsalesbase.com/european-car-sales-data/jaguar/",
            jeep <- "http://carsalesbase.com/european-car-sales-data/jeep/",
            kia <- "http://carsalesbase.com/european-car-sales-data/kia/",
            lamborghini <- "http://carsalesbase.com/european-car-sales-data/lamborghini/",
            lancia <- "http://carsalesbase.com/european-car-sales-data/lancia/",
            land_rover <- "http://carsalesbase.com/european-car-sales-data/land-rover/",
            lexus <- "http://carsalesbase.com/european-car-sales-data/lexus/",
            lotus <- "http://carsalesbase.com/european-car-sales-data/lotus/",
            maserati <- "http://carsalesbase.com/european-car-sales-data/maserati/",
            mercedes <- "http://carsalesbase.com/european-car-sales-data/mercedes-benz/",
            mini <- "http://carsalesbase.com/european-car-sales-data/mini/",
            mitsubishi <- "http://carsalesbase.com/european-car-sales-data/mitsubishi/",
            nissan <- "http://carsalesbase.com/european-car-sales-data/nissan/",
            opel <- "http://carsalesbase.com/european-car-sales-data/opel-vauxhall/",
            peugeot <- "http://carsalesbase.com/european-car-sales-data/peugeot/",
            porsche <- "http://carsalesbase.com/european-car-sales-data/porsche/",
            renault <- "http://carsalesbase.com/european-car-sales-data/renault/",
            saab <- "http://carsalesbase.com/european-car-sales-data/saab/",
            seat <- "http://carsalesbase.com/european-car-sales-data/seat/",
            skoda <- "http://carsalesbase.com/european-car-sales-data/skoda/",
            smart <- "http://carsalesbase.com/european-car-sales-data/smart/",
            subaru <- "http://carsalesbase.com/european-car-sales-data/subaru/",
            suzuki <- "http://carsalesbase.com/european-car-sales-data/suzuki/",
            toyota <- "http://carsalesbase.com/european-car-sales-data/toyota/",
            volkswagen <- "http://carsalesbase.com/european-car-sales-data/volkswagen/",
            volvo <- "http://carsalesbase.com/european-car-sales-data/volvo/")

uvoz_znamke <- function() {
  for(i in 1:length(znamke)){
    link <- znamke[i]
    stran <- html_session(link) %>% read_html()
    tabela1 <- stran %>% html_nodes(xpath="//table[@class='model-table']") %>%
      .[[2]] %>% html_table(dec = ",")
    colnames(tabela1) <- c("Leto", "St_prodanih","Delez_na_trgu(%)")
    tabela1 <- tabela1[-c(1),]
    tabela1$Znamka <- rep(c("Alfa Romeo"),length(tabela1$Leto))
  }
}





