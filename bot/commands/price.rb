require 'cryptocompare'

module Commands
  def get_price(asset, currency)
  	Cryptocompare::Price.find(asset, currency)[asset][currency]
	end
end