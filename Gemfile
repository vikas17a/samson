source 'https://rubygems.org'

ruby File.read('.ruby-version').strip

gem 'bundler', '>= 1.8.4'

gem 'rails', '~> 4.2.0'
gem 'puma'
gem 'dotenv'

gem 'dogstatsd-ruby', '~> 1.5.0', require: 'statsd'
gem 'goldiloader'
gem 'attr_encrypted', require: false

group :mysql2 do
  gem 'mysql2', '~> 0.3'
end

group :postgres do
  gem 'pg', '~> 0.13'
end

group :sqlite do
  gem "sqlite3"
end

gem 'kaminari'
gem 'soft_deletion', '~> 0.4'
gem 'dalli', '~> 2.7.0'
gem 'active_model_serializers', '~> 0.8.0'
gem 'paper_trail'
gem 'sawyer', '~> 0.5'
gem 'sse-rails-engine', '~> 1.4'


# Hashicorp vault
gem 'vault'

# Logging
gem 'lograge'
gem 'logstash-event'

# Docker
gem 'docker-api'

group :production, :staging do
  gem 'rails_12factor'
  gem 'airbrake', '~> 4.3.0'
  gem 'newrelic_rpm', '>= 3.7.1'
end

group :assets do
  gem 'ngannotate-rails'
  gem 'sass-rails', '~> 5.0'
  gem 'uglifier', '>= 1.3.0'
  gem 'angular-rails-templates'
  gem 'bootstrap-sass'

  source 'https://rails-assets.org' do
    gem 'rails-assets-angular', '~> 1.4.0'
    gem 'rails-assets-angular-mocks'
    gem 'rails-assets-angular-scenario'
    gem 'rails-assets-angular-ui-bootstrap-bower', '~> 0.14'
    gem 'rails-assets-spin'
    gem 'rails-assets-angular-spinner'
    gem 'rails-assets-bootstrap-select'
    gem 'rails-assets-font-awesome', '~> 4.3.0'
    gem 'rails-assets-jquery'
    gem 'rails-assets-jquery-ui'
    gem 'rails-assets-jquery-ujs'
    gem 'rails-assets-moment'
    gem 'rails-assets-rickshaw'
    gem 'rails-assets-typeahead.js'
    gem 'rails-assets-underscore'
    gem 'rails-assets-vis'
    gem 'rails-assets-x-editable'
    gem 'rails-assets-message-center'
    gem 'rails-assets-angular-ui-router'
    gem 'rails-assets-angular-truncate-2'
    gem 'rails-assets-jstimezonedetect', source: 'https://rails-assets.org'
    gem 'rails-assets-jquery-cookie', source: 'https://rails-assets.org'
  end
end

group :no_preload do
  gem 'omniauth', '~> 1.1'
  gem 'omniauth-oauth2', '~> 1.1'
  gem 'omniauth-github', '= 1.1.1'
  gem 'omniauth-google-oauth2', '~> 0.2.4'
  gem 'omniauth-ldap', '>= 1.0.5'
  gem 'octokit', '~> 4.0'
  gem 'faraday-http-cache', '~> 1.1'
  gem 'warden', '~> 1.2'
  gem 'active_hash', '~> 1.0'
  gem 'ansible'
  gem 'github-markdown', '~> 0.6.3'
  gem 'activeresource'
  gem 'coderay', '~> 1.1.0'
  gem 'net-http-persistent'
  gem 'concurrent-ruby'

  Dir[File.join(Bundler.root, 'plugins/*/')].each { |f| gemspec path: f, require: false } # treat included plugins like gems
end

group :development, :staging do
  gem "binding_of_caller"
  gem 'better_errors'
  gem 'rack-mini-profiler'
end

group :development, :test do
  gem 'byebug', require: false
  gem 'bootscale', require: false
  gem 'pry-rails'
  gem 'awesome_print'
  gem 'brakeman', require: false
end

group :test do
  gem 'minitest-rails'
  gem 'maxitest'
  gem 'mocha', require: false
  gem 'webmock', require: false
  gem 'single_cov'
  gem 'simplecov', require: false
  gem 'query_diet'
  gem 'codeclimate-test-reporter', require: false
end
