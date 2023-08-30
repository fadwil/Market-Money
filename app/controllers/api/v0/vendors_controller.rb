class Api::V0::VendorsController < ApplicationController
  def index
    begin
      render json: VendorSerializer.new(Market.find(params[:market_id]).vendors)
    rescue ActiveRecord::RecordNotFound => e
      render json: ErrorSerializer.new(e).serialized_json, status: :not_found 
    end
  end
end