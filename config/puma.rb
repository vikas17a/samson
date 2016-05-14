threads 8,250
preload_app!
#stdout_redirect 'log/puma.log', 'log/puma_error.log', true
bind 'tcp://0.0.0.0:3000'
