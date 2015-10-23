namespace :devops do
	desc "install basics"
	task :install do
		on roles(:web, :app, :db) do
			execute :sudo, "apt-get -y update"
			execute :sudo, "apt-get -y install curl git-core python-software-properties software-properties-common bundler"
		end
	end

	desc "Copy files"
	task :copy do
		on roles(:app) do
			%w(.env.prod config/database.yml.prod config/secrets.yml.prod).each do |f|
				tmp = f.split('.')
				tmp.pop
				g = tmp.join('.') 
				upload! fetch(:rails_root).to_s+ f , shared_path + g
			end
		end
	end

	desc "for now this is just copying env files"
	task :setup do
		on roles(:app) do
			invoke "devops:install"
			invoke "rvm:install"
			invoke "rvm:bundler"
			invoke "nginx:install"
			invoke "postgresql:install"
			invoke "redis:install"
			invoke "postgresql:setup"
			invoke "devops:reboot"
		end
	end

	task :reboot do
		on roles(:all) do
			execute :sudo "reboot"
		end
	end
	# TODO: split setup by roles

end