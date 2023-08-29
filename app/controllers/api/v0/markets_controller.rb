class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    # market = Market.find_by(id: params[:id])
    begin
      render json: MarketSerializer.new(Market.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => e
      render json: ErrorSerializer.new(e).serialized_json, status: :not_found 
    end
    # if market
    #   render json: MarketSerializer.new(market)
    # else
    #   render json: { errors: [{ detail: "Couldn't find Market with 'id'=#{params[:id]}" }] }, status: :not_found
    # end
  end
end