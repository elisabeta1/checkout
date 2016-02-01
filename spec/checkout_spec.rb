require "#{File.dirname(__FILE__)}/../lib/checkout"
require "#{File.dirname(__FILE__)}/../lib/product"

RSpec.describe(Checkout) do
  before(:each) do
    @products = []
    @products << Product.new(001, "Travel Card Holder", 9.25)
    @products << Product.new(002, "Personalised cufflinks", 45.00)
    @products << Product.new(003, "Kids T-shirt", 19.95)

    @promotional_rules = []
    
    @promotional_rules << PromotionalRules.new(:type => :discount, :amount => 60, :deduct => 10)
   
    @promotional_rules << PromotionalRules.new(:type => :count, :amount => 2, :code => 001, :deduct => 8.50)
  end

  it "Checks the total of 3 products if will get the 10% off" do
    co = Checkout.new(@promotional_rules)
    co.scan(@products[0])
    co.scan(@products[1])
    co.scan(@products[2])
    expect(co.total).to eq(66.78)
  end

  it "Checks that the price of the Travel Card Holder is to 8.50 when 2 are bought" do
    co = Checkout.new(@promotional_rules)
    co.scan(@products[0])
    co.scan(@products[2])
    co.scan(@products[0])
    expect(co.total).to eq(36.95)
  end

  it "Checks that test basket one gives 73.76" do
    co = Checkout.new(@promotional_rules)
    co.scan(@products[0])
    co.scan(@products[1])
    co.scan(@products[0])
    co.scan(@products[2])
    expect(co.total).to eq(73.76)
  end


end