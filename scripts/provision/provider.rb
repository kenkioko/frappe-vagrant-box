# Main Provider Class
class Provider
  def self.configure(config, settings)
    # Default Settings Variables
    ############################
    ENV['VAGRANT_DEFAULT_PROVIDER'] = settings['provider'] ||= 'virtualbox'
    settings['name'] = settings['name'] ||= 'vagrant'
    settings['memory'] = settings['memory'] ||= 1024
    settings['cpus'] = settings['cpus'] ||= 1
    settings['gui'] = settings['gui'] ||= false
    settings['ip'] = settings['ip'] ||= '192.168.10.10'
    settings['hostname'] = settings['hostname'] ||= 'vagrant'


    # Configure The Box
    ###################
    config.vm.define settings['name']
    config.vm.hostname = settings['hostname']


    # Configure Network Ip
    ######################

    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # config.vm.network "public_network"

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    config.vm.network "private_network", ip: settings['ip']


    # Configure Port Forwarding
    ###########################

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    # NOTE: This will enable public access to the opened port
    # config.vm.network "forwarded_port", guest: 80, host: 8080

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine and only allow access
    # via 127.0.0.1 to disable public access
    # config.vm.network "forwarded_port", guest: 8000, host: 8000, host_ip: settings['ip']

    # Add Custom Ports From Configuration
    if settings.has_key?('ports')
      settings['ports'].each do |port|
        config.vm.network 'forwarded_port', guest: port['guest'], host: port['host'], protocol: port['protocol'], auto_correct: true
      end
    end


    # Set The VM Provider
    #####################
    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    # Example for VirtualBox:
    #
    # View the documentation for the provider you are using for more
    # information on available options.

    # Configure A Few VirtualBox Settings
    config.vm.provider "virtualbox" do |vb|
      vb.name = settings['name']
      vb.memory = settings['memory']
      vb.cpus = settings['cpus']
      vb.gui = settings['gui']
    end

    # Configure A Few VMware Settings
    ['vmware_fusion', 'vmware_workstation', 'vmware_desktop'].each do |vmware|
      config.vm.provider vmware do |v|
        v.vmx['displayName'] = settings['name']
        v.vmx['memsize'] = settings['memory']
        v.vmx['numvcpus'] = settings['cpus']
        v.gui = settings['gui']
      end
    end

    # Configure A Few Hyper-V Settings
    config.vm.provider "hyperv" do |h, override|
      h.vmname = settings['name']
      h.cpus = settings['cpus']
      h.memory = settings['memory']
      h.linked_clone = true
    end

    # Configure A Few Parallels Settings
    config.vm.provider 'parallels' do |v|
      v.name = settings['name']
      v.memory = settings['memory']
      v.cpus = settings['cpus']
    end
  end
end
