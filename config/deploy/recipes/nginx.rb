set_if_empty(:nginx_config, "/etc/nginx/sites-enabled/#{fetch(:application)}")
set_if_empty(:nginx_ppa, "deb http://ppa.launchpad.net/nginx/stable/ubuntu lucid main")
set_if_empty(:nginx_list, "/etc/apt/sources.list.d/nginx-stable-lucid.list")
set_if_empty(:nginx_key, "adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C")
namespace :nginx do
  desc "Install latest stable release of nginx"
  task :install do
    on roles(:web) do
      # execute :sudo, "add-apt-repository ppa:nginx/stable"
      execute %Q(echo '#{fetch(:nginx_ppa)}' > '/tmp/nginx_list')
      execute :sudo, "mv /tmp/nginx_list #{fetch(:nginx_list)}"
      execute :sudo, %Q(apt-key #{fetch(:nginx_key)})
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get -y install nginx"      
    end
  end

  desc "Setup nginx configuration for this application"
  task :setup do
    on roles(:web) do
      template "nginx_unicorn.erb", "/tmp/nginx_conf"
      execute :sudo, "mv /tmp/nginx_conf #{fetch(:nginx_config)}"
      execute :sudo, "rm -f /etc/nginx/sites-enabled/default"
      restart      
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command do
      on roles(:web) do
        execute :sudo, "service nginx #{command}"  
      end      
    end
  end

end