	$pathx = "/usr/bin:/bin/:/sbin/"

	# DEPENDENCIES
	package { ['rake', 'curl', 'nginx', 'libmysqlclient-dev']: 
		ensure	=> installed
	}

	exec {'key':
		path 	=> $pathx,
		command	=> "curl -sSL https://rvm.io/mpapis.asc | gpg --import -",
	}

	exec { 'RVM':
		path => $pathx,
		command		=> "curl -L https://get.rvm.io | bash -s stable --rails",
		require		=> [ Package['curl'], Exec['key'] ],
		logoutput	=> true,
		timeout		=> 1300,
	}
	
	# GEMS NEEDED
	exec { 'gem_unicorn':
		path 	=> $pathx,
		command => "gem install unicorn",
		require => Exec['RVM'],
	}

	exec { 'gem_mysql':
		path 	=> $pathx,
		command => "gem install mysql",
		require	=> Exec['gem_unicorn'],
	}

	package { 'redbooth-rails-app_1.1_all.deb': 
		name		=> redbooth-rails-app,
		ensure		=> installed,
		provider	=> dpkg,
		source		=> "./files/redbooth-rails-app_1.1_all.deb",
	}
	
	# NGINX CONF
	file { '/var/www/rest_api/config/unicorn.conf':
		ensure	=> present,
		content	=> template("unicorn.conf.rb"),
		require	=> Package['redbooth-rails-app'],
	}

	# UNICORN CONF
	file { '/var/www/rest_api/config/unicorn.rb':
		ensure	=> present,
		content	=> template("unicorn.rb"),
		require	=> Package['redbooth-rails-app'],
	}

	# MYSQL DATABASE
	file { '/var/www/rest_api/config/database.yml':
		ensure	=> present,
		content	=> template("database.yml.rb"),
		require	=> Package['redbooth-rails-app'],
	}

	# CREATE DATABASE
	exec { 'db_create':
		path 	=> $pathx,
		command	=> 'bash -c "source /usr/local/rvm/scripts/rvm && cd /var/www/rest_api/ && rake db:create"',
		require	=> [ Package['redbooth-rails-app'], File['/var/www/rest_api/config/unicorn.conf'], File['/var/www/rest_api/config/unicorn.rb'], File['/var/www/rest_api/config/database.yml'] ],
	}

	exec { 'db_migrate':
		path 	=> $pathx,
		command	=> 'bash -c "source /usr/local/rvm/scripts/rvm && cd /var/www/rest_api/ && rake db:migrate"',
		require	=> [ Package['redbooth-rails-app'], File['/var/www/rest_api/config/unicorn.conf'], File['/var/www/rest_api/config/unicorn.rb'], File['/var/www/rest_api/config/database.yml'], Exec['db_create'] ],
	}

	# ENSURE NGINX EXECUTION
	service { 'nginx':
		ensure		=> running,
		enable		=> true,
		hasstatus	=> true,
		hasrestart	=> true,
		require		=> [ Package['redbooth-rails-app'], File['/var/www/rest_api/config/unicorn.conf'], File['/var/www/rest_api/config/unicorn.rb'], File['/var/www/rest_api/config/database.yml'], Package['nginx'], Exec['db_migrate'], Exec['db_create'] ],
	}
