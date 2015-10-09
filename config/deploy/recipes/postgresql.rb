set_if_empty(:postgresql_host, "localhost")
set_if_empty(:postgresql_user, fetch(:application)) 
# set_if_empty(:postgresql_password) { Capistrano::CLI.password_prompt "PostgreSQL Password: " }
# set_if_empty(:postgresql_database) { "#{application}_production" }

namespace :postgresql	do
	desc "Install the latest stable release of PostgreSQL."
	task :install do
		on roles(:db) do			
			# execute :sudo, "add-apt-repository ppa:pitti/postgresql" # deprecated
			# execute :sudo, "apt-get -y update"
			execute :sudo, "apt-get -y install postgresql libpq-dev"
		end
	end
	after "deploy:install", "postgresql:install"
end