set_if_empty(:ruby_version, "2.2.0")

namespace :rvm do

	desc "install rvm"
	task :install do
		on roles(:all) do
			execute :sudo, "curl -sSL https://rvm.io/mpapis.asc | gpg --import -"
			execute :sudo, "curl -L https://get.rvm.io | bash -s stable"			
			execute "bash --login rvm requirements"
			execute "bash --login rvm install #{fetch(:ruby_version)}"
			execute "~/.rvm/scripts/rvm use #{fetch(:ruby_version)} --default"
			execute "~/.rvm/scripts/rvm rubygems current"
		end
	end

	desc "install bundler"
	task :bundler do
		on roles(:all) do
			execute "gem install bundler"
		end
	end

	# desc "check if rvm is installed"
	# task :check_rvm do
	# 	on roles(:all) do
	# 		execute %Q{bash --login rvm -v > ~/check_rvm.txt}			
	# 		regex = /rvm\s+\d+\.\d+.\d+\s+\(latest\)\s+by\s+Wayne\s+E\.\s+Seguin/
	# 		output = capture("cat ~/check_rvm.txt").scan(regex)
	# 		output.empty? ? set(:rvm_installed, false) : set(:rvm_installed, true)
	# 	end
	# end

	# desc "check ruby version"
	# task :check_ruby do
	# 	on roles(:all) do
	# 		execute %Q{ruby -v > ~/check_ruby.txt}			
	# 		regex = /#{fetch(:ruby_version)}/
	# 		output = capture("cat ~/check_ruby.txt").scan(regex)
	# 		output.empty? ? set(:ruby_version, false) : set(:ruby_version, true)
	# 	end
	# end

	# desc "install rvm"
	# task :install do
	# 	on roles(:all) do
	# 		execute :sudo, "curl -sSL https://rvm.io/mpapis.asc | gpg --import -"
	# 		execute :sudo, "curl -L https://get.rvm.io | bash -s stable"
	# 		execute "source ~/.rvm/scripts/rvm"
	# 		execute %Q{bash --login rvm install #{fetch(:ruby_version)}}
	# 		execute "source ~/.rvm/scripts/rvm"
	# 		execute %Q{bash --login rvm use #{fetch(:ruby_version)} --default}
	# 	end
	# end

end