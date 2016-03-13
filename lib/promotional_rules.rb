class PromotionalRules 
  attr_reader :type, :amount, :value, :code
 
  def initialize(promotion_rules=[])
    @type = promotion_rules[:type]
    @amount = promotion_rules[:amount]
    @value = promotion_rules[:reduce]
    @code = promotion_rules[:code]
  end

  def self.spending_more_discount(total, promotion_rules)
    rule = promotion_rules.find { |rule| rule.type == :discount }
    total = percentage(total, rule.value) if total > rule.amount
    total
  end

  def self.multibuyers(products, promotion_rules)
    discount = 0 
    rules = promotion_rules.select { |rule| rule.type == :multi_buy }
    rules.map do |rule|
      products_code = products.select { |p| p.code == rule.code }
      free_products = products_code.count/rule.amount
      product_price = products_code.first.price
      discount += free_products * product_price
    end 
    discount
  end

  def self.quantity_discount(products, promotion_rules)
    discount = 0
    rules = promotion_rules.select { |rule| rule.type == :quantity }
    rules.map do |rule|
      products_code = products.select { |p| p.code == rule.code }
      if products_code.length >= rule.amount
        products_code.map do |product|
          discount += product.price - rule.value
        end
      end
    end
    discount
  end

  private

  def self.percentage(total, discount)
    total = total - (total*discount)/100   
  end
end
