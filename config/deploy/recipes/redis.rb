
namespace :redis	do
	desc "Install the latest stable release of PostgreSQL."
	task :install do
		on roles(:db) do			
			execute :sudo, "wget http://download.redis.io/redis-stable.tar.gz"
			execute :sudo, "tar xvzf redis-stable.tar.gz"
			execute "cd redis-stable && make"
			execute :sudo, "cp ~/redis-stable/src/redis-server /usr/local/bin/"
			execute :sudo, "cp ~/redis-stable/src/redis-cli /usr/local/bin/"
		end
	end
end