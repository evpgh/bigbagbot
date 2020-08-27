class Transaction < Sequel::Model
	many_to_one :user
	many_to_one :asset
	many_to_one :currency
end