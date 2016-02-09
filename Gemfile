source 'https://rubygems.org'

ruby '2.2.2', engine: 'jruby', engine_version: '9.0.4.0'

gem 'rake'
gem 'beaneater', '~> 1.0.0'
gem 'clockwork'
gem 'cmxl'
gem 'grape'
gem 'grape-entity', '0.4.8'
gem 'faraday'
gem 'jdbc-postgres'
gem 'nokogiri'
gem 'ruby-swagger'
gem 'sepa_king'
gem 'sequel'
gem 'sinatra'
gem 'jdbc-postgres'
gem 'jruby-openssl', '0.9.13' #, '0.8.2' we have to use an old version of jruby-openssl for blebics-wrapper
gem 'puma'

if ENV['EBICS_CLIENT'] == 'Blebics::Client'
  gem 'jruby-openssl', '0.8.2'
  gem 'blebics-wrapper', git: 'git@github.com:railslove/blebics-wrapper.git'
else
  gem 'jruby-openssl', '0.9.13'
  gem 'epics', '~> 1.4.0'
end

group :development, :test do
  gem 'database_cleaner'
  gem 'dotenv'
  gem 'foreman'
  gem 'rspec'
  gem 'guard-rspec', require: false
  gem 'airborne'
  gem 'timecop'
  gem 'webmock'
end
