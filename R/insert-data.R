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

insert_data("2021-01-05")

insert_metadata(
  date = "2021-01-05",
  description = "Transit Cost Project",
  url = "https://github.com/rfordatascience/tidytuesday/tree/master/data/2021/2021-01-05",
  source_url = "https://transitcosts.com/",
  article_url = "https://transitcosts.com/city/boston-case-the-story-of-the-green-line-extension/"
)
