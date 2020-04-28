require 'spec_helper'
require_relative '../item.rb'

RSpec.describe Item do

  subject { described_class.new '001', 'test', 9.99 }

  describe '#code' do
    it { is_expected.to respond_to :code }
  end

  describe '#name' do
    it { is_expected.to respond_to :name }
  end

  describe '#price' do
    it { is_expected.to respond_to :price }
  end
end
