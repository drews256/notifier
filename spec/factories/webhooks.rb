FactoryBot.define do
  factory :webhook do
    name 'webhook 1'
    url 'https://weather-alerts.com/api'
    zip_code 10000
  end
end
