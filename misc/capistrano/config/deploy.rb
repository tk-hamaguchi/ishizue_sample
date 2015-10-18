# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'ishizue_sample'
set :repo_url, 'git@example.com:me/my_repo.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/rails/#{fetch(:application)}"

# Default value for :scm is :git
set :scm, :copy
set :tar_verbose, false
set :include_dir, '../../'
set :exclude_dir, %w(files Capfile ../../.git ../../tmp ../../log ../../spec archive.tar.gz)

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/schedule.rb', 'config/application.yml', 'config/puma.rb')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :rvm_type, :system
set :rvm_ruby_version, '2.2.3@ishizue_sample'
set :rvm_roles, [:app, :web, :resque_worker, :resque_scheduler]

set :workers, { fetch(:application) => 2 }
set :resque_pid_path, -> { File.join(shared_path, 'tmp', 'pids') }


namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

SSHKit.config.umask = '002'

set :templating_paths, ['./']

