require 'spec_helper'
require_relative '../promotional_rules.rb'
require_relative '../item.rb'

RSpec.describe PromotionalRules do
  describe '#discount_over' do
    let!(:discount) { 10.00 }
    let!(:value)    { 100.00 }

    subject { described_class.new(over: { total: value, discount: discount }).discount_over(sum) }

    context 'with a negative value' do
      let!(:sum) { -1.00 }
      it { is_expected.to eq 0.0 }
    end

    context 'with a zero value' do
      let!(:sum) { 0.00 }
      it { is_expected.to eq 0.0 }
    end

    context 'with a value lover than discount criteria' do
      let!(:sum) { 90.00 }
      it { is_expected.to eq sum }
    end

    context 'with a value highter than discount criteria' do
      let!(:sum) { 200.00 }
      it { is_expected.to eq (sum * (100.00 - discount)) / 100.00 }
    end
  end

  describe '#discount_on_price' do
    let!(:item)       { Item.new '001', 'Test', 19.00 }
    let!(:new_price)  { 10.00 }

    subject { described_class.new(price: [code: item.code, count: 1, price: new_price]).discount_on_price(item, 1) }

    context 'with another item' do
      let!(:another_item) { Item.new '002', 'Test', 29.00 }

      subject { described_class.new(price: { code: item.code, count: 1, price: new_price }).discount_on_price(another_item, 2) }

      it { is_expected.to eq another_item.price }
    end

    context 'with item in promotion' do
      it { is_expected.to eq new_price }
    end
  end
end
