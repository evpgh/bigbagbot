require 'byebug'

module Commands
	def get_all_bags
		bags = User.where(id: get_user_info[:id]).first&.bags
		# add all bags pie chart
		say "Your bags are empty. Have you bought some crypto recently?" if bags.empty?

		bags.each do |bag|
			message.typing_on
			say "You have #{bag.quantity} #{bag.asset.label}"
			value = (bag.quantity * get_price(bag.asset.label,'USD')).round(2)
			say "💰 #{value}$"

			pie_chart.data bag.asset.label, value

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