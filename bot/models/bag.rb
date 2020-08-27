class Bag < Sequel::Model
	many_to_one :user
  many_to_one :asset
end