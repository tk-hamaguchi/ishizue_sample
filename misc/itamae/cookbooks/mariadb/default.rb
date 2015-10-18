%w(mariadb mariadb-server mariadb-devel).each do |pkg|
  package pkg
end

template '/etc/my.cnf.d/server.cnf'

directory '/var/log/mariadb' do
  owner 'mysql'
  group 'mysql'
  mode  '755'
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

service 'mariadb' do
  action %i(start enable)
end

