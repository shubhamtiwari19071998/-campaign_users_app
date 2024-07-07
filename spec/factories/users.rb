# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email { "john.doe@example.com" }
    campaigns_list { [{ campaign_name: "cam1", campaign_id: "id1" }].to_json }
  end
end
