class Checkout
  attr_accessor :promotional_rules, :items

  def initialize(promotional_rules = nil)
    @promotional_rules  = promotional_rules
    @items              = []
  end

  def codes_with_count
    @items.inject(Hash.new(0)) { |count, item| count[item.code] += 1; count }
  end

  def count_for(item)
    codes_with_count[item.code]
  end

  def scan(item)
    return unless item.is_a? Item
    @items << item
  end

  def total
    sum = @items.map { |item| promotional_rules.discount_on_price item, count_for(item) }.sum
    promotional_rules.discount_over sum
  end
end
