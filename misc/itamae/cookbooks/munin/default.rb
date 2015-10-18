package 'munin'
package 'munin-node'

remote_file '/etc/nginx/conf.d/munin.conf' do
  notifies  :restart, 'service[nginx]'
end

include_recipe File.expand_path('../nginx.rb', __FILE__)
include_recipe File.expand_path('../mariadb.rb', __FILE__)
include_recipe File.expand_path('../redis.rb', __FILE__)

service 'munin-node' do
  action %i(start enable)
end

