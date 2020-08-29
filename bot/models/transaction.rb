class Transaction < Sequel::Model
	many_to_one :user
	many_to_one :asset
	many_to_one :currency

	def after_save
		super
		bag = Bag.find_or_create(user: user, asset: asset)
		bag.quantity = (bag.quantity || 0) + quantity
		bag.save
	end
end