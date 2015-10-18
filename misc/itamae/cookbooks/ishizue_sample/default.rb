require 'securerandom'

@dbpass = SecureRandom.hex(16)

case node[:platform]
when 'redhat', 'fedora', 'centos'
  package 'avahi-compat-libdns_sd-devel'
when 'debian', 'ubuntu'
  package 'libavahi-compat-libdnssd-dev'
end

execute 'create_database' do
  user 'root'
  not_if 'mysql -u root -e "show databases" | grep ishizue_sample'
  command <<-"EOL"
    mysql -u root -e "CREATE USER 'rails'@'127.0.0.1' IDENTIFIED BY '#{@dbpass}';"
    mysql -u root -e "CREATE DATABASE ishizue_sample;"
    mysql -u root -e "GRANT ALL PRIVILEGES ON ishizue_sample.* TO 'rails'@'127.0.0.1';"
    mysql -u root -e "FLUSH PRIVILEGES;"
  EOL
end

local_ruby_block 'cap deploy:check' do
  block do
    Itamae.logger.info `cd ../capistrano && cap staging deploy:check`
  end
end

file '/var/rails/ishizue_sample/shared/config/application.yml' do
  action :edit
  block do |content|
    content.concat <<-"EOS".gsub(/^ +\|/,'')
      |DATABASE_URL:    mysql2://rails:#{@dbpass}@127.0.0.1/ishizue_sample?encoding=utf8
      |SECRET_KEY_BASE: #{SecureRandom.hex(64)}
    EOS
  end
  not_if 'ls /var/rails/ishizue_sample/shared/config/application.yml'
end

local_ruby_block 'cap deploy' do
  block do
    Itamae.logger.info `cd ../capistrano && cap staging deploy`
  end
end

remote_file '/etc/nginx/conf.d/monitor.conf'
remote_file '/var/www/html/index.html'

execute 'cp /var/rails/ishizue_sample/shared/config/nginx.conf /etc/nginx/conf.d/ishizue_sample.conf' do
  notifies  :restart, 'service[nginx]'
end

execute 'cp /var/rails/ishizue_sample/shared/config/rsyslog.conf /etc/rsyslog.d/ishizue_sample.conf' do
  only_if 'ls /etc/rsyslog.d'
end

service 'rsyslog' do
  action :restart
  only_if 'ls /etc/rsyslog.d'
end

execute 'cp /var/rails/ishizue_sample/shared/config/monit.rc /etc/monit.d/ishizue_sample.conf' do
  only_if 'ls /etc/monit.d'
  notifies :restart, 'service[monit]'
end

if node[:platform] == 'centos' && node[:platform_version].to_i == 7
  service 'firewalld' do
    action [:start, :enable]
  end

  firewalld_zone 'public' do
    interfaces node[:network][:interfaces].keys - ['lo']
    services   %w(dhcpv6-client http ssh)
    ports      %w(8282/tcp)
    default_zone true
  end

  service 'firewalld' do
    action [:restart]
  end
end
