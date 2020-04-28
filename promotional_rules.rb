class PromotionalRules
  def initialize rules={}
    @rules = rules
  end

  def discount_on_price(item, count)
    if @rules[:price].is_a? Array
      @rules[:price].each do |promotion|
        return promotion[:price] if promotion[:code] == item.code && promotion[:count] <= count
      end
    end

    item.price
  end

  def discount_over(sum)
    return 0.0 if sum.to_f <= 0.0

    if @rules[:over].is_a? Hash
      return ((sum * (100.00 - @rules[:over][:discount].to_f)) / 100.00).round(2) if sum > @rules[:over][:total]
    end

    sum
  end
end
