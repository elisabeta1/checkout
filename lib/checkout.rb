require "#{File.dirname(__FILE__)}/../lib/promotional_rules"
require "#{File.dirname(__FILE__)}/../lib/product"

class Checkout
  def initialize(promotion_rules)
    @products = []
    @products_hash = {}
    PromotionalRules.add(promotion_rules)
  end

  def scan(product)
    @products << product
    @products_hash[product.code] ||= 0
    @products_hash[product.code] += 1
  end

  def before_total
    @products = PromotionalRules.quantity_discount(@products_hash, @products)
  end

  def total
    total_amount = 0
    before_total.each do |product|
      total_amount += product.price
    end
    total_amount = PromotionalRules.spending_more_discount(total_amount)
  end

end
