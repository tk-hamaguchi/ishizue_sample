#el6用のリポジトリがバグってるっぽい。el7を入れようとして失敗する。
if node[:platform] == 'centos' && node[:platform_version].to_i >=7
  package "http://nginx.org/packages/#{node[:platform]}/#{node[:platform_version].to_i}/noarch/RPMS/nginx-release-#{node[:platform]}-#{node[:platform_version].to_i}-0.el#{node[:platform_version].to_i}.ngx.noarch.rpm" do
    not_if 'nginx -v'
  end
end

package 'nginx'

template '/etc/nginx/nginx.conf' do
  mode '0644'
end

remote_file '/etc/nginx/conf.d/server_status.conf' do
  mode '0644'
end

service 'nginx' do
  action %i(start enable)
end
