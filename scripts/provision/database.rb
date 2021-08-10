# Main Database Class
class Database
  def self.configure(config, settings)
    # Configure Database Scripts Location
    db_script_dir = settings['script_dir'] + '/database'
    settings['db_root_pwd'] = settings['db_root_pwd'] ||= 'secret'

    # Install MariaDB
    config.vm.provision 'shell' do |s|
      s.name = 'Installing MariaDB Database'
      s.path = db_script_dir + '/install.sh'
      s.args = [settings['db_root_pwd']]
    end

    # Configure All Of The Configured Databases
    if settings.has_key?('databases')
      settings['databases'].each do |db|
        config.vm.provision 'shell' do |s|
          s.name = 'Creating MariaDB Database: ' + db
          s.path = db_script_dir + '/create.sh'
          s.args = [db]
        end
      end
    end
  end
end
