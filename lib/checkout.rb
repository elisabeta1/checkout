require "#{File.dirname(__FILE__)}/../lib/promotional_rules"
require "#{File.dirname(__FILE__)}/../lib/product"
require 'pry'

class Checkout
  def initialize (rules)
    @products = []
    @products_hash = {}
    PromotionalRules.add(rules)
  end

  def scan(product)
    @products << product
    @products_hash[product.code] ||= 0
    @products_hash[product.code] += 1
  end

  def total
    sum = 0
    @products = PromotionalRules.quantity_discount(@products_hash, @products)
    
    @products.each do |product|
      sum += product.price
    end
    sum = PromotionalRules.sum_discount(sum)
  end

end
