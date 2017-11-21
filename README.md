# Analiza podatkov s programom R, 2017/18

Avtor: Jaka Munda

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2017/18

## Avtomobilizem v Evropi

Pri projektu bom obravnaval značilnosti avtomobilov v Evropi in kako so se te spreminjale skozi čas. Prav tako bom pogledal kako se je spreminjala razširjenost avtomobilov in katere so bile najbol razširjene znamke v Evropi.

Vira:
- http://ec.europa.eu/eurostat
- http://carsalesbase.com/european-car-sales-data/

Tabele:

Registracije:

- 1.stolpec: Države
- 2.stolpec: Leto
- 3.stolpec: Teža
- 4.stolpec: Število novih registracij

Teža avtomobilov:

- 1.stolpec: Države
- 2.stolpec: Leto
- 3.stolpec: Teža
- 4.stolpec: Število

Starost avtomobilov:

- 1.stolpec: Države
- 2.stolpec: Leto
- 3.stolpec: Starost
- 4.stolpec: Število

Emisije CO2 novih avtomobilov:

- 1.stolpec: Države
- 2.stolpec: Leto
- 3.stolpec: Gram CO2 na km

Število avtomobilov na 1000 prebivalcev:

- 1.stolpec: Države
- 2.stolpec: Leto
- 3.stolpec: Število

Katere avtomobilske znamke so najbol razširjene:

- 1.stolpec: Avtomobilska znamka
- 2.stolpec: leto
- 3.stolpec: Število prodanih avtomobilov

V projektu želim ugotoviti, v katerem obdobju se je zgodila največja rast avtomobilizma v Evropi ter poskusiti napovedati kakšna bo ta rast v prihodnjih letih. Prav tako bom poskusil ugotoviti kakšne značilnosti na avtomobilih so najbolj razširjene, in kakšne značilnosti bodo v prihodnosti najbolj razširjene.

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
