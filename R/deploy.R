# this file deploys the API to the droplet
# again, mostly so i don't forget how to do it

tt_drop <- analogsea::as.droplet("TidyTuesday")
plumberDeploy::do_deploy_api(
  droplet = tt_drop,
  path = "api",
  localPath = ".",
  port = Sys.getenv("PORT"),
  forward = TRUE
)

# NOTES:
# 1. .Renviron doesn't deploy (i think because it starts with a '.'?)
#  so need to add it at var/plumber/api
# 2. plumber has a bug where if serving static files at /, docs give a 404
#  so for now, set docs=FALSE (default). later, can add if desired
#  see plumber PR #748
# 3. forward=TRUE points requests for / to /api, where this project
#  lives. didn't have that at first. so this is a reminder of why
#  see https://community.rstudio.com/t/what-does-plumberdeploy-do-forward-do/107304
# 4. see ?plumberDeploy::do_provision() Details for how to
#  a. restart plumber: systemctl restart plumber-api
#  b. see plumber logs: journalctl -u plumber-api
#     logs from last 5 minutes: journalctl -u plumber-api -S -5m
