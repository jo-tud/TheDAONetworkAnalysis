## This is the starting point

## Requirements:
# install.packages("devtools","rgexf", dependencies=T)
# package deps on fedora: openssl_devel libcurl-devel gmp-devel mpfr-devel libxml2-devel
# devtools::install_github("BSDStudios/ethr")

library(lattice)
library(ggplot2)
library(dplyr)
library(scales)

# Read the blockchain data into dataframe t. This may take a while.
source("readBlockhainData.R")

# Load the function for exporting as a gephi gexf file.
source("saveAsGEXF.R")

# some constants
TheDAOAddr = '0xbb9bc244d798123fde783fcc1c72d3bb8c189413'
daoCreation = strptime("2016-04-30 01:42:58 UTC",format="%Y-%m-%d %H:%M:%S UTC",tz = "UTC") # see https://etherchain.org/tx/0xe9ebfecc2fa10100db51a4408d18193b3ac504584b51a4e55bdef1318f0a30f9
daoConversionStart = strptime("2016-04-30 10:00:00 UTC",format="%Y-%m-%d %H:%M:%S UTC",tz = "UTC")
daoConversionEnd = strptime("2016-05-27 10:00:00 UTC",format="%Y-%m-%d %H:%M:%S UTC",tz = "UTC")

# Known wallets
knownWallets <- read.table(text = " addr owner
1   0x32be343b94f860124dc4fee278fdcbd38c102d88     poloniex 
2   0x2910543af39aba0cd09dbb2d50200b3e800a63d2     kraken 
3   0x40b9b889a21ff1534d018d71dc406122ebcf3f5a     gatecoin 
",header = TRUE,sep = "",colClasses = c("addr"="character", "owner"="character"))

# Transactions around TheDAO
tDAO <- t[t$to==TheDAOAddr,] # contains transactions that go to TheDAO
tDAO_l2 <- subset(t, t$to %in% tDAO$from) # contains transactions that had adresses from tDAO as a target
tDAO_l3 <- subset(t, t$to %in% tDAO_l2$from) # contains transactions that had dresses from tDAO_l2 as a target

# Create an igraph object g
source("CreateGraph.R")
