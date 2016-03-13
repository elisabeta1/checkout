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

  def quantity_discount
    PromotionalRules.quantity_discount(@products, @promotion_rules)
  end
  def multibuyers
    PromotionalRules.multibuyers(@products, @promotion_rules)
  end

  def total
    total_amount = 0
    @products.each do |product|

      total_amount += product.price
    end
    total_amount = total_amount - quantity_discount
    total_amount = total_amount - multibuyers
    total_amount = PromotionalRules.spending_more_discount(total_amount, @promotion_rules).round(2)
  end

end
