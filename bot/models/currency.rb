class Currency < Sequel::Model
  one_to_many :transactions
end