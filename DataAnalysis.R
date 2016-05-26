# Data Analysis

# ether invested into the DAO by days
invPerDay <- tDAO %>% group_by(monthDay) %>% summarise(value = sum(value)) %>% mutate(cumValue=cumsum(value))
ggplot(invPerDay, aes(x = monthDay, y = value))+geom_bar(stat="identity")+geom_vline(xintercept = c(15,25))

# cumulative plot of investment over time (cumulative transaction volume)
cumInv <- tDAO %>% transmute(ts=ts,cumValue=cumsum(value))
ggplot(cumInv, aes(x = ts, y = cumValue))+
  geom_vline(xintercept = c(as.numeric(as.POSIXct("2016-05-15 10:00:00"))))+
  geom_vline(xintercept = c(as.numeric(as.POSIXct("2016-05-25 10:00:00"))))+
  scale_x_datetime(labels = date_format("%m/%d"), date_breaks = "1 day") + 
  geom_line()

# wealth distribution
contributors <- tDAO %>% group_by(from)  %>% summarise(value = sum(value), nContributions=n())
top10Contributors <- tail(contributors[order(contributors$value),],10)
top100Contributors <- tail(contributors[order(contributors$value),],100)

top10Transactors <- tail(contributors[order(contributors$nContributions),],10)
top100Transactors <- tail(contributors[order(contributors$nContributions),],100)

ggplot(top10Contributors, aes(x=from, y=value))+geom_bar(stat="identity")
# TODO: create wealth distribution diagram like https://plot.ly/~CoreyPetty/59/percentage-vs-investor-group

# some values
allEther <- sum(tDAO$value) # all ether in TheDAO
numberOfTransactions <- nrow(tDAO) # number of Transactions going into TheDAO
uniqueContributors <- length(unique(tDAO$from)) # number of unique addresses that contribute to TheDAO

# descriptive stats
summary(tDAO$value)
boxplot(tDAO$value)

# Origin
# Prozent aus Genesis, aus Mining, aus Exchanges
origin <- contributors %>% filter(from %in% knownWallets$addr) %>% mutate(owner=knownWallets$owner, perc = value/allEther)