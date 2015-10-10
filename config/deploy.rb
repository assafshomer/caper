# config valid only for current version of Capistrano
lock '3.4.0'
set :application, 'caper'
set :deploy_user, 'deployer'
set :repo_url, 'git@github.com:assafshomer/caper.git'

set :rvm_ruby_version, '2.2.0'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:application)}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{.env config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

require_relative "./deploy/recipes/scratch"
require_relative "./deploy/recipes/base"
require_relative "./deploy/recipes/devops"
# require_relative "./deploy/recipes/rvm"
require_relative "./deploy/recipes/postgresql"

after :deploy, "deploy:install"
after "deploy:install", "devops:copy"
after "devops:copy", "postgresql:install"
after "postgresql:install", "postgresql:check_db"
after "postgresql:check_db", "postgresql:create_database"
# after "postgresql:create_database", "rvm:check"
# after "rvm:check", "rvm:install"






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