class Api::V0::MarketVendorsController < ApplicationController
  def create
    begin
      render json: MarketVendorSerializer.new(MarketVendor.create!(market_vendor_params)), status: :created
    rescue ActionController::ParameterMissing => e
      render json: ErrorSerializer.new(e).serialized_json, status: :bad_request 
    rescue ActiveRecord::RecordInvalid => e
      custom_error_message(e)
    end
  end

  private
    def market_vendor_params
      params.require(:market_vendor).permit(:market_id, :vendor_id)
    end

    def custom_error_message(error)
      if error.message.include?("must exist")
        render json: ErrorSerializer.new(error).serialized_json, status: :not_found
      elsif error.message.include?("already exists")
        render json: ErrorSerializer.new(error).serialized_json, status: :unprocessable_entity
      end
    end
end