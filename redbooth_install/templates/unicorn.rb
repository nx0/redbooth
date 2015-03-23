# Working application directory
working_directory "/var/www/rest_api/"

# Unicorn PID file location
pid "/var/www/rest_api/pids/unicorn.pid"

# Path to logs
stderr_path "/var/www/rest_api/log/unicorn.log.err"
stdout_path "/var/www/rest_api/log/unicorn.log.out"

# Unicorn socket
#listen "/tmp/unicorn.sock"
listen 8484

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30
