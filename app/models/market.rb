class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  validates :name, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :county, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :lat, presence: true
  validates :lon, presence: true

  def vendor_count
    self.vendors.count
  end

  def self.search(params)
    raise SearchError unless validate_params(params)

    markets = all
    markets = filter(markets, :name, params[:name])
    markets = filter(markets, :city, params[:city])
    markets = filter(markets, :state, params[:state])
    markets
  end

  private

  def self.filter(scope, field, value)
    value.present? ? scope.where("#{field} ILIKE ?", "%#{value}%") : scope
  end

  def self.validate_params(params)
    valid_search_keys = [:name, :city, :state]
    params.keys.any? { |key| valid_search_keys.include?(key.to_sym) }
  end
end