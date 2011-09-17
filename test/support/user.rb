class User < ActiveRecord::Base
  include RedisFriends::Friends
end