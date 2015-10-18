
link '/etc/munin/plugins/nginx_request' do
  to '/usr/share/munin/plugins/nginx_request'
end

link '/etc/munin/plugins/nginx_status' do
  to '/usr/share/munin/plugins/nginx_status'
end

file '/etc/munin/plugin-conf.d/munin-node' do
  action :edit
  block do |content|
    content.concat <<-"EOS".gsub(/^ +\|/,'')
      |
      |[nginx*]
      |env.url http://127.0.0.1:8080/nginx_status
    EOS
  end
  not_if 'grep "nginx_status" /etc/munin/plugin-conf.d/munin-node'
end

