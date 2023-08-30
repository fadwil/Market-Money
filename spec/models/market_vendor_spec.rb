require 'rails_helper'

RSpec.describe MarketVendor, type: :model do
  describe "relationships" do
    it { should belong_to :market }
    it { should belong_to :vendor }
  end

  describe "custom validation" do
    it "returns error if MarketVendor exists" do
      market = create(:market)
      vendor = create(:vendor)
      MarketVendor.create!(market_id: market.id, vendor_id: vendor.id)

      same_market_vendor = MarketVendor.new(market: market, vendor: vendor)

      expect(same_market_vendor).to_not be_valid

      expect(same_market_vendor.errors[:base]).to include("Market vendor association already exists")
    end

    it 'is valid if association does not exist' do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor = MarketVendor.new(market: market, vendor: vendor)

      expect(market_vendor).to be_valid
    end
  end
end
