require 'byebug'

module Commands
	def parse_sell_transaction
		case message.quick_reply
		when 'CONFIRM' then confirm
		when 'CANCEL' then cancel
		else
		  parse_sell
		end
	end

	def parse_sell
		message.typing_on
	  parse_sell_transaction = /^.*(sell|sold)\s(\d+\.?\d*)\s(\w+)(?:\s.*(?:(at|for)\s(\d+)\s?(bucks|USD|usd|dollars|\$)?))/i
	  matches = parse_sell_transaction.match(message.text)
	  unless parse_sell_transaction.match?(message.text)
	  	message.typing_off
	  	return
	  end
	  transaction = Transaction.new
	  transaction.quantity = matches[2].to_f
	  asset = Asset.where(label: matches[3]).first.id
	  currency = Currency.where(label: matches[6]).first&.id || Currency.where(label: 'USD').first.id
	  transaction.asset_id = asset.id
	  transaction.action = 'buy'
	  transaction.currency_id = currency.id
	  sum = matches[5].to_f
	  transaction.price = if matches[4] == 'for'
	    sum / transaction.quantity.to_f
	  elsif matches[4] == 'at'
	    sum
	  else
	  	Cryptocompare::Price.find(asset, currency)[asset.label][currency.label]
	  end
 
	  transaction.user_id = get_user_info[:id]
	  transaction.save
	  message.typing_off
		"So you sold #{transaction.quantity} #{transaction.asset.label} for #{transaction.quantity*transaction.price.round(2)}?"
	end

	def confirm
		message.typing_on
		Rubotnik.logger.info "Confirmated transaction:#{message.inspect}"
		say "Nice. It's a good price."
		message.typing_off
		stop_thread
	end

	def cancel
		message.typing_on
		Rubotnik.logger.info 'Canceled transaction.'
		say "Oh it seems I didn't get that. Let's try again."
		# TODO: remove last user transaction
		message.typing_off
		stop_thread
	end
end