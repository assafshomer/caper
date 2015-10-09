set_if_empty(:postgresql_host, "localhost")
set_if_empty(:postgresql_user, fetch(:application))
ask(:pg_password, nil, echo: false) 
set_if_empty(:postgresql_password, fetch(:pg_password))
set_if_empty(:postgresql_database, "#{fetch(:application)}_production")

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