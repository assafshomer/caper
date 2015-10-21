# config valid only for current version of Capistrano
lock '3.4.0'
set :application, 'caper'
set :deploy_user, 'deploy'
set :repo_url, 'git@github.com:assafshomer/caper.git'

set :rvm_ruby_version, '2.2.0'
set :rails_root, File.expand_path("../../", __FILE__)+'/'
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

%w[scratch base devops nginx unicorn postgresql redis rvm].each do |recipe|
	require_relative "./deploy/recipes/#{recipe}"
end
# require_relative "./deploy/recipes/scratch"
# require_relative "./deploy/recipes/base"
# require_relative "./deploy/recipes/devops"
# require_relative "./deploy/recipes/postgresql"
# require_relative "./deploy/recipes/redis"
# require_relative "./deploy/recipes/unicorn"

# before :deploy, "devops:install"
# before :deploy, "rvm:install"
# before :deploy, "nginx:install"
# before :deploy, "postgresql:install"
# before :deploy, "redis:install"
# before :deploy, "postgresql:setup"

# before :deploy, "devops:setup"
before "deploy:check:linked_dirs", "devops:copy"
after :deploy, "nginx:setup"
after :deploy, "unicorn:setup"
after :deploy, "unicorn:restart"



# after "devops:install", "postgresql:install"
# after "postgresql:install", "postgresql:check_db"
# after "postgresql:check_db", "postgresql:create_database"
# after "postgresql:create_database", "redis:install"
# after "redis:install", "nginx:install" 
# after "nginx:install", "devops:copy"
# after "devops:copy", "nginx:setup"
# after "nginx:setup", "unicorn:setup"

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