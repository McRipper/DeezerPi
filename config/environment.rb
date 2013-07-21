# encoding: utf-8

$env = (ENV['RACK_ENV'].nil? ? "development" : ENV['RACK_ENV'])

require 'bundler'
Bundler.require(:default, $env.to_sym)

::AppConfig = OpenStruct.new(YAML.load_file(File.dirname(__FILE__) + "/config.yml"))

Rabl.register!

Rabl.configure do |config|
  config.include_json_root = false
  config.enable_json_callbacks = true
end

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/database.db")

Dir[File.dirname(__FILE__) + "/../config/initializers/*.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/../app/model/*.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/../lib/*.rb"].each {|file| require file }
Dir[File.dirname(__FILE__) + "/../app/controller/*.rb"].each {|file| require file }

DataMapper.finalize
DataMapper.auto_upgrade!
