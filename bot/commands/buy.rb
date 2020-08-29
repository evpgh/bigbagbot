require 'byebug'

module Commands
	def parse_buy_transaction
		message.typing_on
		case message.quick_reply
		when 'CONFIRM' then confirm
		when 'CANCEL' then cancel
		else
		  parse_transaction
		end
	end

	def parse_transaction
	  parse_buy_regex = /^.*(buy|bought)\s(\d+\.?\d*)\s(\w+)(?:\s.*(?:(at|for)\s(\d+)\s?(bucks|USD|usd|dollars|\$)?))/i
	  matches = parse_buy_regex.match(message.text)
	  transaction = Transaction.new
	  transaction.quantity = matches[2].to_f
	  transaction.asset = Asset.where(label: matches[3]).first
	  transaction.action = 'buy'
	  transaction.currency = Currency.where(label: matches[6]).first

	  if matches[4] == 'for'
	    transaction.price = matches[5] / transaction.quantity.to_f
	  elsif matches[4] == 'at'
	    transaction.price = matches[5].to_f
	  else
	  	# TODO get current price
	  end
 
	  current_price = 10


	  transaction.user_id = get_user_info[:id]
	  transaction.save
	  message.typing_off
		"So you acquired #{transaction.quantity} #{transaction.asset.label} for #{transaction.quantity*transaction.price}?"
	end

	def confirm
		Rubotnik.logger.info "Confirmated transaction:#{message.inspect}"
		say "Nice. It's a good investment."
		stop_thread
	end

	def cancel
		Rubotnik.logger.info 'Canceled transaction.'
		say "Oh it seems I didn't get that. Let's try again."
		# TODO: remove last user transaction
		stop_thread
	end
end