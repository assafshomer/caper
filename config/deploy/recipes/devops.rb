namespace :devops do
	desc "install basics"
	task :install do
		on roles(:web, :app, :db) do
			execute :sudo, "apt-get -y update"
			execute :sudo, "apt-get -y install curl git-core python-software-properties software-properties-common"
		end
	end
	
	desc "Copy files"
	task :copy do
		on roles(:all) do |host|
			set :rails_root, File.expand_path("../../../../", __FILE__)+'/'
			%w(.env config/database.yml).each do |f|
				upload! fetch(:rails_root).to_s+ f , shared_path + f
			end
		end
	end

	# task :gems do
	# 	on roles(:all) do
	# 		execute "echo 'gem: --no-document' > ~/.gemrc"
	# 		execute "echo 'gem: --no-ri --no-rdoc' >> ~/.gemrc"
	# 		execute "cd #{current_path}"
	# 		execute "bundle install"
	# 		# execute :sudo, "gem install bundler"
	# 		# execute :sudo, "gem install rails --version 4.2.0"
	# 	end
	# end

end