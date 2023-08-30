require 'rails_helper'

describe "market endpoints" do
  it "returns a list of markets" do
    create_list(:market, 3)

    get '/api/v0/markets'

    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(markets.count).to eq(3)

    markets.each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_a(String)

      expect(market).to have_key(:type)
      expect(market[:type]).to be_a(String)

      expect(market).to have_key(:attributes)
      expect(market[:attributes]).to be_a(Hash)
      
      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes][:name]).to be_a(String)

      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes][:street]).to be_a(String)

      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes][:city]).to be_a(String)

      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes][:county]).to be_a(String)

      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes][:state]).to be_a(String)

      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes][:zip]).to be_a(String)

      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes][:lat]).to be_a(String)

      expect(market[:attributes]).to have_key(:lon)
      expect(market[:attributes][:lon]).to be_a(String)

      expect(market[:attributes]).to have_key(:vendor_count)
      expect(market[:attributes][:vendor_count]).to be_a(Integer)
    end
  end

  it "returns a single market" do
    market = create(:market)
    vendors = create_list(:vendor, 3)
    vendors.each do |vendor|
      MarketVendor.create(market_id: market.id, vendor_id: vendor.id)
    end

    get "/api/v0/markets/#{market.id}"

    expect(response).to be_successful

    market_response = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(market_response).to have_key(:id)
    expect(market_response[:id]).to be_a(String)

    expect(market_response).to have_key(:type)
    expect(market_response[:type]).to be_a(String)

    expect(market_response).to have_key(:attributes)
    expect(market_response[:attributes]).to be_a(Hash)

    expect(market_response[:attributes]).to have_key(:name)
    expect(market_response[:attributes][:name]).to be_a(String)

    expect(market_response[:attributes]).to have_key(:street)
    expect(market_response[:attributes][:street]).to be_a(String)

    expect(market_response[:attributes]).to have_key(:city)
    expect(market_response[:attributes][:city]).to be_a(String)

    expect(market_response[:attributes]).to have_key(:county)
    expect(market_response[:attributes][:county]).to be_a(String)

    expect(market_response[:attributes]).to have_key(:state)
    expect(market_response[:attributes][:state]).to be_a(String)

    expect(market_response[:attributes]).to have_key(:zip)
    expect(market_response[:attributes][:zip]).to be_a(String)

    expect(market_response[:attributes]).to have_key(:lat)
    expect(market_response[:attributes][:lat]).to be_a(String)

    expect(market_response[:attributes]).to have_key(:lon)
    expect(market_response[:attributes][:lon]).to be_a(String)

    expect(market_response[:attributes]).to have_key(:vendor_count)
    expect(market_response[:attributes][:vendor_count]).to be_a(Integer)
  end

  it "returns a 404 status and an error message" do
    get "/api/v0/markets/1111111111111111"
    
    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    wrong_id = JSON.parse(response.body, symbolize_names: true)
    expect(wrong_id).to have_key(:errors)
    expect(wrong_id[:errors][0]).to have_key(:details)
    expect(wrong_id[:errors][0][:details]).to eq("Couldn't find Market with 'id'=1111111111111111")
  end
end