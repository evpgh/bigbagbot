require 'byebug'

module Commands
	def parse_buy_transaction(message)
	  parse_buy_regex = /^.*(buy|bought)\s(\d+\.?\d*)\s(\w+)(?:\s.*(?:(at|for)\s(\d+)\s(usd|dollars|\$)?))/i
	  matches = parse_buy_regex.match(message)
	  transaction = Transaction.new
	  transaction.quantity = matches[2].to_f
	  transaction.asset = Asset.where(label: matches[3]).first
	  transaction.action = 'buy'
	  transaction.currency = Currency.where(label: matches[6]).first

	  if matches[4] == 'for'
	    total_paid = matches[5]
	  elsif matches[4] == 'at'
	    total_paid = quantity.to_f * price.to_f
	  end
	  
	  current_price = 10

	  transaction.price = (total_paid || current_price).to_f
	  transaction
	end
end