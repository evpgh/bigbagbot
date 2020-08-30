require 'dotenv/load' # Use this if you want plain 'rackup' over 'heroku local'
require 'facebook/messenger'
require 'sinatra'
require 'sequel'
require 'logger'
require 'dotenv'
require 'byebug'
env = Dotenv.load('.env')
DB = Sequel.connect("postgres://#{env['PG_USER']}:#{env['PG_PASS']}@#{env['PG_HOST']}:#{env['PG_PORT']}/#{env['PG_DB_NAME']}", max_connections: 10)
DB.loggers << Logger.new($stdout)
Dir["./bot/models/*.rb","./bot/commands/*.rb"].each {|file| require file }
require_relative './bot/bot.rb'

map('/webhook') do
  run Facebook::Messenger::Server
end

# run regular Sinatra too
run Sinatra::Application
