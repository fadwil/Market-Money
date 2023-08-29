require 'rails_helper'

RSpec.describe Market, type: :model do
  describe "relationships" do
    it { should have_many :market_vendors }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :street }
    it { should validate_presence_of :city }
    it { should validate_presence_of :county }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :lat }
    it { should validate_presence_of :lon }
  end

  describe "model methods" do
    it "returns count of vendors" do
      market = create(:market)

      expect(market.vendor_count).to eq(0)

      vendors = create_list(:vendor, 3)
      vendors.each do |vendor|
        MarketVendor.create(market_id: market.id, vendor_id: vendor.id)
      end

      expect(market.vendor_count).to eq(3)
    end
  end
end
