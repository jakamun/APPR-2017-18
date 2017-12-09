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


sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")

# Funkcija, ki uvozi občine iz Wikipedije
uvozi.obcine <- function() {
  link <- "http://sl.wikipedia.org/wiki/Seznam_ob%C4%8Din_v_Sloveniji"
  stran <- html_session(link) %>% read_html()
  tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
    .[[1]] %>% html_table(dec = ",")
  for (i in 1:ncol(tabela)) {
    if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }
  colnames(tabela) <- c("obcina", "povrsina", "prebivalci", "gostota", "naselja",
                        "ustanovitev", "pokrajina", "regija", "odcepitev")
  tabela$obcina <- gsub("Slovenskih", "Slov.", tabela$obcina)
  tabela$obcina[tabela$obcina == "Kanal ob Soči"] <- "Kanal"
  tabela$obcina[tabela$obcina == "Loški potok"] <- "Loški Potok"
  for (col in c("povrsina", "prebivalci", "gostota", "naselja", "ustanovitev")) {
    tabela[[col]] <- parse_number(tabela[[col]], na = "-", locale = sl)
  }
  for (col in c("obcina", "pokrajina", "regija")) {
    tabela[[col]] <- factor(tabela[[col]])
  }
  return(tabela)
}

# Funkcija, ki uvozi podatke iz datoteke druzine.csv
uvozi.druzine <- function(obcine) {
  data <- read_csv2("podatki/druzine.csv", col_names = c("obcina", 1:4),
                    locale = locale(encoding = "Windows-1250"))
  data$obcina <- data$obcina %>% strapplyc("^([^/]*)") %>% unlist() %>%
    strapplyc("([^ ]+)") %>% sapply(paste, collapse = " ") %>% unlist()
  data$obcina[data$obcina == "Sveti Jurij"] <- "Sveti Jurij ob Ščavnici"
  data <- data %>% melt(id.vars = "obcina", variable.name = "velikost.druzine",
                        value.name = "stevilo.druzin")
  data$velikost.druzine <- parse_number(data$velikost.druzine)
  data$obcina <- factor(data$obcina, levels = obcine)
  return(data)
}

# Zapišimo podatke v razpredelnico obcine
obcine <- uvozi.obcine()

# Zapišimo podatke v razpredelnico druzine.
druzine <- uvozi.druzine(levels(obcine$obcina))

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.
