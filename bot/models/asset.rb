class Asset < Sequel::Model
  one_to_many :transactions
	one_to_many :bags
end