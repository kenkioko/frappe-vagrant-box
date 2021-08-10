# Main Feature Class
class Feature
  def self.configure(config, settings)
    # Install opt-in features
    if settings.has_key?('features')
      # Update Apt
      config.vm.provision "shell", name: "Update apt sources",  inline: <<-SHELL
        apt-get update
      SHELL

      settings['features'].each do |feature|
        # Enable provisioning with a shell script. Additional provisioners such as
        # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
        # documentation for more information about their specific syntax and use.

        feature_name = feature['name']
        feature_path = settings['script_dir'] + "/features/" + feature_name + ".sh"

        # Check if feature really exists
        if !File.exist? File.expand_path(feature_path)
          config.vm.provision "shell", inline: "echo Invalid feature: #{feature_name} \n"
          next
        end

        # provision feature
        config.vm.provision "shell" do |s|
          s.name = "Installing " + feature_name
          s.path = feature_path
        end

        # feature is enabled as a service
        if feature.has_key?('service')
          feature_service = feature['service']
          service_name = feature_service['name'] ||= feature_name

          # enable service on boot
          if feature_service.has_key?('enabled') && feature_service['enabled']
            config.vm.provision "shell", name:"Enabling service #{service_name}", inline: <<-SHELL
              systemctl start #{service_name}
              systemctl enable #{service_name}
            SHELL
          end
        end

        # end provision service
        config.vm.provision "shell", inline: "echo Finishing feature: #{feature_name} \n"

      end
    end
  end
end
