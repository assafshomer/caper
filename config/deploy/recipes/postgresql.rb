set_if_empty(:postgresql_host, "localhost")
set_if_empty(:postgresql_user, fetch(:application))
set_if_empty(:postgresql_password, ask(:pg_password, nil, echo: false))
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

	desc "Create a database for this application."
	task :create_database do
		on roles(:db) do
			execute "echo 'user: #{fetch(:postgresql_user)}'"
			execute :sudo, %Q{-u postgres psql -c "create user #{fetch(:postgresql_user)} with password '#{fetch(:postgresql_password)}';"}
			execute :sudo, %Q{-u postgres psql -c "create database #{fetch(:postgresql_database)} owner #{fetch(:postgresql_user)};"}
		end
	end
	after "postgresql:install", "postgresql:create_database"
end