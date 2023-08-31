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

  describe '.search' do
    it "returns markets based on the provided state parameter" do
      market1 = create(:market, state: "Florida")
      market2 = create(:market, state: "California")

      results = Market.search(state: "Florida")

      expect(results).to include(market1)
      expect(results).not_to include(market2)
    end

    
    
    it "returns markets based on the provided state and city parameters" do
      market1 = create(:market, state: "Florida", city: "Gainesville")
      market2 = create(:market, state: "Florida", city: "Tampa")
      market3 = create(:market, state: "California", city: "Los Angeles")
  
      results = Market.search(state: "Florida", city: "Gainesville")
  
      expect(results).to include(market1)
      expect(results).not_to include(market2, market3)
    end
  
    it "returns markets based on the provided state, city, and name parameters" do
      market1 = create(:market, state: "Florida", city: "Gainesville", name: "Downtown Market")
      market2 = create(:market, state: "Florida", city: "Gainesville", name: "Haile Market")
      market3 = create(:market, state: "California", city: "Los Angeles", name: "Farmers Market")
  
      results = Market.search(state: "Florida", city: "Gainesville", name: "Downtown Market")
  
      expect(results).to include(market1)
      expect(results).not_to include(market2, market3)
    end
  
    it "returns markets based on the provided state and name parameters" do
      market1 = create(:market, state: "Florida", name: "Downtown Market")
      market2 = create(:market, state: "Florida", name: "Haile Market")
      market3 = create(:market, state: "California", name: "Farmers Market")
  
      results = Market.search(state: "Florida", name: "Downtown Market")
  
      expect(results).to include(market1)
      expect(results).not_to include(market2, market3)
    end
  
    it "returns markets based on the provided name parameter" do
      market1 = create(:market, name: "Downtown Market")
      market2 = create(:market, name: "Haile Market")
      market3 = create(:market, name: "Farmers Market")
  
      results = Market.search(name: "Downtown Market")
  
      expect(results).to include(market1)
      expect(results).not_to include(market2, market3)
    end
  end
end
