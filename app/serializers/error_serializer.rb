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
end
