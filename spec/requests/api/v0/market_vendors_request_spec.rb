require 'rails_helper'

RSpec.describe "MarketVendors", type: :request do
  describe "show vendors from a market" do
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

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      wrong_id = JSON.parse(response.body, symbolize_names: true)
      expect(wrong_id).to have_key(:errors)
      expect(wrong_id[:errors][0]).to have_key(:details)
      expect(wrong_id[:errors][0][:details]).to eq("Couldn't find Market with 'id'=123123123123")
    end
  end

  describe "marketvendors create" do
    let(:vendor) { create(:vendor) }
    let(:market) { create(:market) }

    it "creates a new association between a market and a vendor" do
      headers = { "CONTENT_TYPE" => "application/json" }
      params = { market_id: market.id, vendor_id: vendor.id }

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: params)
      
      expect(response).to be_successful
      expect(response.status).to eq(201)

      response_data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response_data[:attributes]).to have_key(:market_id)
      expect(response_data[:attributes][:market_id]).to be_an(Integer)
      expect(response_data[:attributes]).to have_key(:vendor_id)
      expect(response_data[:attributes][:vendor_id]).to be_an(Integer)
    end

    it "returns a 404 status and an error message" do
      headers = { "CONTENT_TYPE" => "application/json" }
      params = { market_id: 123123123123, vendor_id: vendor.id }

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      wrong_id = JSON.parse(response.body, symbolize_names: true)

      expect(wrong_id).to have_key(:errors)
      expect(wrong_id[:errors][0]).to have_key(:details)
      expect(wrong_id[:errors][0][:details]).to eq("Validation failed: Market must exist")
    end

    it "returns a 400 status and an error message" do
      headers = { "CONTENT_TYPE" => "application/json" }
      invalid_params = { }  

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: invalid_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors][0]).to have_key(:details)
      expect(error_response[:errors][0][:details]).to eq("param is missing or the value is empty: market_vendor")
    end

    it "returns a 422 status and an error message" do
      existing_market_vendor = create(:market_vendor)
      headers = { "CONTENT_TYPE" => "application/json" }
      params = { market_id: existing_market_vendor.market_id, vendor_id: existing_market_vendor.vendor_id }

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: params)

      expect(response).to_not be_successful
      expect(response.status).to eq(422)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors][0]).to have_key(:details)
      expect(error_response[:errors][0][:details]).to eq("Validation failed: Market vendor association already exists")
    end
  end

  describe "marketvendor delete" do
    before do
      @market = create(:market)
      @vendor = create(:vendor)
      @market_vendor = MarketVendor.create!(market_id: @market.id, vendor_id: @vendor.id)
    end

    it "deletes a marketvendor association" do
      headers = { "CONTENT_TYPE" => "application/json" }
      params = { market_id: @market.id, vendor_id: @vendor.id }

      expect(MarketVendor.exists?(params)).to eq(true)

      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: params) 

      expect(MarketVendor.exists?(params)).to eq(false)

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(response.body).to be_blank
    end

    it "returns a 404 status and error message" do
      bad_market_id = 1111111111111
      bad_vendor_id = 2222222222222

      headers = { "CONTENT_TYPE" => "application/json" }
      params = { market_id: bad_market_id, vendor_id: bad_vendor_id }

      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: params) 

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      invalid = JSON.parse(response.body, symbolize_names: true)

      expect(invalid).to have_key(:errors)
      expect(invalid[:errors][0]).to have_key(:details)
      expect(invalid[:errors][0][:details]).to eq("Couldn't find MarketVendor with market_id=#{bad_market_id} and vendor_id=#{bad_vendor_id}")
    end
  end
end