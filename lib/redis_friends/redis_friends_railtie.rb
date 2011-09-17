require 'rails'
require 'redis_friends'

module RedisFriends
  
  class RedisFriendsRailtie < ::Rails::Railtie
    # Rails.logger.info "In Railtie"
    # after_initialize do 
    # initializer "set redis connection" do #, :after => :engines_blank_point do
    # to_prepare do
    #   User.set_redis_options({:db => 4})
    #   # Rails.logger.info "On entry: #{Rails.configuration.redis_options.inspect}"
    #   # if Rails.configuration.redis_options
    #   #   # Have to fine the classes that include us
    #   #   results = []
    #   #   ObjectSpace.each_object(Class) do |klass|
    #   #     results << klass if  RedisFriends::Friends > klass
    #   #   end
    #   #   Rails.logger.info "#{results.inspect}"
    #   #   results.each {|klass| klass.set_redis_options(Rails.configuration.redis_options)}
    #   # end
    # end
    # initializer "redis_friends.add_to_prepare" do |app|
    # config.to_prepare do
    #   Rails.logger.info "in to_prepare"
    #   puts "in to_prepare"
    #     Rails.logger.info "On entry: #{Rails.configuration.redis_options.inspect}"
    #     if Rails.configuration.redis_options
    #       # Have to find the classes that include us
    #       results = []
    #       ObjectSpace.each_object(Class) do |klass|
    #         results << klass  if   (RedisFriends::Friends > klass)
    #       end
    #       Rails.logger.info "included by: #{results.inspect}"
    #       results.each {|klass| klass.set_redis_options(Rails.configuration.redis_options)}
    #     end
    # end
  end
  
end