set_if_empty(:unicorn_user, fetch(:deploy_user))
set_if_empty(:unicorn_pid, "#{shared_path}/config/unicorn.pid")
set_if_empty(:unicorn_config, "#{shared_path}/config/unicorn.rb")
set_if_empty(:unicorn_log, "#{shared_path}/log/unicorn.log")
set_if_empty(:unicorn_workers, 2)

namespace :unicorn do
  desc "Setup Unicorn initializer and app configuration"
  task :setup do
    on roles(:app) do
      execute :sudo, "mkdir -p #{shared_path}/config"
      execute :sudo, "mkdir -p #{shared_path}/log"
      execute :sudo, "chmod -R 777 #{shared_path}/log"
      template "unicorn.rb.erb", "/tmp/unicorn.rb"
      execute :sudo, "mv /tmp/unicorn.rb #{fetch(:unicorn_config)}"
      template "unicorn_init.erb", "/tmp/unicorn_init"
      execute :sudo, "chmod +x /tmp/unicorn_init"
      execute :sudo, "mv /tmp/unicorn_init /etc/init.d/unicorn_#{fetch(:application)}"
      execute :sudo, "update-rc.d -f unicorn_#{fetch(:application)} defaults"
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command do
      on roles(:app) do
        within current_path do
          # puts capture(:env)
          execute :sudo, "service unicorn_#{fetch(:application)} #{command}"
        end
      end      
    end    
  end

  # task :start do
  #   on roles(:app) do
  #     within current_path do
  #       puts capture(:env)
  #       execute "/etc/init.d/unicorn_#{fetch(:application)} start"
  #     end
  #   end
  # end
end