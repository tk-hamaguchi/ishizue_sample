package 'monit'

if node[:platform_family] == 'rhel'
  if node[:platform] == 'centos' && node[:platform_version].to_i == 7
    template '/etc/monitrc'
  else
    template '/etc/monit.conf'
  end

  remote_file '/etc/monit.d/redis.conf' do
    only_if 'ls /var/run/redis/redis.pid'
  end

  if node[:mariadb] && node[:mariadb][:version].to_i == 10
    template '/etc/monit.d/mariadb.conf' do
      only_if 'ls /var/run/mariadb/mariadb.pid'
    end
  end

  remote_file '/etc/monit.d/nginx.conf' do
    only_if 'ls /var/run/nginx.pid'
  end

  remote_file '/etc/monit.d/sshd.conf' do
    only_if 'ls /var/run/sshd.pid'
  end

  remote_file '/etc/monit.d/munin-node.conf' do
    only_if 'ls /var/run/munin/munin-node.pid'
  end
end



service 'monit' do
  action %i(start enable)
end

