server {
	listen 9999;
	server_name <%= HTTP_IP =>;

	root /var/www/rest_api/;
	
	try_files $uri/index.html $uri @app;

	location / {
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header Host $http_host;
		proxy_pass http://localhost:8484/;
    }

    error_page 500 502 503 504 /500.html;
    client_max_body_size 4G;
    keepalive_timeout 10;
}
