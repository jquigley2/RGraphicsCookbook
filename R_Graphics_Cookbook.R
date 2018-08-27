#http://oreil.ly/R_Graphics_Cookbook
###############################################################
##########Chapter 1: R Basics##########################
###############################################################

#1.1 Installing a package ###############
install.packages(c("ggplot2", "gcookbook"))

#1.2 Loading a package ###############
#The library() function loads a package;  but a library is a set of packages.
library(ggplot2, gcookbook)

#1.3 Loading a delimited text file ###############
data <- read.csv("datafile.csv")
data <- read.csv("R:/MSCI/ESG/Carbon_Metrics//ZipArchive/CarbonMetrics_20180605_explore_v1.xlsx")

#or, if your data doesn't have a header row:
data <- read.csv(datafile.csv, header=FALSE)

#This would leave your data frame with column names V1, V2,... To rename them:
names(data) <- c("Column1", "Column2", "Column3")

#For different delimiters, use "sep".
#For space-delimited files:
data <- read.csv("datafile.csv", sep=" ")

#For tab-delimited files:
data <- read.csv("datafile.csv", sep="\t")

#R assumes all string in the data are factors.
#To prevent this, set stringsAsFactors=FALSE
data <- read.csv("datafile.csv", stringsAsFactors = FALSE)

#To set certain feilds as factors, you can convert them individually:
data$Sex <- factor(data$Sex)

#To check the structure of the data frame, use str():
str(data)

#1.4 Loading an Excel file ###############
#The xlsx package contains the read.xlsx() function, which will read the first sheet of an Excel workbook:
install.packages("xlsx")
library(readxl)
?read_xlsx

data <- read_xlsx("datafile.xlsx", 1)
#Or, reference the second sheet in the workbook...
data <- read_xlsx("datafile.xlsx", sheetIndex=2)
#Or, reference a sheet in the workbook by name...
data <- read_xlsx("datafile.xlsx", sheetName="Revenue")


#For loading an older .xls workbook , the gdata package has the function read.xls():
install.packages("gdata")
library("gdata")
?read.xls

data <- read.xls(datafile.xls)
#Or, call from other sheets by specifying a number:
data <- read.xls(datafile.xls, sheet=2)

###############################################################
##########Chapter 2: Quickly Exploring Data ##########################
###############################################################
#This chapter makes use of base graphics in R rather than ggplot2.  
#It also shows how to make the same plot in gplot() in ggplot2; for each gplot(), there is a similar, more powerful equivlent in ggplot2.


#2.1 Creating a Scatter Plot ###############
#We'll be working with the "mtcars" data frame.  To explore the structure: 
str(mtcars)

#To make a scatter plot in base R:
plot(mtcars$wt, mtcars$mpg)

#With ggplot2 package, we can use:
library(ggplot2)
ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point()
#See Chapter 5 for more on scatter plots

#2.2 Creating a Line Graph ###############

#To make a line graph using plot(), pass vectors for x and y values, and choose type="l" :
plot(pressure$temperature, pressure$pressure, type="l")

#To add points or multiple lines, plot the first line, then add points, then a second line with a different color with lines():
plot(pressure$temperature, pressure$pressure, type="l")
#add points to the line
points(pressure$temperature, pressure$pressure)

#add an additional line
lines(pressure$temperature, pressure$pressure/2, col="red")
points(pressure$temperature, pressure$pressure/2, col="red")

#or, in ggplot2:
qplot(pressure, aes(x=temperature, y=pressure)) + geom_line() + geom_point()

#See Chapter 4 for more on line graphs

#2.3 Creating a Bar Graph ###############
#To make a bar graph, use barplot() and pass a vector of values for bar height and an optional vector for labels.  
#If the vector has names for the elements, it will use those as default labels.

#examine the structure of the BOD data frame
str(BOD) 
#examine top of data frame
head(BOD)

#basic bar plot:
barplot(BOD$demand, names.arg=BOD$Time)

#To generate counts within categories, use the table() function:
table(mtcars$cyl)
#To then turn this into a bar chart, pass it to barplot()
barplot(table(mtcars$cyl))

#assign BOD to the variable y to make for easier coding
y<-BOD

#in ggplot2:
ggplot(data=y, aes(x=Time, y=demand)) +
  geom_bar(stat="identity")

?ggplot
#for a factor:
ggplot(data=mtcars, aes(x=factor(cyl))) + geom_bar()

#See Chapter 3 for more on bar graphs


#2.4 Creating a Histogram ###############
#To create a histogram, pass hist() a vector of values
hist(mtcars$mpg)

#To specify number of bins
hist(mtcars$mpg, breaks=10)

#2 options in ggplot2:
qplot(mtcars$mpg)
#or
ggplot(mtcars, aes(x=mpg)) + geom_histogram(binwidth=4)

#See Chapter 6.1 and 6.2 for more on Histograms

#2.5 Creating a Box Plot ###############
#For comparing distributions
#Pass plot() a vector of x and y values.  When x is a factor, it automatically creates a box plot:
#examine the structure (looking for first 10 in each column)
str(ToothGrowth, 10)
#look at top of file (actually looking at 60 observations)
head(ToothGrowth, 60)

plot(ToothGrowth$supp, ToothGrowth$len)#"supp" is a factor

#If 2 vectors are n the same data frame, we can use formula syntax to combine 2 variables on the x-axis:
boxplot(len ~  dose, data = ToothGrowth)

#Two variables can interact on the x-axis:
boxplot(len ~  supp + dose, data = ToothGrowth)

#In ggplot2:
ggplot(ToothGrowth, aes(x=supp, y=len)) + geom_boxplot()
#with interaction:
ggplot(ToothGrowth, aes(x=interaction(supp, dose), y=len)) + geom_boxplot()

#See Chapter 6.6 for more on box plots

#2.6 Creating a Function Curve ###############
#use curve() and pass it an expression with the variable x:
curve(x^3 - 5*x, from=-4, to=4)

#define a function:
myfun <- function(xvar) {
  1/(1 + exp(-xvar + 10))
} 

#plot it
curve(myfun(x), from = 0, to = 20)
#add a line
curve(1-myfun(x), add = TRUE, col="red")

#In ggplot2:
ggplot(data.frame(x=c(0,20)), aes(x=x)) + stat_function(fun=myfun, geom="line")

#See Chapter 13.2 for more on funtion curves


###############################################################
##########Chapter 3: Bar Graphs ##########################
###############################################################
#Typically used to to display numeric values for different categories 
#Sometimes bar heights represent values , other times they represent counts


#3.1 Making a Basic Bar Graph ###############
#For a data frame where one column represents the x category of each bar, and the other column represents the value.
#Use ggplot() with geom_bar(stat="identity"):
library(gcookbook)

?pg_mean
str(pg_mean)
head(pg_mean)
?ggplot

ggplot(pg_mean, aes(x=group, y=weight)) + geom_bar(stat="identity")


#When x is a continuous variable, there'll be one bar at each possible value between the minimum and maximum:
#(No entry for Time==6)
str(BOD)
ggplot(BOD, aes(x=Time, y=demand)) + geom_bar(stat="identity")

#If we convert category Time to a factor (a discrete categorical value), we only get one bar per Time: 
ggplot(BOD, aes(x=factor(Time), y=demand)) + geom_bar(stat="identity")
#To reorder the levels of a factor based on values of another variable, usee 15.9
#To manually change the order of factor values, see 15.8


#By default, bars are a dark gray.  To change the color fill, use "fill".  
#By default, there is no outline around the fill.  To add an outline, use "color".
ggplot(pg_mean, aes(x=group, y=weight)) + 
  geom_bar(stat="identity", fill="lightblue" , color="black")


#3.2 Grouping Bars Together ###############
#If you have 2 levels of categorical variable 
#To group bars together by a second variable, map a variable to "fill", and use geom_bar(position="dodge") 
?cabbage_exp
str(cabbage_exp)
head(cabbage_exp)

#Map Date to the x position and map Cultivar to the fill color.
#Using position="dodge" tells the bars to dodge each other horix=zontally, rather than stacking (see 3.7 for stacked bars)
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) + 
  geom_bar(position="dodge", stat="identity")
#Variables mapped to "fill" must be categorical rather than continuous.

#To add an outline color, use color="black inside geom_bar():
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) + 
  geom_bar(position="dodge", color="black", stat="identity")

#To change the color palette, use either scale_fill_brewer() or scale_fill_manual():
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) + 
  geom_bar(position="dodge", color="black", stat="identity") +
  scale_fill_brewer(palette = "Pastel1")

#If one of the categories has no values, it will not be included, and the adjacent bar will expand to take its space.
#To avoid this, you can add an "NW" as the Y value.


#3.3 Making a Bar Graph of Counts ###############

#Use geom_bar() without mapping anything to y:
?diamonds
str(diamonds)
head(diamonds)

ggplot(diamonds, aes(x=cut)) + geom_bar()
#equivalent to using geom_bar(stat="bin")

#If we use a continuous variable on the x-axis, we'd get a histogram:
ggplot(diamonds, aes(x=carat)) + geom_bar()

#For more on histograms, see Recipe 6.1

#3.4 Using Colors in a Bar Graph ###############
#To use different colors, map the appropriate variable to the "fill" aesthetic.
#We use uspopchange for this example:
?uspopchange
str(uspopchange)
head(uspopchange)

#Take the 10 fastest-growing states:
library(gcookbook)
upc <- subset(uspopchange, rank(Change)>40) 
upc

#Graph by mapping Region to fill:
ggplot(upc, aes(x=Abb, y=Change, fill=Region)) + geom_bar(stat="identity")

#Since these colors aren't great, we may want to change by using scale_fill_brewer() or scale_fill_manual(). 
ggplot(upc, aes(x=Abb, y=Change, fill=Region)) + 
  geom_bar(stat="identity") +
  scale_fill_manual(values=c("#669933", "#FFCC66"))

#Re-order from high growth to low: 
?reorder
ggplot(upc, aes(x=reorder(Abb, Change), y=Change, fill=Region)) + 
  geom_bar(stat="identity") +
  scale_fill_manual(values=c("#669933", "#FFCC66"))
#More on re-order in Recipe 15.9


#Change X-axis label to "State":
ggplot(upc, aes(x=reorder(Abb, Change), y=Change, fill=Region)) + 
  geom_bar(stat="identity") +
  scale_fill_manual(values=c("#669933", "#FFCC66")) + 
  xlab("State")

#Add black outlines:
ggplot(upc, aes(x=reorder(Abb, Change), y=Change, fill=Region)) + 
  geom_bar(stat="identity", color="black") +
  scale_fill_manual(values=c("#669933", "#FFCC66")) + 
  xlab("State")
#Note that "settings" occur outside of aes(), while "mapping" occurs within aes()

#More on colors in Chapter 12.


#3.5 Coloring Negative and Positive Bars Differently ###############
#using a subset of the climate data, create a new column called pos, which indicates whether the value is positive or negative:
?climate
str(climate)
head(climate, 10)
tail(climate, 10)

#Create subset where Source = Berkeley and Year >=1990:
csub <- subset(climate, Source=="Berkeley" & Year >= 1900)

csub

#Create a column pos, which indicates TRUE if Anomaly10y is positive, else FALSE
csub$pos <- csub$Anomaly10y >=0

csub$pos

#Now we can map pos to the fill color:
ggplot(csub, aes(x=Year, y=Anomaly10y, fill=pos)) +
  geom_bar(stat="identity", position = "identity")

#The colors seem backward: blue should mean cold, red should mean hot.
ggplot(csub, aes(x=Year, y=Anomaly10y, fill=pos)) +
  geom_bar(stat="identity", position = "identity") +
  scale_fill_manual(values=c("#CCEEFF", "#FFDDDD"))

#Remove the legend with guide=FALSE:
ggplot(csub, aes(x=Year, y=Anomaly10y, fill=pos)) +
  geom_bar(stat="identity", position = "identity") +
  scale_fill_manual(values=c("#CCEEFF", "#FFDDDD"), guide=FALSE)

#Now add black outlines to the bars and specify the width of these outlines:
ggplot(csub, aes(x=Year, y=Anomaly10y, fill=pos)) +
  geom_bar(stat="identity", position = "identity", color="black", size=0.25) +
  scale_fill_manual(values=c("#CCEEFF", "#FFDDDD"), guide=FALSE)


#3.6 Adjusting Bar Width and Spacing ###############
#To make bars narrower or wider, set the "width" in geom_bar.  The default value is 0.9:

#For standard width bars:
ggplot(pg_mean, aes(x=group, y=weight)) +
  geom_bar(stat="identity")

#For narrower bars:
ggplot(pg_mean, aes(x=group, y=weight)) +
  geom_bar(stat="identity", width = 0.5)

#For wider bars (max width is 1):
ggplot(pg_mean, aes(x=group, y=weight)) +
  geom_bar(stat="identity", width = 1)

#For grouped bars, the default is to have no space between bars within a group.
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) +
  geom_bar(stat="identity", width = 0.5, position="dodge")
#To add space in between, make width smaller and set position dodge value > width:
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) +
  geom_bar(stat="identity", width = 0.5, position=position_dodge(0.7))
#The first instance used position="dodge", which is shorthand for position=position_dodge(), the default.


#3.7 Making a Stacked Bar Graph ###############
#Use geom_bar() and map a variable to fill (omitting position="dodge" results in stcking)
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) +
  geom_bar(stat="identity")

cabbage_exp
#Three levels of date, and two levels of Cultivar.  For each of these 6 there's a Weight.
#To reverse the default legend order, use guides(): 
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) +
  geom_bar(stat="identity") +
  guides(fill=guide_legend(reverse=TRUE))

#To reverse the stacking order, specify 0rder=desc() in the aesthetic mapping:
library(plyr) #needed for desc()

ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar, order=desc(Cultivar))) +
  geom_bar(stat="identity")

#Polish the appearance with new color palette and added outlines:
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar, order=desc(Cultivar))) +
  geom_bar(stat="identity", color="black") +
  guides(fill=guide_legend(reverse=FALSE) +
           scale_fill_brewer(palette=("Pastel4"))
         
         
         #3.8 Making a Proportional Stacked Bar Graph ###############
         #For showing proportions within a category.
         #First, scale the data to 100% within each category, using transform() from ddply()
         
         #Do a group-wise transform, splitting on "Date":
         ?ddply
         
         ce <- ddply(cabbage_exp, "Date", transform,
                     percent_weight = Weight/sum(Weight)*100)
         
         #Check result:
         ce
         
         #Plot proportional bar graph
         ggplot(ce, aes(x=Date, y=percent_weight, fill=Cultivar)) +
           geom_bar(stat="identity")
         
         #Change the color palette and add an outline:
         ggplot(ce, aes(x=Date, y=percent_weight, fill=Cultivar)) +
           geom_bar(stat="identity", color="black") +
           scale_fill_brewer(palette=("Pastel2"))
         
         
         #3.9 Adding Labels to a Bar Graph ###############
         #Add "geom_text" to the graph.
         #Must map to x, y, and itself.
         #Use "vjust" - vertical justification - to move teh text above or below the top of the bars:
         
         #Below the top:
         ggplot(cabbage_exp, aes(x=interaction(Date, Cultivar), y=Weight)) +
           geom_bar(stat="identity") +
           geom_text(aes(label=Weight), vjust=1.5, color="white") #select which variable to label, and at what height above the top of the bar.
         #Negative "vjust" moves the label higher.  vjust=o leaves the label just atop the bar.
         
         #Above the top:
         ggplot(cabbage_exp, aes(x=interaction(Date, Cultivar), y=Weight)) +
           geom_bar(stat="identity") +
           geom_text(aes(label=Weight), vjust=-0.2)
         
         #Sometimes, labels atop the bar can be cut off at the top.  One way to handle this is by adjusting the y limits higher: 
         ggplot(cabbage_exp, aes(x=interaction(Date, Cultivar), y=Weight)) +
           geom_bar(stat="identity") +
           geom_text(aes(label=Weight), vjust=-0.2) +
           ylim(0, max(cabbage_exp$Weight) * 1.05) #increase the y-axis automatically
         
         #Or, dynamically map the label just above the y bar:
         ggplot(cabbage_exp, aes(x=interaction(Date, Cultivar), y=Weight)) +
           geom_bar(stat="identity") +
           geom_text(aes(y=Weight + 0.1, label=Weight))
         
         #For labeling grouped bar graphs, you must specify position=position_dodge() and give it a value for dodging width.
         #Because the bars are narrower, we may need ot use "size" to make the font smaller.  The default size is 5.
         ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) +
           geom_bar(stat="identity", position="dodge") +
           geom_text(aes(label=Weight), vjust=1.5, color="white",
                     position=position_dodge(0.9), size=4)
         
         
         #For labeling stacked bar graphs, we must find the cumulative sum for each stack.
         #First, make sur ethe data is sorted properly using "arrange()" from plyr package:
         library(plyr)
         
         cabbage_exp
         
         ce <- arrange(cabbage_exp, Date, desc(Cultivar)) #order by Date then Cultivar
         
         ce
         
         #Once sorted, use ddply() to chunk it into groups by Date, then calculate a cumulative weight within each group:
         ce <-  ddply(ce, "Date", transform, label_y=cumsum(Weight))
         
         ce
         
         ggplot(ce, aes(x=Date, y=Weight, fill=Cultivar)) +
           geom_bar(stat="identity") +
           geom_text(aes(y=label_y, label=Weight), vjust=1.5, colour="white")
         
         
         #3.10 Making a Cleveland Dot Plot ###############
         #Cleeland dot plots reduce visual clutter and can be easier to read.
         #Use "geom_point()" to create a dot plot.
         
         #In this example, we're sourcing data from the tophitters2001 data frame:
         ?tophitters2001
         #source: http://www.baseball-databank.org/.
         str(tophitters2001)
         head(tophitters2001, 25)
         
         #Take top 25 from tophitters2001 data set:
         tophit <- tophitters2001[1:25, ]
         
         tophit
         
         ggplot(tophit, aes(x=avg, y=name)) +
           geom_point()
         
         #Let's look at 3 columns:
         tophit[, c("name", "lg","avg" )]
         
         #First plot was sorted descending by player name.*  Dot plots are often sorted by the continuous variable on the x-axis.
         #The items on a given access will be ordered however is appropriate for that data type; in this case, name is text therefore alphabetically.
         #We want the y-axis to instead be sorted by avg.
         #To do this, use reorder(name, avg) to take the name column, turn it into a factor and sort by avg:
         ggplot(tophit, aes(x=avg, y=reorder(name, avg))) +
           geom_point()
         
         #To improve the appearance, remove the grid system..
         ggplot(tophit, aes(x=avg, y=reorder(name, avg))) +
           geom_point() +
           theme_bw() + #set appearance to black and white theme
           theme(panel.grid.major.x = element_blank(), #delete major x gridlines
                 panel.grid.minor.x = element_blank(), #delete minor x gridlines
                 panel.grid.major.y = element_line(color = "grey60", linetype = "dashed")) #for dashed y lines
         
         #We can also swap the x and y axes:
         ggplot(tophit, aes(x=reorder(name, avg), y=avg)) + #switch x and y
           geom_point(size = 3) + #use a larger dot
           theme_bw() +
           theme(panel.grid.major.y = element_blank(), #delete major y gridlines
                 panel.grid.minor.y = element_blank(), #delete minor y gridlines
                 panel.grid.major.x = element_line(color = "grey60", linetype = "dashed")) #for dashed x lines
         #Can't read the names; rotate them 60 degrees:
         ggplot(tophit, aes(x=reorder(name, avg), y=avg)) + #switch x and y
           geom_point(size = 3) + #use a larger dot
           theme_bw() +
           theme(axis.text.x = element_text(angle=60, hjust=1),
                 panel.grid.major.y = element_blank(), #delete major y gridlines
                 panel.grid.minor.y = element_blank(), #delete minor y gridlines
                 panel.grid.major.x = element_line(color = "grey60", linetype = "dashed")) #for dashed x lines
         
         #We'll often want to sort items by another variable.  Here we want to sort first by lg (league), then by average.
         #The reorrder() function will only reorder factor levels by one variable; for two or more, we must resort manually:
         nameorder <- tophit$name[order(tophit$lg, tophit$avg)]
         
         nameorder
         
         #Turn name into a factor, with levels in the order of nameorder:
         tophit$name <- factor(tophit$name, levels=nameorder)
         
         #Map lg to the color of the points:
         ggplot(tophit, aes(x=avg, y=name)) +
           geom_segment(aes(yend=name), xend=0, color="grey50") + #makes the lines go up only to the points
           geom_point(size=3, aes(color=lg)) + #maps lg to color
           scale_color_brewer(palette="Set1", limits=c("NL", "AL")) +
           theme_bw() + #set appearance to black and white theme
           theme(panel.grid.major.y = element_blank(), #delete major horizontal gridlines
                 legend.position=c(1, 0.55), #put legend inside plot area
                 legend.justification=c(1,0.5)) #pulls legend further left
         
         #Another way to separate is via facets
         ggplot(tophit, aes(x=avg, y=name)) +
           geom_segment(aes(yend=name), xend=0, color="grey50") + #makes the lines go up only to the points
           geom_point(size=3, aes(color=lg)) + #maps lg to color
           scale_color_brewer(palette="Set1", limits=c("NL", "AL"), guide=FALSE) +
           theme_bw() + #set appearance to black and white theme
           theme(panel.grid.major.y = element_blank()) + #delete major horizontal gridlines
           facet_grid(lg ~ ., scales="free_y", space = "free_y") #facet on lg, scale shared across y , space per graph determined by y     
         
         #For details:
         ?facet_grid()
         
         
         
         ###############################################################
         ##########Chapter 4: Line Graphs ##########################
         ###############################################################
         # 
         #
         
         
         
         #4.1  Making a Basic Line Graph ###############
         #4.2  Adding Points to a Line Graph ###############
         #4.3  Making a Line Graph with Multiple Lines ###############
         #4.4  Changing the Appearance of Lines ###############
         #4.5  Changing the Appearance of Ponts ###############
         #4.6  Making a Graph with a Shaded Area ###############
         #4.7  Making a Stacked Area Graph ###############
         #4.8  Making a Proportional Stcked Area Graph ###############
         #4.9  Adding a Confidence Region ###############
         
         
         
         ###############################################################
         ##########Chapter 5:  ##########################
         ###############################################################
         # 
         #
         