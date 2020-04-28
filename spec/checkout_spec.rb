require 'spec_helper'
require_relative '../checkout.rb'
require_relative '../promotional_rules.rb'
require_relative '../item.rb'

RSpec.describe Checkout do
  describe '#promotional_rules' do
    it { is_expected.to respond_to :promotional_rules }
  end

  describe '#scan' do
    it { is_expected.to respond_to :scan }
  end

  describe '#codes_with_count' do
    let!(:checkout) { Checkout.new }
    let!(:item)     {  Item.new '001', 'Red Scarf', 9.25 }

    subject { checkout.codes_with_count }

    context 'with one item' do
      before { checkout.scan item }

      it 'hould return hash with count 1 on added item' do
        is_expected.to include("#{item.code}" => 1)
      end
    end

    context 'with many items' do
      before do
        checkout.scan item
        checkout.scan item
        checkout.scan item
      end

      it 'hould return hash with count on added item' do
        is_expected.to include("#{item.code}" => 3)
      end
    end
  end

  describe '#count_for' do
    let!(:checkout) { Checkout.new }
    let!(:item)     {  Item.new '001', 'Red Scarf', 9.25 }

    subject { checkout.count_for item }

    context 'with one item' do
      before { checkout.scan item }

      it 'hould return count 1 on added item' do
        is_expected.to eq 1
      end
    end

    context 'with many items' do
      before do
        checkout.scan item
        checkout.scan item
      end

      it 'hould return  count on added item' do
        is_expected.to eq 2
      end
    end
  end

  describe '#total' do
    it { is_expected.to respond_to :total }

    describe 'calculates total count of chechout' do
      let!(:promotional_rules) do
        PromotionalRules.new over: { total: 60.00, discount: 10 }, price: [{ code: '001', count: 2, price: 8.5 }]
      end
      let!(:checkout)           { Checkout.new promotional_rules }
      let!(:red_scarf)          { Item.new '001', 'Red Scarf', 9.25 }
      let!(:silver_cufflinks)   { Item.new '002', 'Silver cufflinks', 45.00 }
      let!(:silk_dress)         { Item.new '003', 'Silk Dress', 19.95 }

      before do
        items.each do |item|
          checkout.scan item
        end
      end

      subject { checkout.total }

      context 'whith no repeating items with price value discount' do
        let!(:items) { [red_scarf, silver_cufflinks, silk_dress] }
        it { is_expected.to eq 66.78 }
      end

      context 'whith repeating items reducing total price' do
        let!(:items) { [red_scarf, silk_dress, red_scarf] }
        it { is_expected.to eq 36.95 }
      end

      context 'whith repeating items reducing total price' do
        let!(:items) { [red_scarf, silver_cufflinks, red_scarf, silk_dress] }
        it { is_expected.to eq 73.76 }
      end
    end
  end
end
