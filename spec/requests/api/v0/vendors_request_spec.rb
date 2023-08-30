require "rails_helper"

RSpec.describe "vendor endpoints" do
  describe "vendor show" do
    it "returns a single vendor" do
      vendor = create(:vendor)

      get "/api/v0/vendors/#{vendor.id}"

      expect(response).to be_successful

      vendor_data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(vendor_data).to have_key(:id)
      expect(vendor_data[:id]).to be_a(String)

      expect(vendor_data).to have_key(:type)
      expect(vendor_data[:type]).to be_a(String)

      expect(vendor_data).to have_key(:attributes)
      expect(vendor_data[:attributes]).to be_a(Hash)
      
      expect(vendor_data[:attributes]).to have_key(:name)
      expect(vendor_data[:attributes][:name]).to be_a(String)

      expect(vendor_data[:attributes]).to have_key(:description)
      expect(vendor_data[:attributes][:description]).to be_a(String)

      expect(vendor_data[:attributes]).to have_key(:contact_name)
      expect(vendor_data[:attributes][:contact_name]).to be_a(String)

      expect(vendor_data[:attributes]).to have_key(:contact_phone)
      expect(vendor_data[:attributes][:contact_phone]).to be_a(String)

      expect(vendor_data[:attributes]).to have_key(:credit_accepted)
      expect(vendor_data[:attributes][:credit_accepted]).to eq(true).or eq(false)
    end

    it "returns a 404 status and an error message" do
      get "/api/v0/vendors/123123123123"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      wrong_id = JSON.parse(response.body, symbolize_names: true)
      expect(wrong_id).to have_key(:errors)
      expect(wrong_id[:errors][0]).to have_key(:details)
      expect(wrong_id[:errors][0][:details]).to eq("Couldn't find Vendor with 'id'=123123123123")
    end
  end

  describe "vendor create" do
    it "creates a new vendor" do
      vendor_attributes = {
                            name: "Buzzy Bees",
                            description: "local honey and wax products",
                            contact_name: "Berly Couwer",
                            contact_phone: "8389928383",
                            credit_accepted: false
                          }
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_attributes)

      expect(response).to be_successful
      expect(response.status).to eq(201)

      vendor = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_a(String)

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

    it "returns a 400 status and an error message" do 
      vendor_attributes = {
                            name: "Vendor",
                            description: "Local Vendor"
                          }
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_attributes)
      
      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors][0]).to have_key(:details)
    end
  end

  describe "vendor update" do
    it "can update a vendor" do
      vendor = create(:vendor)
      updated_attributes = {
                            contact_name: "Kimberly Couwer",
                            credit_accepted: false
                            }
      headers = {"CONTENT_TYPE" => "application/json"}
      
      patch "/api/v0/vendors/#{vendor.id}", headers: headers, params: JSON.generate(updated_attributes)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      updated_vendor = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(updated_vendor).to have_key(:id)
      expect(updated_vendor[:id]).to be_a(String)

      expect(updated_vendor).to have_key(:type)
      expect(updated_vendor[:type]).to be_a(String)

      expect(updated_vendor).to have_key(:attributes)
      expect(updated_vendor[:attributes]).to be_a(Hash)

      expect(updated_vendor[:attributes][:contact_name]).to eq("Kimberly Couwer")
      expect(updated_vendor[:attributes][:credit_accepted]).to eq(false)
    end

    it "returns a 404 status and an error message for an invalid vendor id" do
      invalid_vendor_id = "123123123123"
      updated_attributes = {
                            contact_name: "Kimberly Couwer",
                            credit_accepted: false
                            }
      headers = { "CONTENT_TYPE" => "application/json" }

      patch "/api/v0/vendors/#{invalid_vendor_id}", headers: headers, params: JSON.generate(updated_attributes)
      
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error_response = JSON.parse(response.body, symbolize_names: true)
      expect(error_response).to have_key(:errors)
      expect(error_response[:errors][0]).to have_key(:details)
    end

    it "returns a 400 status and an error message for missing required attribute" do
      valid_vendor = create(:vendor)
      updated_attributes = {
                            contact_name: "",
                            credit_accepted: false
                            }
      headers = { "CONTENT_TYPE" => "application/json" }

      patch "/api/v0/vendors/#{valid_vendor.id}", headers: headers, params: JSON.generate(updated_attributes)
      
      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error_response = JSON.parse(response.body, symbolize_names: true)
      expect(error_response).to have_key(:errors)
      expect(error_response[:errors][0]).to have_key(:details)
    end
  end

  describe "vendor delete" do
    it "deletes the vendor" do
      vendor = create(:vendor)

      expect{ delete "/api/v0/vendors/#{vendor.id}" }.to change(Vendor, :count).by(-1)

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(response.body).to be_blank
    end

    it "returns a 404 status and an error message" do
      delete "/api/v0/vendors/123123123"
      
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error_response = JSON.parse(response.body, symbolize_names: true)
      expect(error_response).to have_key(:errors)
      expect(error_response[:errors][0]).to have_key(:details)
    end
  end
end