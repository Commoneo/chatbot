require 'yaml'

CONFIG = YAML.load( File.new( File.expand_path('../settings.yml', __FILE__) ).read )

if CONFIG['stores']['mongo']['replicaset']
   MongoMapper.connection = Mongo::ReplSetConnection.new(CONFIG['stores']['mongo']['seeds'], :pool_size => 5, :pool_timeout => 5, :name => CONFIG['stores']['mongo']['replicaset'])
else
   MongoMapper.connection = Mongo::Connection.new(CONFIG['stores']['mongo']['host'], CONFIG['stores']['mongo']['port'], :pool_size => 5, :pool_timeout => 5)
end

MongoMapper.database = CONFIG['stores']['mongo']['database']