class PromotionalRules 
  attr_reader :type, :amount, :value, :code
 
  def initialize(promotion_rules={})
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

  def self.quantity_discount(products, promotion_rules)
    rule = promotion_rules.find { |rule| rule.type == :quantity }
    products_code = products.select { |p| p.code == rule.code }
    if products_code.length >= rule.amount
      products_code.each { |p| p.price = rule.value }
    end
    products
  end

  private

  def self.percentage(total, discount)
    total = total - (total*discount)/100
    total.round(2)
  end
end
