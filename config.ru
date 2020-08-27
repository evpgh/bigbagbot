require 'dotenv/load' # Use this if you want plain 'rackup' over 'heroku local'
require 'facebook/messenger'
require 'sinatra'
require 'sequel'

DB = Sequel.sqlite('./db/dev.db', loggers: [Logger.new($stdout)])
DB.loggers << Logger.new($stdout)
Dir["./bot/models/*.rb"].each {|file| require file }
require_relative './bot/bot.rb'

map('/webhook') do
  run Facebook::Messenger::Server
end

# run regular Sinatra too
run Sinatra::Application
