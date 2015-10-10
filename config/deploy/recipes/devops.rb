namespace :devops do
   desc "Copy files"
   task :copy do
      on roles(:all) do |host|
				set :rails_root, File.expand_path("../../../../", __FILE__)+'/'
				%w(.env config/database.yml).each do |f|
				  upload! fetch(:rails_root).to_s+ f , shared_path + f
				end
      end
   end
end