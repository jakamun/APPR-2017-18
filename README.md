# Analiza podatkov s programom R, 2017/18

Avtor: Jaka Munda

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2017/18

## Avtomobilizem v Evropi

V projektu bom obravnaval značilnosti avtomobilov v Evropi in kako so se te spreminjale skozi čas. Prav tako bom pogledal kako se je spreminjala razširjenost avtomobilov in katere so najbol razširjene znamke v Evropi. Z eurostata bom v csv obliki uvozil podatke o značilnostih avtomobilov v Evropi. Z druge spletne strani(HTML), ki je navedena med viri, pa bom uvozil podatke o tem katere avtomobilske znamke prodajo največ avtomobilov.

Vira:
- http://ec.europa.eu/eurostat
- http://carsalesbase.com/european-car-sales-data/

Tabele:

Velikost motorja:

- 1.stolpec: Država
- 2.stolpec: Leto
- 3.stolpec: Vrsta goriva
- 4.stolpec: Velikost motorja
- 5.stolpec: Število

Teža avtomobilov:

- 1.stolpec: Država
- 2.stolpec: Leto
- 3.stolpec: Teža
- 4.stolpec: Število

Vrste goriv:
- 1.stolpec: Država
- 2.stolpec: Leto
- 3.stolpec: Vrsta goriva
- 4.stolpec: Število 

Starost avtomobilov:

- 1.stolpec: Država
- 2.stolpec: Leto
- 3.stolpec: Starost
- 4.stolpec: Število

Emisije CO2 novih avtomobilov:

- 1.stolpec: Država
- 2.stolpec: Leto
- 3.stolpec: Gram CO2 na km

Število avtomobilov na 1000 prebivalcev:

- 1.stolpec: Država
- 2.stolpec: Leto
- 3.stolpec: Število

Katere avtomobilske znamke so najbol razširjene:

- 1.stolpec: Avtomobilska znamka
- 2.stolpec: Leto
- 3.stolpec: Število prodanih avtomobilov
- 4.stolpec: Delež na trgu

Plan dela:

V projektu bom pogledal kakšne značilnosti avtomobilov so v posameznih državah in napovedal kašne bodo te značilnosti v prihodnjih letih. Gledal bom v katerih državah vozijo bolj nove avtomobile in v katerih bolj stare, ter napovedal trend za prihodnja leta. Gledal bom tudi kakšne vrste goriv uporabljajo v posameznih državah, ter napovedal katera goriva se bodo v prihodnosti najbol uporabljala. Isto bom storil tudi za težo osebnega vozila. Analiziral bom še katere avtomobilske znamke prodajo največ avtomobilov in napovedal kakšne bo trend v prihodnjih letih.

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
