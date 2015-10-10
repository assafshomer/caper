set_if_empty(:redis_port, "6379")

namespace :redis	do
	desc "Install the latest stable release of PostgreSQL."
	task :install do
		on roles(:db) do			
			execute :sudo, "wget http://download.redis.io/redis-stable.tar.gz"
			execute :sudo, "tar xvzf redis-stable.tar.gz"
			execute "cd redis-stable && make"
			execute :sudo, "cp ~/redis-stable/src/redis-server /usr/local/bin/"
			execute :sudo, "cp ~/redis-stable/src/redis-cli /usr/local/bin/"
			execute :sudo, "mkdir -p /etc/redis"
			execute :sudo, "mkdir -p /var/redis"
			execute :sudo, "mkdir -p /var/redis/#{fetch(:redis_port)}"
			execute :sudo,"cp ~/redis-stable/utils/redis_init_script /etc/init.d/redis_#{fetch(:redis_port)}"
			template "redis.conf.erb", "/tmp/#{fetch(:redis_port)}.conf"
			execute :sudo, "cp /tmp/#{fetch(:redis_port)}.conf /etc/redis/#{fetch(:redis_port)}.conf"
		end
	end
end