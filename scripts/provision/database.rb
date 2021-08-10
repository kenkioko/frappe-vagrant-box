# Main Database Class
class Database
  def self.configure(config, settings)
    # Configure Database Scripts Location
    db_script_dir = settings['script_dir'] + '/database'
    settings['db_root_pwd'] = settings['db_root_pwd'] ||= 'secret'
    default_user = {
      "user" => 'root',
      "password" => settings['db_root_pwd']
    }

    # Install MariaDB
    config.vm.provision 'shell' do |s|
      s.name = 'Installing MariaDB Database'
      s.path = db_script_dir + '/install.sh'
      s.args = [settings['db_root_pwd']]
    end

    # Configure MariaDB Users
    if settings.has_key?('db_users')
      settings['db_users'].each do |db_user|
        config.vm.provision 'shell' do |s|
          s.name = "Creating MariaDB User: #{db_user}"
          s.path = db_script_dir + '/create_user.sh'
          s.args = [settings['db_root_pwd'], db_user['user'], db_user['password']]
        end

        if db_user.has_key?('is_default') && db_user['is_default']
          default_user['user'] = db_user['user']
          default_user['password'] = db_user['password']
        end
      end
    end

    # Configure MariaDB Default Login User
    config.vm.provision 'shell' do |s|
      s.name = "Configure Default User '#{default_user['user']}' To Connect MariaDB"
      s.path = db_script_dir + '/default_user.sh'
      s.args = [default_user['user'], default_user['password']]
    end

    # Configure All Of The Configured Databases
    if settings.has_key?('databases')
      settings['databases'].each do |db|
        config.vm.provision 'shell' do |s|
          s.name = "Creating MariaDB Database: #{db}"
          s.path = db_script_dir + '/create_db.sh'
          s.args = [db]
        end
      end
    end
  end
end
