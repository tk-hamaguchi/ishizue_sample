require 'itamae/plugin/resource/firewalld'

include_recipe 'selinux::disabled'
include_recipe '../cookbooks/ntp/default.rb'
include_recipe '../cookbooks/epel/default.rb'
include_recipe '../cookbooks/ssh/default.rb'
include_recipe '../cookbooks/nginx/default.rb'
if node[:platform_family] == 'rhel'
  if node[:mariadb] && node[:mariadb][:version].to_f >= 10.0
    include_recipe "../cookbooks/mariadb#{node[:mariadb][:version]}/default.rb"
  else
    include_recipe '../cookbooks/mariadb/default.rb'
  end
end
include_recipe 'rvm::system'
rvm_install node[:ruby][:version] do
  user 'root'
end

include_recipe '../cookbooks/redis/default.rb'
include_recipe '../cookbooks/munin/default.rb'
include_recipe '../cookbooks/monit/default.rb'
include_recipe '../cookbooks/capistrano_rails_base/default.rb'
include_recipe '../cookbooks/ishizue_sample/default.rb'

