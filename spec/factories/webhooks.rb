FactoryBot.define do
  factory :webhook do
    name 'webhook 1'
    url 'https://my-webhook.com/weather'
    zip_code 10000
  end
end
