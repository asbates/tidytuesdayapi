# this file has functions for inserting data into the database

library(mongolite)
library(tidytuesdayR)
library(jsonlite)


insert_data <- function(date) {

  # tt_load returns a specially classed object
  # remove all the extra bits, keeping the name(s) of the data set(s)
  tt_data <- tt_load(date)
  tt_data_nm <- names(tt_data)
  attributes(tt_data) <- NULL
  names(tt_data) <- tt_data_nm

  doc <- list(
    date = unbox(date),
    data = tt_data
  )
  raw_doc <- serialize(doc, NULL)

  fs <- gridfs(
    db = "data",
    url = Sys.getenv("DB_CONNECTION_URI")
  )
  fs$write(raw_doc, date)
  fs$disconnect()

}


insert_metadata <- function(date,
                            description,
                            url,
                            source_url,
                            article_url) {

  doc <- list(
    date = unbox(date),
    description = unbox(description),
    url = unbox(url),
    sourceURL = unbox(source_url),
    articleUrl = unbox(article_url)
  )

  collection <- mongo(
    collection = "available",
    db = "metadata",
    url = Sys.getenv("DB_CONNECTION_URI")
  )
  collection$insert(doc)
  collection$disconnect()

}

insert_data("2021-06-22")

insert_metadata(
  date = "2021-06-22",
  description = "Public Park Access",
  url = "https://github.com/rfordatascience/tidytuesday/tree/master/data/2021/2021-06-22",
  source_url = "https://www.tpl.org/parks-and-an-equitable-recovery-parkscore-report",
  article_url = "https://www.bloomberg.com/news/articles/2021-05-27/the-cities-where-people-of-color-can-walk-to-a-park"
)
