# 4. faza: Analiza podatkov

p <- teza %>% filter(Drzava == "Finland", Teza == "1000-1249 kg")

h <- ggplot(p, aes(x=Leto, y=St_avtomobilov)) + geom_point()

mls <- loess(data = p, St_avtomobilov ~ Leto)
h + geom_smooth(method = "loess")
mgam <- gam(data = p, St_avtomobilov ~ s(Leto))
h + geom_smooth(method = "gam", formula = y ~ s(x))

prihodnost <- data.frame(Leto=c(2018,2019,2020))
View(prihodnost)
predict(mgam, prihodnost)
napoved <- prihodnost %>% mutate(St_avtomobilov=predict(mgam, .))
View(napoved)
