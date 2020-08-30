require 'byebug'

module Commands
	def get_all_bags
		user = User.where(fb_id: get_user_info[:id]).first
		if user.nil?
			say "Your bags are empty. Have you bought some crypto recently?" 
			return
		end
		bags = user.bags
		# add all bags pie chart
		if bags.empty?
			say "Your bags are empty. Have you bought some crypto recently?"
			return
		end

		bags.each do |bag|
			message.typing_on
			say "You have #{bag.quantity} #{bag.asset.label}"
			value = (bag.quantity * get_price(bag.asset.label,'USD')).round(2)
			say "💰 #{value}$"

			growth = (get_price(bag.asset.label,'USD')/bag.avg_price * 100 - 100).round(2)
			if growth > 0
				say "📈 +#{growth}%"
			else
				say "📉 -#{growth}%"
			end
			message.typing_off
		end
	end
end