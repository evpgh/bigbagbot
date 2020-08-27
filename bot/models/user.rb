class User < Sequel::Model
	one_to_many :transactions
	one_to_many :bags

  # def after_create
  #   super
  #   author.increase_post_count
  # end

  # def after_destroy
  #   super
  #   author.decrease_post_count
  # end

  def bag
  	# bought = transactions.select{}
  end
end