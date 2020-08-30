class Transaction < Sequel::Model
	many_to_one :user
	many_to_one :asset
	many_to_one :currency

	def after_save
		super
		bag = Bag.find_or_create(user: user, asset: asset)

		bag.quantity = case action
			when 'buy' then (bag.quantity || 0) + quantity
			when 'sell' then (bag.quantity || 0) - quantity
			else
			  return
			end

		bag.avg_price = ((bag.avg_price * (bag.quantity - quantity)) + (quantity * price))/bag.quantity

		bag.save
	end
end