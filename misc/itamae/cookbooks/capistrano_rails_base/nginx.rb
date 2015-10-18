execute 'mv /etc/nginx/conf.d/default.conf{,.org}' do
  command 'mv /etc/nginx/conf.d/default.conf{,.org}'
  only_if 'test -e /etc/nginx/conf.d/default.conf'
end
