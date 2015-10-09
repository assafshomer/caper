namespace :test	do
	desc "test sudo on server"
	tmp = "foo_#{rand(100)}"
	task :cpfile  do
		on roles(:web, :app, :db) do
			execute "echo 'hello #{tmp}' > ~/#{tmp}.txt"
			execute :sudo, "cp ~/#{tmp}.txt /#{tmp}"
		end
	end
end