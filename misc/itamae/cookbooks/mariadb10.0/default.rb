execute 'rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB'
template '/etc/yum.repos.d/MariaDB.repo'

%w(MariaDB-server MariaDB-devel MariaDB-client).each do |pkg|
  package pkg
end

template '/etc/my.cnf.d/server.cnf'

directory '/var/log/mariadb' do
  owner 'mysql'
  group 'mysql'
  mode  '755'
end

directory '/var/run/mariadb/' do
  owner 'mysql'
  group 'mysql'
  mode  '755'
end

directory '/var/lib/mariadb' do
  owner 'mysql'
  group 'mysql'
  mode  '755'
end

execute 'mysql_install_db' do
  not_if 'ls /var/lib/mariadb/mysql'
end

execute 'chown mysql. -R /var/lib/mariadb/'

service 'mysql' do
  action %i(start enable)
end

execute 'mysql_secure_installation' do
  user 'root'
  only_if 'mysql -u root -e "show databases" | grep test'
  command <<-"EOL"
    mysql -u root -e "DELETE FROM mysql.user WHERE User='';"
    mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');"
    mysql -u root -e "DROP DATABASE test;"
    mysql -u root -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    mysql -u root -e "FLUSH PRIVILEGES;"
  EOL
end

