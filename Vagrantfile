# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

# File with settings variables for Vagrant
confDir = $confDir ||= File.expand_path(File.dirname(__FILE__))
fileName = "Vagrant.yaml"
filePath = confDir + "/" + fileName
scriptsPath = confDir + "/scripts"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "hashicorp/bionic64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = true

  # Configure the Vagrant box using scripts
  # Settings Variables
  settings = YAML::load(File.read(filePath))
  settings['file_name'] = fileName
  settings['script_dir'] = scriptsPath

  # Provision the Vagrant box
  provisionPath = scriptsPath + '/provision'

  require File.expand_path(provisionPath + '/provider.rb')
  require File.expand_path(provisionPath + '/ssh.rb')
  require File.expand_path(provisionPath + '/database.rb')
  require File.expand_path(provisionPath + '/feature.rb')
  require File.expand_path(provisionPath + '/folder.rb')

  # Configure VM Provider
  Provider.configure(config, settings)

  # Configure VM SSH
  SSH.configure(config, settings)

  # Configure Files and Folders
  Folder.configure(config, settings)

  # Configure VM Features
  Feature.configure(config, settings)

  # Configure VM MariaDB
  Database.configure(config, settings)

end
