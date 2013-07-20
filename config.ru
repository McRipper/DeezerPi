# encoding: utf-8
require "#{File.dirname(__FILE__)}/config/environment"

run Rack::URLMap.new( "/" => App::Web )

