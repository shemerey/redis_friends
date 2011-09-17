require File.expand_path("../lib/version", __FILE__)

Gem::Specification.new do |s|

  s.name        = "redis_friends"
  s.version     = RedisFriends::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Al Evans"]
  s.email       = ["anejr@alevans.com"]
  s.homepage    = "http://github.com/al-evans"
  s.summary     = "Redis-backed mixin for friends and friends-of-friends"
  s.description = "This Redis-backed mixin adds methods to any user class for making and breaking friendships and for tracking friends and friends-of-friends"

  s.required_rubygems_version = ">= 1.3.6"
  s.add_dependency "rails", "3.0.9"
  s.add_dependency "redis", ">= 2.2.2"

  s.require_paths = ['lib', 'test']

end