# this script requires the tm package to run properly
# (it needs a list of stopwords)

# could replace by another text file
text <- scan("adventures_sh.txt", what="character")

# put into one long string
text <- paste(text, collapse=" ")

# remove full stops
text <- gsub("[.]", " ", text)

# remove commas
text <- gsub("[,]", " ", text)

# remove capitals etc.
text <- tolower(text)
words <- strsplit(text, " ")[[1]]
words <- gsub("[\n\";\'!]", " ", words)
words <- gsub("-", " ", words)
words <- gsub("[(+]", " ", words)
words <- gsub("[)+]", " ", words)
words <- gsub("[[+]", " ", words)
words <- gsub("[]+]", " ", words)
words <- gsub("[?]", " ", words)
words <- gsub(":", " ", words)
words <- gsub(" ", "", words)
words <- words[words !="" & words !="\'"]
words[words=="&"] <- "and"
words <- words[-grep("[0-9]", words)]

#words <- words[sapply(words, nchar) >= 4]
tab <- table(words)

barplot(sort(tab[tab < 100 & tab >= 5 & sapply(names(tab), nchar) >= 3]))

tab2 <- sort(tab[tab < 100 & tab >= 5 & sapply(names(tab), nchar) >= 4])

# simple word cloud
N <- length(tab2)
x <- sample((1:N) + 0.5*(runif(N) - 0.5), N)
y <- sample((1:N) + 0.5*(runif(N) - 0.5), N)
plot(x, y, type="n", xaxt="n", yaxt="n", xlab="", ylab="", bty="n")
text(x, y, names(tab2), cex=1.5*sqrt(tab2)/max(sqrt(tab2)), col=grey(1-tab2/max(tab2)))

# Now make a word cloud based on more meaningful distances.
# Find distances between words in tab2
# Note: this step may take a long time
words2 <- names(tab2)
D <- matrix(0, length(words2), length(words2))
for (x in 1:(length(words2)-1)){
  for (y in (x+1):length(words2)){
    wx <- which(words==words2[x])
    wy <- which(words==words2[y])
    D[x,y] <- min(abs(kronecker(wx, wy, FUN="-")))
  }
}

# convert distance matrix to distance object
D_dist <- as.dist(t(log(D+1)))

# scale for making a plot
fit <- cmdscale(D_dist, eig=TRUE, k=2)
require(tm)
a <- which(words2 %in% stopwords('english'))

size <- sqrt(tab2)
m <- min(size)
M <- max(size)

# apply tanh to squash into unit square
plot(tanh(0.5*fit$points[-a,]), type="n", xaxt="n", yaxt="n", xlab="", ylab="", bty="n")
text(tanh(0.5*fit$points[-a,]), names(tab2[-a]), cex=1/(2*(M-m))*size + 
(1-M/(2*(M-m))), 
col=grey(1-tab2/max(tab2)))
