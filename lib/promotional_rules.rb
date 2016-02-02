class PromotionalRules 
  attr_reader :type, :amount, :value, :code
  @promotion_rules = []

  def initialize(promotion_rules={})
    @type = promotion_rules[:type]
    @amount = promotion_rules[:amount]
    @value = promotion_rules[:reduce]
    @code = promotion_rules[:code]
  end

  def self.add(product)
    @promotion_rules += product
  end

  def self.spending_more_discount(total)
    rule = @promotion_rules.find { |rule| rule.type == :discount }
    total = percentage(total, rule.value) if total > rule.amount
    total
  end

  def self.quantity_discount(pr_hash, products)
    products.find_all do |product|
      rules = @promotion_rules.find_all { |rule| rule.code == product.code }
      rules.each do |apply_rule|
        product.price = apply_rule.value if pr_hash[apply_rule.code] >= apply_rule.amount
      end
    end
    products
  end

  private

  def self.percentage(total, discount)
    total = total - (total*discount)/100
    total.round(2)
  end
end
