library(plumber)
library(mongolite)
library(jsonlite)

#* @apiTitle Tidy Tuesday API
#* @apiDescription This is an API to access data sets from the Tidy Tuesday project. For more information about this API, see the [project GitHub](https://github.com/asbates/tidytuesdayapi). You can find out more about Tidy Tuesday on it's [home page](https://github.com/rfordatascience/tidytuesday).
#* @apiVersion 0.0.1

#* @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}

# serves the landing page
#* @assets ./static /
list()

#* Get information about available data sets, like date and description.
#* @param limit Limit the number of results to return.
#* @serializer json
#* @get /available
function(req, res, limit = 10L) {

  limit <- as.integer(limit)

  # if limit is character, as.integer() coerces to NA
  if (is.na(limit)) {
    res$status <- 500
    return(
      list(error = unbox("Limit must be an integer."))
    )
  }

  # 200 ~ 52 weeks * 4 years of data (2018...2021)
  if ( (limit > 0 & limit > 200) | limit < 0) {
    res$status <- 500
    return(
      list(error = unbox("Limit must be between 1 and 200."))
    )
  }

  collection <- mongo(
    collection = "available",
    db = "metadata",
    url = Sys.getenv("DB_CONNECTION_URI")
  )

  available <- collection$find(
    query = '{}',
    fields = '{"_id": false}',
    sort = '{"date": -1}',
    limit = limit
  )
  collection$disconnect()

  available
}

#* Get a data set.
#* @param date The date for the data set in the format 'YYYY-MM-DD'.
#* @serializer json
#* @get /data
function(req, res, date){

  # check the date format
  valid_date <-  grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", date)
  if (!valid_date) {
    res$status <- 500
    return(
      list(error = unbox("That is not a valid date format."))
    )
  }

  fs <- gridfs(
    db = "data",
    url = Sys.getenv("DB_CONNECTION_URI")
  )

  # if no data for that date, fs$read() returns an error, not empty data.frame
  doc <- tryCatch(
    {
      raw_doc <- fs$read(date, progress = FALSE)
      unserialize(raw_doc$data)
    },
    error = function(cond) {
      res$status <- 500
      return(
        list(error = unbox("Data for that date is not available."))
      )
    },
    finally = fs$disconnect()
  )

  doc
}
