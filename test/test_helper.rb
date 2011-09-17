ENV['RAILS_ENV'] = 'test'

require 'rubygems'
require 'bundler'
Bundler.setup

require 'rails/all'
require 'rails/test_help'

support_dir = File.dirname(__FILE__) + '/support'

require 'redis_friends'
require "#{support_dir}/schema"
require "#{support_dir}/user"

