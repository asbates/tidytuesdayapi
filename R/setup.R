# this file sets up the DO droplet (server)
# mostly this is just here to remind me how i did it

# only needs to be done once. basically just follow the plumberDeploy readme
analogsea::account()

tt_drop <- plumberDeploy::do_provision(example = FALSE,
                            region = "sfo3",
                            name = "TidyTuesday")

analogsea::debian_apt_get_install(tt_drop, "libsasl2-dev") # for mongolite
analogsea::install_r_package(tt_drop, "mongolite")


# set domain name and https (when have a domain)
?plumberDeploy::do_configure_https()
