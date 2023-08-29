class VendorSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :contact_name, :contact_phone, :credit_accepted

  has_many :markets
end
