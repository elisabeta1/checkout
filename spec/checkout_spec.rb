require "#{File.dirname(__FILE__)}/../lib/checkout"
require "#{File.dirname(__FILE__)}/../lib/product"

RSpec.describe Checkout do
  before(:each) do
    @products = []
    @products << Product.new(001, "Travel Card Holder", 9.25)
    @products << Product.new(002, "Personalised cufflinks", 45.00)
    @products << Product.new(003, "Kids T-shirt", 19.95)

    @promotional_rules = []
    # set the promotional rules
    @promotional_rules << PromotionalRules.new(type: :discount, amount: 60, reduce: 10)
    @promotional_rules << PromotionalRules.new(type: :quantity, amount: 2, reduce: 8.50, code: 001)
    @promotional_rules << PromotionalRules.new(type: :multi_buy, amount: 3, code: 003)
  end

  it "Checks the 10% off when are spent more then £60" do
    co = Checkout.new(@promotional_rules)
    co.scan(@products[0])
    co.scan(@products[1])
    co.scan(@products[2])
    expect(co.total).to eq(66.78)
  end

  it "Checks the price of the Travel Card Holder is to 8.50 when 2 are bought" do
    co = Checkout.new(@promotional_rules)
    co.scan(@products[0])
    co.scan(@products[2])
    co.scan(@products[0])
    expect(co.total).to eq(36.95)
  end

  it "Checks that test basket gives 73.76" do
    co = Checkout.new(@promotional_rules)
    co.scan(@products[0])
    co.scan(@products[1])
    co.scan(@products[0])
    co.scan(@products[2])
    expect(co.total).to eq(73.76)
  end

  it "Checks that test basket gives 39.90" do
    co = Checkout.new(@promotional_rules)
    co.scan(@products[2])
    co.scan(@products[2])
    co.scan(@products[2])
    expect(co.total).to eq(39.90)
  end
end