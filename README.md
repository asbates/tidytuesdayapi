# tidytuesdayapi

**NOTE** 
This project is no longer deployed.
There wasn't much usage so I figured I'd save the $5/month.

This is a web API for the 
 [Tidy Tuesday](https://github.com/rfordatascience/tidytuesday) project.
Tidy Tuesday is a "weekly data project aimed at the R ecosystem."
Each week a new data set is released and participants practice their data
 science skills.

This project offers access to the Tidy Tuesday data sets through a web API.
R users may be interested in the package 
 [tidytuesdayR](https://cran.r-project.org/web/packages/tidytuesdayR/index.html)
 which provides an R interface to the data sets as well as other helpful 
 information.
The aim of this project is to provide an alternative interface so users of
 any language can easily access the data.

## Usage

The url for this api is `https://tidytuesdayapi.com/api/`.
There are 2 endpoints, both of them accepting `GET` requests.

- `/available` - Gets information about available data sets, like date and
 a brief description.
    - parameter: `limit` - specifies how many weeks of information to retrieve.
     Defaults to 10.
- `/data` - Gets a data set.
    - parameter: `date` - the date corresponding to the data set you want to
     retrieve.
     Must be in the format `YYYY-MM-DD`.
     
As an example, in R we could get information about the latest 10 weeks of
 data sets with.
```r
library(httr)
library(jsonlite)

res <- GET("https://tidytuesdayapi.com/api/available")
content <- content(res, as = "text")
info <- fromJSON(content)
```
`info` will be a data frame containing the relevant information.
Once we find an interesting data set, we can pull in the data.
If we wanted to look at Mario Kart world records, we could do
```r
mk_res <- GET("https://tidytuesdayapi.com/api/data?date=2021-05-25")
mk_content <- content(mk_res, as = "text")
mk <- fromJSON(mk_content)
```
`mk` will be a list with components `date` and `data`.
There are 2 data sets for this week, which we can access with
```r
drivers <- mk$data$drivers
records <- mk$data$records
```
Both `drivers` and `records` will be data frames.

Since this is a web API though, we are not limited to using R.
For an example of how to use this API from JavaScript, you can check out
 [this Observable notebook](https://observablehq.com/@asbates/tidy-tuesday-api-example).
If you would like to see an example of using the API in another language, let
 me know.
Even better, submit a pull request!
 
## Notes

There are a few things I would like to note.
First, I'm making this API available for free, but there are some costs 
 associated with it.
So **please be mindful of your usage**.

There are a lot of data sets in the Tidy Tuesday project.
To start, I've just added 2021 data and will update as new data sets are
 released.
I will probably add older data sets but I'm not in a hurry to do so.
I will however add more data if requested.

Finally, I would like to note that I am open to feedback and/or requests.
If you find this project helpful, I would love to hear about it!
Likewise, if you have suggestions for improvement or want a specific data set
 added, feel free to open an issue.

