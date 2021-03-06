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

	desc "check if db alread exists"
	task :check_db do
		on roles(:db) do
			execute :sudo, %Q{-u postgres psql -c "\\list" > ~/checkdb.txt}
			output = capture("cat ~/checkdb.txt")
			if output =~ /#{fetch(:postgresql_database)}/
				set(:db_exists, true)
			else
				set(:db_exists, false)
			end
		end
	end

	desc "check if db user exists"
	task :check_user do
		on roles(:db) do
			execute :sudo, %Q{-u postgres psql -c "\\list" > ~/checkdb.txt}
			output = capture("cat ~/checkdb.txt")
			if output =~ /\s*\w+\s*\|\s*#{fetch(:postgresql_user)}/
				set(:user_exists, true)
			else
				set(:user_exists, false)
			end
		end
	end	

	desc "Create a database for this application."
	task :create_database do
		on roles(:db) do
			if fetch(:user_exists)
				puts "db user [#{fetch(:postgresql_user)}] already exists, skipping.."
			else
				execute :sudo, %Q{-u postgres psql -c "create user #{fetch(:postgresql_user)} with password '#{fetch(:postgresql_password)}';"}				
			end			
			if fetch(:db_exists)
				puts "db [#{fetch(:postgresql_database)}] already exists, skipping.."
			else
				execute :sudo, %Q{-u postgres psql -c "create database #{fetch(:postgresql_database)} owner #{fetch(:postgresql_user)};"}				
			end
		end
	end

	desc "check db and create unless already exist"
	task :setup do
		on roles(:db) do
			invoke "postgresql:check_user"
			invoke "postgresql:check_db"
			invoke "postgresql:create_database"
		end
	end

end