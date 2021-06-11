# this file deploys the API to the droplet
# again, mostly so i don't forget how to do it

tt_drop <- analogsea::as.droplet("TidyTuesday")
plumberDeploy::do_deploy_api(
  droplet = tt_drop,
  path = "TidyTuesday",
  localPath = ".",
  port = 8002,
  docs = TRUE
)

# NOTE:
#  .Renviron doesn't deploy (i think because it starts with a '.'?)
#  so need to add it at var/plumber/TidyTuesday
#  then reboot with 'sudo reboot now' for changes to take affect
