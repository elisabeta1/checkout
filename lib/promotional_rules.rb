class PromotionalRules 

  attr_reader :type, :amount, :value, :code
  @rules = []

  def initialize(params={})
    @type = params[:type]
    @amount = params[:amount]
    @value = params[:deduct]
    @code = params[:code]
  end

  def self.add(product)
    @rules += product
  end

  def self.sum_discount(total)
    rule = @rules.find { |rule| rule.type == :discount }
    total = percentage(total, rule.value) if total > rule.amount
    total
  end

  def self.quantity_discount(pr_hash, products)
    products.find_all do |product|
      rules = @rules.find_all { |rule| rule.code == product.code }
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
