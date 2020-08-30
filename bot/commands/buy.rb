require 'byebug'
require 'cryptocompare'

module Commands
	def parse_buy_transaction
		case message.quick_reply
		when 'CONFIRM' then confirm
		when 'CANCEL' then cancel
		else
		  parse_buy
		end
	end

	def parse_buy
		message.typing_on
	  parse_buy_regex = /^.*(buy|bought)\s(\d+\.?\d*)\s(\w+)(?:\s.*(?:(at|for)\s(\d+)\s?(bucks|USD|usd|dollars|\$)?))/i
	  matches = parse_buy_regex.match(message.text)
	  unless parse_buy_regex.match?(message.text)
	  	message.typing_off
	  	return
	  end
	  transaction = Transaction.new
	  transaction.quantity = matches[2].to_f
	  asset = Asset.where(label: matches[3]).first
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
		"So you acquired #{transaction.quantity} #{transaction.asset.label} for #{transaction.quantity*transaction.price.round(2)}?"
	end

	def confirm
		message.typing_on
		Rubotnik.logger.info "Confirmated transaction:#{message.inspect}"
		say "Nice. It's a good investment."
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