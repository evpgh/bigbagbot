require 'sequel'
require 'cryptocompare'
require 'dotenv'
require 'byebug'
require 'logger'

config = File.absolute_path(File.join(File.expand_path(__FILE__), '..', '..', '.env'))
env = Dotenv.load(config)

db = Sequel.connect(env['DATABASE_URL'] || ENV['DATABASE_URL'], max_connections: 10)

db.drop_table :users if db.table_exists?(:users)
db.create_table :users do
	primary_key :id
	String :first_name
	String :last_name
end
db.run <<-SQL
ALTER TABLE users
ALTER COLUMN id TYPE bigint
SQL

db.drop_table :transactions if db.table_exists?(:transactions)
db.create_table :transactions do
	primary_key :id
	String :action
	Float :quantity
	Float :price
	foreign_key :currency_id
	foreign_key :user_id
	foreign_key :asset_id
end

db.drop_table :bags if db.table_exists?(:bags)
db.create_table :bags do
	primary_key :id
	foreign_key :user_id
	foreign_key :asset_id
	Float :quantity, default: 0
	Float :avg_price, default: 0
end

db.drop_table :assets if db.table_exists?(:assets)
db.create_table :assets do
	primary_key :id
	String :label, unique: true
end

db.drop_table :currencies if db.table_exists?(:currencies)
db.create_table :currencies do
	primary_key :id
	String :label, unique: true
end
db[:currencies].insert({label: "USD"})

Cryptocompare::CoinList.all['Data'].keys.each do |k|
	db[:assets].insert({label: k})
end