def load_schema
  config = YAML::load( IO.read( File.dirname(__FILE__) + '/database.yml') )
  ActiveRecord::Base.establish_connection( config['test'] )
  
  unless User.table_exists?

    # Uncomment if your test user has full privileges
    # Manually initialize the database
    # conn = Mysql.real_connect( config['mysql']['host'], config['mysql']['username'], config['mysql']['password'] )
    # conn.query( 'CREATE DATABASE IF NOT EXISTS #{config['mysql']['database']}' )

    ActiveRecord::Base.connection()
    require File.dirname(__FILE__) + '/create_user_table'
    CreateUserTable.up
    
  end
end
