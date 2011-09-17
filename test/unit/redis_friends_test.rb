require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  load_schema
  
  def setup
    User.delete_all
    @u0 = User.create(:name => 'A1', :email => 'a1@a.com')
    @u1 = []
    @u2 = []
    (0..9).each do |n|
      u = User.create(:name => "B#{n}", :email => "b#{n}@b.com")
      @u0.become_friends_with(u) if n.even?
      @u1 << u
    end
    (0..9).each do |n|
      @u2 << User.create(:name => "C#{n}", :email => "c#{n}@b.com")
    end
  end
  
  test '@u0 should have 5 friends' do
    assert_equal 5, @u0.friends_ids.size
    friends = @u0.friends.sort {|a, b| a.id <=> b.id} 
    (0..4).each do |n|
      assert_equal friends[n], @u1[2 * n]
    end
  end
  
  test '@u0 should have no friends of friends' do
    assert_equal 0, @u0.friends_of_friends_ids.size
  end
  
  test 'if @u1[2] becomes friends with all of @u2, @u0 should have 10 friends_of_friends' do
    (0..9).each do |n|
      @u1[2].become_friends_with(@u2[n])
    end
    assert_equal 11, @u1[2].friends_ids.size
    assert @u0.is_friend_of?(@u1[2])
    assert_equal 10, @u0.friends_of_friends_ids.size
  end
  
  test 'if @u1[2] becomes friends with all of @u2, then @u0 drops friendship with @u1[2], @u0 should have no friends_of_friends' do
    (0..9).each do |n|
      @u1[2].become_friends_with(@u2[n])
    end
    # 5 friends, 10 friends_of_friends
    assert_equal 5, @u0.friends_ids.size
    assert_equal 10, @u0.friends_of_friends_ids.size
    @u0.drop_friendship_with(@u1[2])
    # now 4 friends, 0 friends_of_friends
    assert_equal 4, @u0.friends_ids.size
    assert_equal 0, @u0.friends_of_friends_ids.size
  end
  
  test '@u0 and @u1[2] become friends with @u2[2]' do
    @u0.become_friends_with(@u2[2])
    @u1[2].become_friends_with(@u2[2])
    assert_equal [@u2[2]], @u0.mutual_friends_with(@u1[2]) 
    assert_equal [@u1[2]], @u0.mutual_friends_with(@u2[2]) 
    assert_equal [@u0], @u2[2].mutual_friends_with(@u1[2]) 
  end
  
  def teardown
    db = User.redis_connection
    db.keys("#{User.key_prefix}*").each {|k| db.del k}
  end
  
end
