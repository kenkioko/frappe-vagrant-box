# Main SSH Class
class SSH
  def self.configure(config, settings)
    # Allow SSH Agent Forward from The Box
    config.ssh.forward_agent = true

    # Configure Verify Host Key
    if settings.has_key?('verify_host_key')
      config.ssh.verify_host_key = settings['verify_host_key']
    end

    # Override Default SSH port on the host
    if settings.has_key?('default_ssh_port')
      config.vm.network :forwarded_port, guest: 22, host: settings['default_ssh_port'], auto_correct: false, id: "ssh"
    end

    # Configure The Public Key For SSH Access
    if settings.include? 'authorize'
      if File.exist? File.expand_path(settings['authorize'])
        config.vm.provision "setting authorize key", type: "shell" do |s|
          s.inline = "echo $1 | grep -xq \"$1\" /home/vagrant/.ssh/authorized_keys || echo \"\n$1\" | tee -a /home/vagrant/.ssh/authorized_keys"
          s.args = [File.read(File.expand_path(settings['authorize']))]
        end
      end
    end

    # Copy The SSH Private Keys To The Box
    if settings.include? 'keys'
      if settings['keys'].to_s.length.zero?
        puts 'Check your ' + settings['file_name'] + ' file, you have no private key(s) specified.'
        exit
      end
      settings['keys'].each do |key|
        if File.exist? File.expand_path(key)
          config.vm.provision "setting authorize permissions", type: "shell" do |s|
            s.privileged = false
            s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
            s.args = [File.read(File.expand_path(key)), key.split('/').last]
          end
        else
          puts 'Check your ' + settings['file_name'] + ' file, the path to your private key does not exist.'
          exit
        end
      end
    end
  end
end
