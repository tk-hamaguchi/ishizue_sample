namespace :ishizue_sample do
  task upload: %w(upload:check_config_dir upload:database_yml upload:secrets_yml upload:puma_rb upload:sidekiq_yml upload:monit_rc upload:nginx_conf upload:schedule_rb upload:rsyslog_conf upload:application_yml)

  namespace :db do
    task :create do
      on roles(:app) do |host|
        if test("[ `#{fetch(:rvm_path)}/bin/rvm-shell #{fetch(:rvm_ruby_version)} -c 'cd #{release_path} ; RAILS_ENV=#{fetch(:rails_env)} bundle exec rake db:version >/dev/null 2>&1 ; echo $?'` == 1 ]")
          within release_path do
            with rails_env: fetch(:rails_env) do
              execute :rake, 'db:create'
            end
          end
        end
      end
    end
  end

  namespace :upload do
    task :check_config_dir do
      on roles(:app) do |host|
        if test "[ ! -d #{shared_path}/config ]"
          execute :mkdir, "-p #{shared_path}/config"
        end
      end
    end

    task database_yml: %i(check_config_dir) do
      on roles(:app) do |host|
        if test "[ ! -f #{shared_path}/config/database.yml ]"
          upload! 'files/config/database.yml', "#{shared_path}/config/database.yml"
        end
      end
    end

    task secrets_yml: %i(check_config_dir) do
      on roles(:app) do |host|
        if test "[ ! -f #{shared_path}/config/secrets.yml ]"
          upload! 'files/config/secrets.yml', "#{shared_path}/config/secrets.yml"
        else
          upload! 'files/config/secrets.yml', "#{shared_path}/config/secrets.yml.new"
        end
      end
    end

    task puma_rb: %i(check_config_dir) do
      on roles(:app) do |host|
        if test "[ ! -f #{shared_path}/config/puma.rb ]"
          upload! 'files/config/puma.rb', "#{shared_path}/config/puma.rb"
        else
          upload! 'files/config/puma.rb', "#{shared_path}/config/puma.rb.new"
        end
      end
    end

    task sidekiq_yml: %i(check_config_dir) do
      on roles(:app) do |host|
        if test "[ ! -f #{shared_path}/config/sidekiq.yml ]"
          upload! 'files/config/sidekiq.yml', "#{shared_path}/config/sidekiq.yml"
        else
          upload! 'files/config/sidekiq.yml', "#{shared_path}/config/sidekiq.yml.new"
        end
      end
    end

    task schedule_rb: %i(check_config_dir) do
      on roles(:app) do |host|
        template 'templates/schedule.rb', "#{shared_path}/config/schedule.rb"
      end
    end

    task rsyslog_conf: %i(check_config_dir) do
      on roles(:app) do |host|
        if test "[ ! -f #{shared_path}/config/rsyslog.conf ]"
          template 'templates/rsyslog.conf', "#{shared_path}/config/rsyslog.conf"
        else
          template 'templates/rsyslog.conf', "#{shared_path}/config/rsyslog.conf.new"
        end
      end
    end

    task monit_rc: %i(check_config_dir) do
      on roles(:app) do |host|
        if test "[ ! -f #{shared_path}/config/monit.rc ]"
          template 'templates/monit.rc', "#{shared_path}/config/monit.rc"
        else
          template 'templates/monit.rc', "#{shared_path}/config/monit.rc.new"
        end
      end
    end

    task nginx_conf: %i(check_config_dir) do
      on roles(:app) do |host|
        if test "[ ! -f #{shared_path}/config/nginx.conf ]"
          template 'templates/nginx.conf', "#{shared_path}/config/nginx.conf"
        else
          template 'templates/nginx.conf', "#{shared_path}/config/nginx.conf.new"
        end
      end
    end

    task application_yml: %i(check_config_dir) do
      on roles(:app) do |host|
        if test "[ ! -f #{shared_path}/config/application.yml ]"
          template 'templates/config/application.yml', "#{shared_path}/config/application.yml"
        end
      end
    end
  end
end

namespace :deploy do
  task :restart do
    p `curl -i -X POST 'http://admin:monit@192.168.100.100:2812/ishizue_sample' -d 'action=restart' | head -n 1`
  end
end

before 'deploy:check:linked_files', "ishizue_sample:upload"
after 'deploy:finished', 'deploy:restart'
#after 'deploy:restart', 'resque:restart'

before 'deploy:migrate', "ishizue_sample:db:create"
