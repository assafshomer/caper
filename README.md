# caper
Deploying a rails app with capistrano

## create rails application locally
```Batchfile
	rails new caper
	echo "rvm use 2.2.0@caper --create" >>  caper/.rvmrc
	cd caper/
```
comment in gems in Default Gemfile
* rubyracer 
* capistrano-rails
```Batchfile
	bundle install
	rails g scaffold article name content:text
	rake db:migrate
```

Ignore db.yml

```Batchfile
	echo "/config/database.yml" >> .gitignore
```

## capify
	
```Batchfile
	cap install .
```

