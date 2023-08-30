class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  validate :unique_market_vendor_association

  private

  def unique_market_vendor_association
    existing_association = MarketVendor.find_by(market_id: market_id, vendor_id: vendor_id)
    if existing_association
      errors.add(:base, "Market vendor association already exists")
    end
  end
end
