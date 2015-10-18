%w(perl-IPC-ShareLite perl-Cache-Cache perl-DBD-MySQL).each do |name|
  package name
end

link '/etc/munin/plugins/mysql_commands' do
  to '/usr/share/munin/plugins/mysql_'
end

link '/etc/munin/plugins/mysql_innodb_bpool' do
  to '/usr/share/munin/plugins/mysql_'
end

link '/etc/munin/plugins/mysql_innodb_io' do
  to '/usr/share/munin/plugins/mysql_'
end

link '/etc/munin/plugins/mysql_innodb_log' do
  to '/usr/share/munin/plugins/mysql_'
end

link '/etc/munin/plugins/mysql_innodb_tnx' do
  to '/usr/share/munin/plugins/mysql_'
end

link '/etc/munin/plugins/mysql_select_types' do
  to '/usr/share/munin/plugins/mysql_'
end

link '/etc/munin/plugins/mysql_table_locks' do
  to '/usr/share/munin/plugins/mysql_'
end

link '/etc/munin/plugins/mysql_connections' do
  to '/usr/share/munin/plugins/mysql_'
end

link '/etc/munin/plugins/mysql_slow' do
  to '/usr/share/munin/plugins/mysql_'
end

link '/etc/munin/plugins/mysql_myisam_indexes' do
  to '/usr/share/munin/plugins/mysql_'
end

link '/etc/munin/plugins/mysql_network_traffic' do
  to '/usr/share/munin/plugins/mysql_'
end

link '/etc/munin/plugins/mysql_qcache' do
  to '/usr/share/munin/plugins/mysql_'
end

link '/etc/munin/plugins/mysql_qcache_mem' do
  to '/usr/share/munin/plugins/mysql_'
end

file '/etc/munin/plugin-conf.d/munin-node' do
  action :edit
  block do |content|
    content.concat <<-"EOS".gsub(/^ +\|/,'')
      |
      |[mysql*]
      |env.mysqlopts -u root
      |env.mysqladmin /usr/bin/mysqladmin
      |env.mysqlconnection DBI:mysql:mysql;host=127.0.0.1;port=3306
      |env.mysqluser root
      |#env.mysqlpassword ''
    EOS
  end
  not_if 'grep "DBI:mysql:mysql" /etc/munin/plugin-conf.d/munin-node'
end

