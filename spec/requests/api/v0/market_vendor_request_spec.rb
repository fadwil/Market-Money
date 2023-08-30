require 'rails_helper'

describe "market vendor endpoints" do
  it "returns a list of vendors" do
    market = create(:market)
    vendors = create_list(:vendor, 3)
    vendors.each do |vendor|
      MarketVendor.create(market_id: market.id, vendor_id: vendor.id)
    end

    get "/api/v0/markets/#{market.id}/vendors"

    expect(response).to be_successful

    vendors_response = JSON.parse(response.body, symbolize_names: true)
    expect(vendors_response).to have_key(:data) 

    vendors_data = vendors_response[:data]
    expect(vendors_data).to be_an(Array) 

    expect(vendors_data.length).to eq(3) 
    
    vendors_data.each do |vendor|
      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_a(String)

      expect(vendor).to have_key(:type)
      expect(vendor[:type]).to be_a(String)

      expect(vendor).to have_key(:attributes)
      expect(vendor[:attributes]).to be_a(Hash)
      
      expect(vendor[:attributes]).to have_key(:name)
      expect(vendor[:attributes][:name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:description)
      expect(vendor[:attributes][:description]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_name)
      expect(vendor[:attributes][:contact_name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_phone)
      expect(vendor[:attributes][:contact_phone]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:credit_accepted)
      expect(vendor[:attributes][:credit_accepted]).to eq(true).or eq(false)
    end
  end

  it "returns a 404 status and an error message" do
    get "/api/v0/markets/123123123123/vendors"

    expect(response.status).to eq(404)

    wrong_id = JSON.parse(response.body, symbolize_names: true)
    expect(wrong_id).to have_key(:errors)
    expect(wrong_id[:errors][0]).to have_key(:details)
    expect(wrong_id[:errors][0][:details]).to eq("Couldn't find Market with 'id'=123123123123")
  end
end