namespace :test	do
	desc "test sudo on server"
	tmp = "foo_#{rand(100)}"
	task :cpfile  do
		on roles(:web, :app, :db) do
			execute "echo 'hello #{tmp}' > ~/#{tmp}.txt"
			execute :sudo, "cp ~/#{tmp}.txt /#{tmp}"
		end
	end

	task :ask do
		ask(:foo, 'bar',echo: true)
		puts "ask: [#{fetch(:foo,'default')}]"
	end

	task :root do
		set :rails_env, fetch(:stage)
		puts "rails_env: [#{fetch(:rails_env,'default')}]"
	end	
end