FactoryBot.define do
  factory :vendor do
    name { Faker::Company.name }
    description { Faker::Lorem.sentence }
    contact_name { Faker::Name.name }
    contact_phone { Faker::PhoneNumber.phone_number }
    credit_accepted { [true, false].sample }
  end
end
