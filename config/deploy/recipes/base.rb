def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

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

namespace :deploy	do
	desc "install basics"
	task :install do
		on roles(:web, :app, :db) do
			execute :sudo, "apt-get -y update"
			execute :sudo, "apt-get -y install curl git-core python-software-properties software-properties-common"
		end
	end
end