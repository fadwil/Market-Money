class ErrorSerializer
  def initialize(error_object)
    @error_object = error_object
  end

  def serialized_json
    {
      "errors": [
        {
          "details": @error_object.message
        }
      ]
    }
  end

  def serialized_doesnt_exist(market_vendor_params)
    {
      "errors": [
        {
          "details": "Couldn't find MarketVendor with market_id=#{market_vendor_params[:market_id]} and vendor_id=#{market_vendor_params[:vendor_id]}"
        }
      ]
    }
  end
end
