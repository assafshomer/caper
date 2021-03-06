# config valid only for current version of Capistrano
lock '3.4.0'
set :application, 'caper'
set :deploy_user, 'deploy'

# Default value for :scm is :git
# set :scm, :git
set :repo_url, 'git@github.com:assafshomer/caper.git'
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :rvm_ruby_version, '2.2.0'

set :rails_root, File.expand_path("../../", __FILE__)+'/'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:application)}"

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{.env config/database.yml config/secrets.yml}

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

%w[scratch base devops nginx unicorn postgresql redis rvm].each do |recipe|
	require_relative "./deploy/recipes/#{recipe}"
end

# before :deploy, "devops:setup"
before "deploy:check:linked_files", "devops:copy"
after :deploy, "nginx:setup"
after :deploy, "unicorn:setup"
after :deploy, "unicorn:restart"

# namespace :deploy do

#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end

# end