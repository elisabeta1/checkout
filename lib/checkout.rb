require "#{File.dirname(__FILE__)}/../lib/promotional_rules"
require "#{File.dirname(__FILE__)}/../lib/product"

class Checkout
  attr_reader :products

  def initialize(promotion_rules = [])
    @promotion_rules = promotion_rules
    @products = []
  end

  def scan(product)
    @products << product
  end

  def before_total
    @products = PromotionalRules.quantity_discount(@products, @promotion_rules)
  end

  def total
    total_amount = 0
    before_total.each do |product|
      total_amount += product.price
    end
    total_amount = PromotionalRules.spending_more_discount(total_amount, @promotion_rules)
  end

end
