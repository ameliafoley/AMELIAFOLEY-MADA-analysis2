###############################
# Analysis script
#
# #This script analyzes the processed vaccine exemption dataset and 
# graphs the results. It also answers the questions posted on the processeddata
# script

#load needed packages. make sure they are installed.
library(ggplot2) #for plotting
library(broom) #for cleaning up output from lm()
library(here) #for data loading/saving
library(tidyverse) #for data manipulation and graphing

#path to data
#note the use of the here() package and not absolute paths
data_location <- here::here("data","processed_data","processeddata.rds")

#load data. 
df <- readRDS(data_location)

######################################
#Data exploration/description
######################################

#summarize data 
mysummary = summary(df)

#look at summary
print(mysummary)

#do the same, but with a bit of trickery to get things into the 
#shape of a data frame (for easier saving/showing in manuscript)
summary_df = data.frame(do.call(cbind, lapply(mydata, summary)))

#save data frame table to file for later use in manuscript
summarytable_file = here("results", "summarytable.rds")
saveRDS(summary_df, file = summarytable_file)


######################################
#Data Manipulation and Graphing
######################################
#This section is to manipulate the data and graph it in order to answer 
#the questions posted on the processing script





####### Q1: What is the most common type of exemption? #####################

dfQ1 <- aggregate(Number.of.Exemptions ~ Dose, 
                  data = df, sum)
#This created a data frame that calculates the total number of exemptions by type
#over all years and states

plotQ1 <- ggplot(data = dfQ1, aes(x = Dose, y = Number.of.Exemptions, fill = Dose)) +
           geom_bar(stat = "identity") +
           ggtitle("Total Number of Exemptions by Type") +
           ylab("Total Number of Exemptions") +
           xlab("Type of Exemption")
plotQ1
#"Any Exemption" is the most common type of exemption


#Saving the figure

Figure1 = here("results","Plot1.png")
ggsave(filename = Figure1, plot=plotQ1) 




############Q2: What state(s) have the highest rate of exemptions? #################

dfQ2 <- aggregate(Number.of.Exemptions ~ Geography,
                  data = df, sum)
#This created a data frame that calculates the total number of exemptions by state
#over all years

plotQ2 <- ggplot(data = dfQ2, aes(x = Geography, y = Number.of.Exemptions)) +
         geom_point() +
         theme(axis.text.x = element_text(angle = 90)) +
         ggtitle("Total Number of Exemptions by State") +
         ylab("Total Number of Exemptions") +
         xlab("State")
plotQ2
#California has the highest total number of exemptions

#Saving the figure
Figure2 = here("results","Plot2.png")
ggsave(filename = Figure2, plot=plotQ2) 





#Q3: How do different rates of different types of exemptions vary ############
#among states? ###############################################################

dfQ3 <- aggregate(Number.of.Exemptions ~ Dose + Geography,
                  data = df, sum)

plotQ3 <- ggplot(data = dfQ3, aes(x = Geography, y = Number.of.Exemptions, color = Dose)) +
            geom_point() +
            facet_wrap(~ Dose) +
            theme(axis.text.x = element_text(angle = 90, size = 3)) +
            ggtitle("Total Number of Exemptions by State and Type") +
            ylab("Total Number of Exemptions") +
            xlab("State")
plotQ3
#Saving the figure
Figure3 = here("results","Plot3.png")
ggsave(filename = Figure3, plot=plotQ3) 




###############Q4: How have exemption rates changed over time? #############################

dfQ4 <- aggregate(Number.of.Exemptions ~ School.Year,
                  data = df, sum)

plotQ4 <- ggplot(data = dfQ4, aes(x = School.Year, y = Number.of.Exemptions)) +
                geom_point() +
                ggtitle("Total Number of Exemptions by School Year") +
                ylab("Total Number of Exemptions") +
                xlab("School Year")
plotQ4

#It looks like the total number of exemptions rose dramatically from 2011-12 to 
#2013-14, stabilized for a bit until 2016-17, and then has continued to rise from there

#Saving the figure
Figure4 = here("results","Plot4.png")
ggsave(filename = Figure4, plot=plotQ4) 



