# Mixin module to run a redis DB of user's friends and friends_of_friends

module RedisFriends
  module Friends
    require 'redis'


    def self.included(base) #:nodoc:
      base.extend(ClassMethods)
      if (Rails.configuration.redis_options rescue nil)
        # Rails.logger.info "setting options on inclusion"
        base.set_redis_options(Rails.configuration.redis_options)
      end
    end
    
    def become_friends_with(other_user)
      self.class.make_friendship(self, other_user)
    end
  
    def drop_friendship_with(other_user)
      self.class.break_friendship(self, other_user)
    end
  
    def friends_ids
      self.class.friends_of_user(self)
    end
    
    def friends
      out = []
      friends_ids.each {|id| out << self.class.find(id)}
      out
    end
    
    def is_friend_of?(other_user)
      self.class.friendship_exists?(self, other_user)
    end
  
    def friends_of_friends_ids
      self.class.friends_of_friends_of_user(self)
    end
    
    def friends_of_friends
      out = []
      friends_of_friends_ids.each {|id| out << self.class.find(id)}
      out
    end
    
    def ids_of_mutual_friends_with(other_user)
      self.class.mutual_friends_of_users(self, other_user)
    end
    
    def mutual_friends_with(other_user)
      out = []
      ids_of_mutual_friends_with(other_user).each  {|id| out << self.class.find(id)}
      out
    end
  
    module ClassMethods
      
      @@redis_options = {
        :host => 'localhost',
        :port => '6379',
        :db => 1,
      }
      
      @@key_prefix = 'friend_network'
      
      def set_redis_options(new_options)
        if new_options != @@redis_options
          @@redis_connection.quit rescue nil
          @redis_connection = nil
          @@redis_options.merge!(new_options)
        end
      end
    
      def make_friendship(user, other_user)
        db = self.redis_connection
        db.multi do
          db.sadd("#{self.key_prefix}:#{user.id}", other_user.id)
          db.sadd("#{self.key_prefix}:#{other_user.id}", user.id)
        end
      
      end
    
      def break_friendship(user, other_user)
        db = self.redis_connection
        db.multi do
          db.srem("#{self.key_prefix}:#{user.id}", other_user.id)
          db.srem("#{self.key_prefix}:#{other_user.id}", user.id)
        end
      end
    
      def friends_of_user(user)
        self.redis_connection.smembers("#{self.key_prefix}:#{user.id}")
      end
      
      def friendship_exists?(user, other_user)
        self.redis_connection.sismember("#{self.key_prefix}:#{user.id}", "#{other_user.id}")
      end
    
      def friends_of_friends_of_user(user)
        temp_key = "#{Time.now.to_f}:#{user.id}"
        # puts "temp_key is #{temp_key}"
        user_friends = self.friends_of_user(user)
        user_friends.each do |fid|
          friend_friends = self.redis_connection.smembers("#{self.key_prefix}:#{fid}")
          friend_friends.delete(user.id.to_s)
          # TODO: Update to latest redis gem to do this
          # self.redis_connection.sadd(temp_key, friend_friends)
          friend_friends.each {|fid| self.redis_connection.sadd(temp_key, fid) }
          # puts "size is now #{self.redis_connection.smembers(temp_key).size}"
        end
        out = self.redis_connection.smembers(temp_key)
        self.redis_connection.del(temp_key)
        # puts "User #{user.name}, #{out.size}"
        out
      end
      
      def mutual_friends_of_users(user1, user2)
        self.redis_connection.sinter("#{self.key_prefix}:#{user1.id}", "#{self.key_prefix}:#{user2.id}")
      end
    
      def redis_connection #:nodoc:
        @@redis_connection ||= Redis.new(@@redis_options)
        @@redis_connection
      end
    
      def key_prefix
        'friend_network'
      end
    
    end
  end
  
end