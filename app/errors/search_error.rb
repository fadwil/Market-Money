  class SearchError < StandardError
    def initialize(message = "Invalid set of parameters.")
      super(message)
    end
  end