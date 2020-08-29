require 'byebug'

module Commands
	def get_all_bags
		bags = User.where(id: get_user_info[:id]).first&.bags
		bags.each do |bag|
			message.typing_on
			say "You have #{bag.quantity} #{bag.asset.label},\
					currently worth: #{bag.quantity * get_price(bag.asset.label,'USD')} $"
			say "That's quite impressive already, you know?"
			message.typing_off
		end
	end
end