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

	desc "Copy files"
	task :copy do
		on roles(:all) do
			%w(foo.erb).each do |f|
				upload! fetch(:rails_root).to_s+'config/deploy/aux/'+f, shared_path + f
			end
		end
	end

	task :tmp do		
		on roles(:all) do
			template "foo.erb", "#{shared_path}/buz.txt"
		end
	end

end