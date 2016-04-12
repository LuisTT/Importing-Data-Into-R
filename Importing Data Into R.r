### Importing Data Into R

### Importing Data form Flat Files

# read.table

# Import the hotdogs.txt file: hotdogs
hotdogs = read.table(path,header = FALSE,sep = "\t", col.names=c("type","calories","sodium"))

read.csv

# Import swimming_pools.csv correctly, without factors: pools
pools=read.csv("swimming_pools.csv",stringsAsFactors=FALSE)

read.delim

# Load in the hotdogs data set: hotdogs
hotdogs=read.delim ("hotdogs.txt",header=FALSE,sep="\t",col.names=c("type","calories","sodium"))

## readr and data.table packages

# read_csv

properties <- c("area", "temp", "size", "storage", "method", 
                "texture", "flavor", "moistness")

# Import potatoes.csv with read_csv(): potatoes
potatoes=read_csv("potatoes.csv",col_names=properties)

# read_tsv

# The collectors you will need to import the data
fac <- col_factor(levels = c("Beef", "Meat", "Poultry"))
int <- col_integer()

# Edit the col_types argument to import the data correctly: hotdogs_factor
hotdogs_factor <- read_tsv("hotdogs.txt", 
                           col_names = c("type", "calories", "sodium"),
                           # Change col_types to the correct vector of collectors
                           col_types = list(fac,int,int))
						   
# fread 

# Import columns 6, 7 and 8 of potatoes.txt: potatoes
potatoes=fread("potatoes.txt",select = c(6, 7, 8))


### Importing data from Excel

## The readxl package

# Read all Excel sheets with lapply(): lat_list
lat_list = lapply(excel_sheets("latitude.xlsx"),read_excel,path="latitude.xlsx")

# Import the the first Excel sheet of latitude_nonames.xlsx (R gives names): latitude_3
latitude_3 = read_excel("latitude_nonames.xlsx", col_names = FALSE)
  
# Import the the second Excel sheet of latitude_nonames.xlsx (specify col_names): latitude_4
latitude_4 = read_excel("latitude_nonames.xlsx", sheet=2,col_names=c("country", "latitude"))

## The gdata package

# Import data from the second sheet; skip the first 50 rows: urban_pop
urban_pop <- read.xls("urbanpop.xls", sheet = 2, skip = 50, header = FALSE, stringsAsFactors = FALSE)

# Column names for urban_pop
columns <- c("country", paste0("year_", 1967:1974))

# Name the columns of urban_pop
names(urban_pop) <- columns

# Sort the data frame in descending urban population in 1974: urban_pop_sorted
urban_pop_sorted <- urban_pop[order(urban_pop$year_1974, decreasing = TRUE), ]

## The XLConnect package

# Build connection to latitude.xlsx
library(XLConnect)
my_book <- loadWorkbook("latitude.xlsx")

# List the sheets in latitude.xlsx
getSheets(my_book)

# Import the second sheet in latitude.xlsx
readWorksheet(my_book,sheet="1900")

# Import the second column of the first sheet in latitude.xlsx
readWorksheet(my_book,sheet="1700",startCol=2)

## Add and populate excel worksheets

# Build connection to latitude.xlsx
library(XLConnect)
my_book <- loadWorkbook("latitude.xlsx")

# Create data frame: summ
dims1 <- dim(readWorksheet(my_book, 1))
dims2 <- dim(readWorksheet(my_book, 2))
summ <- data.frame(sheets = getSheets(my_book), 
                   nrows = c(dims1[1], dims2[1]), 
                   ncols = c(dims1[2], dims2[2]))

# Add a worksheet to my_book, named "data_summary"
createSheet(my_book,"data_summary")

# Populate "data_summary" with summ data frame
writeWorksheet(my_book, summ, "data_summary")

# Save workbook as latitude_with_summ.xlsx
saveWorkbook(my_book, "latitude_with_summ.xlsx")


### Importing data from other statistical software & haven

## Import SAS data with haven package

# Import sales.sas7bdat: sales
sales = read_sas("sales.sas7bdat")

## Import STATA data with haven package

# Import the data from the URL: sugar
sugar <- read_dta("http://assets.datacamp.com/course/importing_data_into_r/trade.dta")

## Import SPSS data with haven package

# Specify the file path using file.path(): path
path = file.path("datasets","person.sav")

# Import person.sav, which is in the datasets folder: traits
traits = read_sav (path)

## The foreign package

# Specify the file path using file.path(): path
path = file.path("worldbank","edequality.dta")

# Create and print structure of edu_equal_1
edu_equal_1 = read.dta(path)
str(edu_equal_1)

# Create and print structure of edu_equal_2
edu_equal_2 = read.dta(path,convert.factors=FALSE)
str(edu_equal_2)


# Create and print structure of edu_equal_3
edu_equal_3 = read.dta(path,convert.underscore=TRUE)
str(edu_equal_3)

# Import international.sav as demo_2
demo_2 = read.spss ("international.sav",to.data.frame=TRUE,use.value.labels=FALSE)


### Import from a relational database

## RMySQL Package

# Load the DBI package
library(DBI)

# Connect to the MySQL database: con
con = dbConnect (RMySQL::MySQL(),
        dbname = "tweater",
        host = "courses.csrrinzqubik.us-east-1.rds.amazonaws.com",
        port=3306,
        user="student",
        password="datacamp")
		
# Import the users,tweats and comments table from tweater
users = dbReadTable(con,"users")
tweats = dbReadTable(con,"tweats")
comments = dbReadTable(con,"comments")

## SQL Queries from inside R

# Import post column of tweats where date is higher than "2015-09-21": latest
latest <- dbGetQuery(con, "SELECT post FROM tweats WHERE date > \"2015-09-21\"")

# Import tweat_id column of comments where user_id is 1: elisabeth
elisabeth <- dbGetQuery(con, "SELECT tweat_id FROM comments WHERE user_id = 1")

# Create data frame specific = dbGetQuery ()
specific = dbGetQuery (con,"SELECT message
                                FROM comments
                                    WHERE tweat_id = 77 AND user_id > 4")

# Create data frame short
short = dbGetQuery (con,"SELECT id, name
                                FROM users
                                    WHERE CHAR_LENGTH(name) < 5")

## Detailed method
									
# Send query to the database with dbSendQuery(): res
res = dbSendQuery (con, "SELECT * FROM comments WHERE user_id > 4")

# Display information contained in res
dbGetInfo(res)

# Use dbFetch() 
dbFetch(res)

# Clear res
dbClearResult(res)


### Importing data from the web

## readr package

# Import the csv file: pools
url_csv <- "http://s3.amazonaws.com/assets.datacamp.com/course/importing_data_into_r/swimming_pools.csv"
pools = read_csv(url_csv)

# Import the txt file: potatoes
url_delim <- "http://s3.amazonaws.com/assets.datacamp.com/course/importing_data_into_r/potatoes.txt"
potatoes = read_tsv (url_delim)

## readr and gdata packages

# Specification of url: url_xls
url_xls <- "http://s3.amazonaws.com/assets.datacamp.com/course/importing_data_into_r/latitude.xls"

# Import the .xls file with gdata: excel_gdata
excel_gdata = read.xls (url_xls)

# Download file behind URL, name it local_latitude.xls
download.file(url_xls,"local_latitude.xls")

# Import the local .xls file with readxl: excel_readxl
excel_readxl = read_excel ("local_latitude.xls")

## Other option

# https URL to the wine RData file.
url_rdata <- "https://s3.amazonaws.com/assets.datacamp.com/course/importing_data_into_r/wine.RData"

# Download the wine file to your working directory
download.file(url_rdata,"wine_local.RData")

# Load the wine data into your workspace using load()
load("wine_local.RData")

# Print out the summary of the wine data
summary(wine)

## httr package

# Get the url, save response to resp
url <- "http://docs.datacamp.com/teach/"
resp=GET(url)

# Print resp
resp

# Get the raw content of resp
raw_content = content(resp,as = "raw")

# Print the head of content
head(raw_content)