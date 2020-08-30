require 'sequel'
require 'cryptocompare'

db = Sequel.sqlite('dev.db')

db.create_table :users do
	primary_key :id
	String :first_name
	String :last_name
end
db.create_table :transactions do
	primary_key :id
	String :action
	Float :quantity
	Float :price
	foreign_key :currency_id
	foreign_key :user_id
	foreign_key :asset_id
end
db.drop_table :bags
db.create_table :bags do
	primary_key :id
	foreign_key :user_id
	foreign_key :asset_id
	Float :quantity, default: 0
	Float :avg_price, default: 0
end

db.drop_table :assets
db.create_table :assets do
	primary_key :id
	String :label, unique: true
end
db[:assets].insert({label: 'BTC'})

db.drop_table :currencies
db.create_table :currencies do
	primary_key :id
	String :label, unique: true
end
db[:currencies].insert({label: "USD"})

Cryptocompare::CoinList.all['Data'].keys.each do |k|
	db[:assets].insert({label: k})
end